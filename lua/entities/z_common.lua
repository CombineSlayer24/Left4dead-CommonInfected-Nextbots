AddCSLuaFile()

ENT.Base = "base_nextbot"
ENT.PrintName = "Common Infected"
ENT.Author = "Pyri"
ENT.IsCommonInfected = true
ENT.IsUnCommonInfected = false
ENT.UnCommonType = ""
ENT.IsWalking = false
ENT.IsRunning = false
ENT.Gender = nil
ENT.IsLyingOrSitting = false
ENT.IsClimbing = false
ENT.HasLanded = false
ENT.Flameproof = false

--- Include files based on sv_ sh_ or cl_
--- These will load z_common files for our common infected to use
local ENT_CommonFiles = file.Find( "left4dead/z_common/*", "LUA", "nameasc" )

for k, luafile in ipairs( ENT_CommonFiles ) do
	if string.StartWith( luafile, "sv_" ) then -- Server Side Files
		include( "left4dead/z_common/" .. luafile )
		print( "Left 4 Dead Common Infected ENT TABLE: Included Server Side ENT Lua File [" .. luafile .. "]" )
	elseif string.StartWith( luafile, "sh_" ) then -- Shared Files
		if SERVER then
			AddCSLuaFile( "left4dead/z_common/" .. luafile )
		end
		include( "left4dead/z_common/" .. luafile )
		print( "Left 4 Dead Common Infected ENT TABLE: Included Shared ENT Lua File [" .. luafile .. "]" )
	elseif string.StartWith( luafile, "cl_" ) then -- Client Side Files
		if SERVER then
			AddCSLuaFile( "left4dead/z_common/" .. luafile )
		else
			include( "left4dead/z_common/" .. luafile )
			print( "Left 4 Dead Common Infected ENT TABLE: Included Client Side ENT Lua File [" .. luafile .. "]" )
		end
	end
end

include("left4dead/autorun_includes/server/netmessages.lua")

-- This might seem reduntant, but trust me, it's not.
-- We create locals of functions so GLua can access them faster
local hook_Run = hook.Run
local SimpleTimer = timer.Simple
local timer_Create = timer.Create
local timer_Adjust = timer.Adjust
local timer_Stop = timer.Stop
local timer_Remove = timer.Remove
local ents_Create = ents.Create
local random = math.random
local Rand = math.Rand
local MathHuge = math.huge
local table_insert = table.insert
local table_Random = table.Random
local table_HasValue = table.HasValue
local table_remove = table.remove
local string_gsub = string.gsub
local string_Explode = string.Explode
local Clamp = math.Clamp
local coroutine_wait = coroutine.wait
local ents_FindInSphere = ents.FindInSphere
local CurTime = CurTime
local IsValid = IsValid
local Vector = Vector
local ents_GetAll = ents.GetAll
local tostring = tostring

local collisionmins = Vector( -12, -12, 0 )
local collisionmaxs = Vector( 8, 10, 72 )
local crouchingcollisionmaxs = Vector( 16, 16, 36 )

-- Convars
local ignorePlys = GetConVar( "ai_ignoreplayers" )
local sv_gravity = GetConVar( "sv_gravity" )
local droppableProps = GetConVar( "l4d_sv_createitems" )
local developer = GetConVar( "developer" )
local z_Difficulty = GetConVar( "l4d_sv_difficulty" )

local ci_BatonModels =
{
	[ "models/infected/c_nb/common_male_police01.mdl" ] = { true, true }, -- This model can have a prop and can be parented
	[ "models/infected/c_nb/trs_common_male_police01.mdl" ] = { true, false }, -- This model can have a prop but cannot be parented
	[ "models/infected/l4d2_nb/uncommon_male_riot.mdl" ] = { true, false } -- This model can have a prop but cannot be parented
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpZombie()
	-- When it comes down to models, we make all of the models available for the player/admins to customize.
	-- Sorta similar to how the population is handled in L4D2.
	-- Should the player only want Military, Police, Rural, Common, Hospital, or all of above? ect ect.
	local mdls = {}
	for k, v in pairs( Z_MaleModels ) do table_insert( mdls, v ) end
	for k, v in pairs( Z_FemaleModels ) do table_insert( mdls, v ) end

	-- Now select a random model from the combined table
	local spawnMdl = mdls[ random( #mdls ) ]
	self:SetModel( spawnMdl )
	-- Really need to work on a population manager :(
	--self:SetModel( "models/infected/l4d2_nb/uncommon_male_fallen_survivor.mdl" )

	-- Set Gender based on model
	if table_HasValue( Z_MaleModels, spawnMdl ) then
		self.Gender = "Male"
	elseif table_HasValue( Z_FemaleModels, spawnMdl ) then
		self.Gender = "Female"
	end

	-- from Lambdaplayers
	for _, v in ipairs( self:GetBodyGroups() ) do
		local subMdls = #v.submodels
		if subMdls == 0 then continue end
		self:SetBodygroup( v.id, random( 0, subMdls ) )
	end

	local skinCount = self:SkinCount()
	if skinCount > 0 then self:SetSkin( random( 0, skinCount - 1 ) ) end
end

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	--game.AddParticles( "particles/boomer_fx.pcf" )

	if SERVER then

		self:SetUpZombie()
		self:InitSounds()
		local mdl = self:GetModel()

		self.ci_BehaviorState = "Idle" -- The state for our behavior thread is currently running
		self.ci_lastfootsteptime = 0 -- The last time we played a footstep sound
		self.SpeakDelay = 0 -- the last time we spoke

		local z_Health
		local z_FallenHealth = GetConVar( "l4d_sv_z_fallen_health_multiplier" ):GetInt()
		local z_JimmyHealth = GetConVar( "l4d_sv_z_jimmy_health_multiplier" ):GetInt()

		if self:GetUncommonInf( "FALLEN" ) then
			z_Health = 1000 * ( z_FallenHealth / 20 )
		elseif self:GetUncommonInf( "JIMMYGIBBS" ) then
			z_Health = 3000 * ( z_JimmyHealth / 20 )
		elseif self:GetUncommonInf( "CEDA" ) then
			if z_Difficulty:GetInt() == 0 then
				z_Health = 50
			else
				z_Health = 150
			end
		elseif self:GetUncommonInf( "ROADCREW" ) then
			if z_Difficulty:GetInt() == 0 then
				z_Health = 50
			else
				z_Health = 150
			end
		else
			z_Health = 50
		end

		print(z_Health)

		self:SetMaxHealth( z_Health )
		self:SetHealth( z_Health )

		self:SetShouldServerRagdoll( true )

		if droppableProps:GetBool() then
			local randomValue = random( 100 ) <= 15

			-- Because with TRS police, the baton floats a bit
			-- so we disallow the TRS police baton to be parented
			if ci_BatonModels[ mdl ] and randomValue then
				self:CreateItem( "nightstick", ci_BatonModels[ mdl ] [ 2 ], "baton" )
			elseif self:GetUncommonInf( "CEDA" ) and randomValue then
				self:CreateItem( "bileJar", false, "grenade" )
			end
		end

		self.loco:SetStepHeight( 22 )
		self.loco:SetGravity( sv_gravity:GetFloat() )

		self:SetCollisionBounds( collisionmins, collisionmaxs )
		self:PhysicsInitShadow()
		self:SetSolid( SOLID_BBOX )

		self:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )

		self:SetLagCompensated( true )
		self:AddFlags( FL_OBJECT + FL_NPC )
		self:SetSolidMask( MASK_PLAYERSOLID )

		-- Breathing Anims layer
		self:AddGestureSequence( self:LookupSequence( "idlenoise" ), false )

	elseif CLIENT then
		self.ci_lastdraw = 0
	end
end

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 1, "IsDead" )
end

function ENT:Alive()
	return !self:GetIsDead()
end

function ENT:Nick()
	return self:GetClass()
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Certain Common/Uncommon Infected will have
-- props attached to them... Riot Cops, Cops
-- CEDA, ect. Create some props for them to carry

-- itemName = Prop name in table
-- canparent = Should it parented to the ragdoll on death?
-- id = id attachment name
function ENT:CreateItem( itemName, canparent, id )
	local model = Z_itemModels[ itemName ]
	if !model then return end

	local item = ents_Create( "prop_physics" )
	item:SetModel( model )
	item:SetLocalPos( self:GetPos() )
	item:SetLocalAngles( self:GetAngles() )
	item:SetOwner( self )
	item:SetParent( self )
	item:Fire( "SetParentAttachmentMaintainOffset", id )
	item:Fire( "SetParentAttachment", id )
	item:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
	item:Spawn()
	item:Activate()
	item:SetSolid( SOLID_BSP )

	self.item = item 			-- The prop item
	self.canparent = canparent 	-- Can this prop be parented to ragdoll on death?
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateItemOnDeath( ragdoll )
	local item = self.item
	-- Make this into a convar later
	local dropChance = random( 100 ) <= 60

	if dropChance or !self.canparent then
		item:SetParent( nil )
		item:SetPos( self:GetPos() + Vector( 0, 0, 50 ) )
		item:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
		item:PhysicsInit( SOLID_VPHYSICS )

		local phys = item:GetPhysicsObject()
		if IsValid( phys ) then
			phys:EnableGravity( true )
			phys:Wake()

			-- Apply a force so they fly up or around.
			local randX = random( -1000, 1000 )
			local randY = random( -1000, 1000 )
			local randZ = random( 450, 1000 )
			local force = Vector( randX, randY, randZ )
			local position = item:WorldToLocal( item:OBBCenter() ) + Vector( Rand( 5, 10 ), Rand( 5, 10 ), Rand( -10, 60 ) )
			phys:ApplyForceOffset( force, position )
		end

		SimpleTimer( 15, function()
			if IsValid( item ) then
				item:Remove()
			end
		end)
	else
		-- Parent to the model, don't drop.
		if IsValid( ragdoll ) then
			item:SetParent( ragdoll )
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlaySequenceAndMove( seq, options, callback )
	if isstring( seq ) then seq = self:LookupSequence( seq )
	elseif not isnumber( seq ) then return end
	if seq == -1 then return end
	if isnumber( options ) then options = { rate = options }
	elseif not istable( options ) then options = {} end
	if options.gravity == nil then options.gravity = true end
	if options.collisions == nil then options.collisions = true end
	local previousCycle = 0
	local previousPos = self:GetPos()
	self.loco:SetDesiredSpeed( self:GetSequenceGroundSpeed( seq ) )
	local res = self:PlaySequenceAndWait2( seq, options.rate, function( self, cycle )
		local success, vec, angles = self:GetSequenceMovement( seq, previousCycle, cycle )
		if success then
			vec = Vector( vec.x, vec.y, vec.z )
			vec:Rotate( self:GetAngles() + angles )
			self:SetAngles( self:LocalToWorldAngles( angles ) )
			if ( self:IsInWorld() and self:IsOnGround() ) then
				previousPos = self:GetPos() + vec * self:GetModelScale()
				self:SetPos( previousPos )
			end
		end
		previousCycle = cycle
		if isfunction( callback ) then return callback( self, cycle ) end
	end )
	if not options.gravity then
		self:SetPos( previousPos )
		self:SetVelocity( Vector( 0, 0, 0 ) )
	end
	return res
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlaySequenceAndWait2( seq, rate, callback )
	if isstring( seq ) then seq = self:LookupSequence( seq )
	elseif not isnumber( seq ) then return end
	if seq == -1 then return end
	local current = self:GetSequence()
	self.PlayingAnimSeq = true
	self:SetCycle( 0 )
	self:ResetSequence( seq )
	self:ResetSequenceInfo()
	self:SetPlaybackRate( 1 )
	local now = CurTime()
	self.lastCycle = -1
	self.callback = callback
	timer.Create( "MoveAgain" .. self:EntIndex(), self:SequenceDuration( seq ) - 0.2, 1, function()
		self.PlayingAnimSeq = false
	end )
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlayGesture( activity )
	local seq = self:LookupSequence( activity )
	if seq > 0 then
		self:RestartGesture( self:GetSequenceActivity( seq ), true )
	end
end

hook.Add("ScaleNPCDamage","InfectedDamage", function( npc, hitgroup, dmginfo )
	if npc:GetClass() == "z_common" then
		if npc:GetUncommonInf( "JIMMYGIBBS" ) then
			-- Increase damage if HITGROUP_HEAD
			if hitgroup == HITGROUP_HEAD then
				dmginfo:ScaleDamage( 5 ) -- Increase the damage by 500%
			end
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage( dmginfo )
	local attacker = dmginfo:GetAttacker()

	local armorProtection = GetConVar( "l4d_sv_z_riot_armor_protection" ):GetBool()
	local damageType = dmginfo:GetDamageType()
	if IsValid( attacker ) then
		if self:Health() > 0 then
			if self:GetUncommonInf( "RIOT" ) then
			-- Do something to prevent loops from happening
				local direction = ( attacker:GetPos() - self:GetPos() ):GetNormalized()
				local selfForward = self:GetForward()
				local isAttackerInFront = direction:Dot( selfForward ) > 0

				local DamageToBlock = { DMG_GENERIC, DMG_CLUB, DMG_SLASH, DMG_AIRBOAT, DMG_DIRECT, DMG_SNIPER, DMG_MISSLEDEFENCE, DMG_BUCKSHOT, DMG_BULLET}

				if isAttackerInFront and DamageToBlock[damageType] then
					if armorProtection then
						-- Full protection
						dmginfo:SetDamage( 0 )
					else
						-- Semi Protection
						dmginfo:ScaleDamage( 0.05 )
					end

					if random( 3 ) == 1 then
						self:Vocalize( Zombie_BulletImpact_Riot, true )
					end

					-- Easy there sparkplug
					local effectdata = EffectData()
					effectdata:SetOrigin( dmginfo:GetDamagePosition() )
					util.Effect( "ManhackSparks", effectdata )
				end
			elseif self:GetUncommonInf( "ROADCREW" ) then
				-- Small damage resistance
				dmginfo:ScaleDamage( 0.9 )
			end
		end
	end

	-- If uncommon infected are either CEDA, Fallen or Jimmy Gibbs Jr. will become flameproof
	if self:GetUncommonInf( "CEDA" ) or self:GetUncommonInf( "FALLEN" ) or self:GetUncommonInf( "JIMMYGIBBS" )  then
		self:SetFlameproof( dmginfo )
	end

	--PrintMessage(HUD_PRINTTALK, "Is Flameproof: " .. tostring( self.Flameproof ) )

	-- Insta kill CI if on fire
	if !self.Flameproof and dmginfo:IsDamageType( DMG_BURN ) then
		dmginfo:ScaleDamage( 1.5 )
	end

	-- Play Bullet impact sounds
	if !dmginfo:IsDamageType( DMG_BURN ) and self:Health() > 0 and random( 5 ) == 1 then
		self:Vocalize( Zombie_BulletImpact, true )
	end

	-- Play pain sounds
	if random( 3 ) == 1 then
		self:Vocalize( ZCommon_Pain )
	end

	if !dmginfo:IsDamageType( DMG_BURN ) and self:Health() > 0 and random( 3 ) == 1 then
		self:PlayGesture( "ACT_TERROR_FLINCH" )
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnKilled( dmginfo )
	--hook_Run( "OnNPCKilled", self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	AddZombieDeath(self, dmginfo:GetAttacker(),  dmginfo:GetInflictor())
	local ragdoll = self:BecomeRagdoll( dmginfo )
	ragdoll:SetCollisionGroup( COLLISION_GROUP_DEBRIS )

	self:SetDeathExpression( ragdoll )
	if IsValid( self.item ) then self:CreateItemOnDeath( ragdoll ) end

	self:Vocalize( ZCommon_L4D1_Death )

	-- Suit deflate sound
	if self:GetUncommonInf( "CEDA" ) then
		ragdoll:EmitSound("left4dead/vocals/infected/death/ceda_suit_deflate_0" .. random( 3 ) .. ".wav", 75, random( 90, 100 ), 0.75 )
	end

	if !self.Flameproof and dmginfo:IsDamageType( DMG_BURN ) then
		local burnMat = "models/left4dead/ci_burning"
		ragdoll:Ignite( 5, 0 )
		ragdoll:SetMaterial( burnMat )
	end

	-- Have a chance for the ragdoll to fly around a bit.
	-- Instead of faceplanting if no animations played, they could land
	-- on their back.
	if random( 10 ) == 1 then
		local phys = ragdoll:GetPhysicsObject()
		if IsValid( phys ) then
			local randX = random( -20, 30 )
			local randY = random( -20, 30 )
			local randZ = random( -30, 60 )
			local force = Vector( randX, randY, randZ )

			-- Apply the force at a random point on the ragdoll.
			local position = Vector( 0,0,0 )
			phys:ApplyForceOffset( force, position )
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	-- Initialize self.SpeakDelay
	if !self.SpeakDelay then self.SpeakDelay = CurTime() end

	-- Randomly make noises
	if CurTime() >= self.SpeakDelay then

		if random( 50 ) == 1 then
			if self.ci_BehaviorState == "ChasingVictim" then
				if CurTime() - self.SpeakDelay > Rand( 2.5, 4 ) then
					self:Vocalize( ZCommon_L4D1_RageAtVictim )
					self.SpeakDelay = CurTime()
				end

			elseif self.ci_BehaviorState == "Idle" then
				if CurTime() - self.SpeakDelay > Rand( 2.8, 8 ) then
					self:Vocalize( ZCommon_Idle_Wander )
					self.SpeakDelay = CurTime()
				end
			end
		end
	end

	-- If we are chasing or attacking our prey, look at them.
	if self.ci_BehaviorState == "ChasingVictim" or self.ci_BehaviorState == "AttackingVictim" then
		self:LookAtEntity()
	end

	if SERVER then
		local loco = self.loco
		local locoVel = loco:GetVelocity()
		local onGround = loco:IsOnGround()

		-- Footstep sounds
		if onGround and !locoVel:IsZero() and ( CurTime() - self.ci_lastfootsteptime ) >= self:GetStepSoundTime() then
			self:PlayStepSound()
			self.ci_lastfootsteptime = CurTime()
		end

		-- If we are not on the ground, then we are airborne.
		-- Could cause problems when we try to climb???
		if !self:IsOnGround() then
			self:IsAirborne()
		else
			-- Assume we landed.
			self:DoLandingAnimation()
		end	
	end

	self:NextThink(CurTime())
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- From DRGBase, function updated
function ENT:DirectPoseParametersAt( pos, pitch, yaw, center )
	local isstring = isstring
	local isentity = isentity
	local isvector = isvector
	local AngleDifference = math.AngleDifference
	local GetAngles = self.GetAngles
	local SetPoseParameter = self.SetPoseParameter
	local WorldSpaceCenter = self.WorldSpaceCenter

	if !isstring( yaw ) then
		return self:DirectPoseParametersAt( pos, pitch.."_pitch", pitch.."_yaw", yaw )
	elseif isentity( pos ) then
		pos = pos:WorldSpaceCenter()
	end

	if isvector(pos) then
		center = center or WorldSpaceCenter( self )
		local angle = ( pos - center ):Angle()
		SetPoseParameter( self, pitch, AngleDifference( angle.p, GetAngles( self ).p ) )
		SetPoseParameter( self, yaw, AngleDifference( angle.y, GetAngles( self ).y ) )
	else
		SetPoseParameter(self, pitch, 0)
		SetPoseParameter(self, yaw, 0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:LookAtEntity( ent )
	local enemy = self:FindNearestEnemy()
	if IsValid( enemy ) and enemy:GetBonePosition( 1 ) then
		local distance = self:GetPos():Distance( enemy:GetPos() )

		-- Look at out prey
		if distance < 700 then
			self:DirectPoseParametersAt( enemy:GetBonePosition( 1 ), "body", self:EyePos() )
		else -- If our prey is too far, don't look at them
			self:DirectPoseParametersAt( nil, "body_pitch", "body_yaw", 0 )
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleStuck()
	self:TakeDamage(self:Health(), self, self)
	self:Vocalize( Zombie_BulletImpact )
	print( "Infected was removed due to getting stuck" )
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:FindNearestEnemy()
	local enemies = ents_FindInSphere(self:GetPos(), 2500) -- Find potential targets
	local nearestEnemy = nil -- Our enemy
	local nearestDistance = MathHuge -- Limited to out range of FindInSphere,

	for _, enemy in pairs(enemies) do

		if IsValid(enemy) and enemy:IsNPC() or (enemy:IsPlayer() and enemy:Alive()) or (enemy:IsNextBot() and not enemy.IsCommonInfected and not enemy.IsLambdaPlayer or enemy:IsNextBot() and enemy.IsLambdaPlayer and enemy:Alive())  then
			local distance = self:GetPos():Distance(enemy:GetPos()) -- Calculating distance between zombie and target

			if distance < nearestDistance then
				nearestDistance = distance
				nearestEnemy = enemy
			end
		end
	end

	return nearestEnemy -- Returning target for all purposes.
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RunBehaviour()
	while true do
		local enemy = self:FindNearestEnemy()
		if IsValid(enemy) then
			local dist = self:GetPos():Distance(enemy:GetPos())

			if dist > 100 then
				self:ChaseTarget(enemy)
			else
				self:Attack(enemy)
			end
		else
			self:StartWandering()
		end

		coroutine.yield()
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartWandering()
	self.loco:SetAcceleration( 500 )
	self.loco:SetDeceleration( 1000 )
	self.IsWalking = true

	local anim = self:GetActivity()
	local maleAnims = { "ACT_TERROR_WALK_NEUTRAL", "ACT_TERROR_SHAMBLE", "ACT_TERROR_WALK_INTENSE" }

	if self.Gender == "Female" then
		anim = "ACT_WALK"
	else
		anim = table_Random( maleAnims )
	end

	self:PlaySequenceAndMove( anim )

	self.loco:SetDesiredSpeed( random( 15, 20 ) )
	self:MoveToPos( self:GetPos() + VectorRand() * math.random( 150, 200 ) )
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartRun()
	self.loco:SetDesiredSpeed(300)
	self.loco:SetAcceleration(500)
	self.loco:SetDeceleration(1000)
	self.IsRunning = true

	local anim = self:GetActivity()

	if self.Gender == "Female" then
		anim = "ACT_RUN"
	else
		anim = "ACT_TERROR_RUN_INTENSE"
	end

	self:ResetSequence( anim )
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[ function ENT:Attack(target)
	local detectedEnemy = target
	local directionToEnemy = (detectedEnemy:GetPos() - self:GetPos()):GetNormalized()
	local distance = self:GetPos():Distance(detectedEnemy:GetPos())
	local AngleToEnemy = directionToEnemy:Angle()
	AngleToEnemy.p = 0
	if distance < 100 and (not self.AttackDelay or CurTime() - self.AttackDelay > Rand( 0.7, 1.2 )) then
		self:SetCycle(0)
		self:SetPlaybackRate(1)
		self:SetAngles(AngleToEnemy)
		self.ci_BehaviorState = "AttackingVictim"

		if random( 2 ) == 1 then
			if !self.SpeakDelay or CurTime() - self.SpeakDelay > Rand( 0.2, 1 ) then
				self:Vocalize( ZCommon_L4D1_BecomeEnraged )
				PrintMessage( HUD_PRINTTALK, "Enraged!" )
				self.SpeakDelay = CurTime()
			end
		end

		local dmginfo = DamageInfo()
		dmginfo:SetDamage(5)
		dmginfo:SetDamageType(DMG_DIRECT)
		dmginfo:SetInflictor(self)
		dmginfo:SetAttacker(self)
		detectedEnemy:TakeDamageInfo(dmginfo)
		self:Vocalize( ZCommon_AttackSmack )
		self:LookAtEntity()
		self:PlayAttackAnimation()
		self.AttackDelay = CurTime()
	end

	return true
end ]]
---------------------------------------------------------------------------------------------------------------------------------------------
-- New Rework for melee attack (Standing)
-- needs some work, ie ci sometimes not playing animations
function ENT:Attack(target)
	local detectedEnemy = target
	if !IsValid( detectedEnemy ) then return false end

	local directionToEnemy = ( detectedEnemy:GetPos() - self:GetPos() ):GetNormalized()
	local distance = self:GetPos():Distance( detectedEnemy:GetPos() )
	local AngleToEnemy = directionToEnemy:Angle()
	AngleToEnemy.p = 0

	if distance < 100 and ( !self.AttackDelay or CurTime() - self.AttackDelay > Rand( 0.7, 1.2 ) ) then
		self:SetCycle( 0 )
		self:SetPlaybackRate( 1 )
		self:SetAngles( AngleToEnemy )
		self.ci_BehaviorState = "AttackingVictim"

		if random( 2 ) == 1 and ( !self.SpeakDelay or CurTime() - self.SpeakDelay > Rand( 0.2, 1 ) ) then
			self:Vocalize( ZCommon_L4D1_BecomeEnraged )
			PrintMessage( HUD_PRINTTALK, "Enraged!" )
			self.SpeakDelay = CurTime()
		end

		local anim = self:GetActivity()
		anim = "ACT_TERROR_ATTACK_CONTINUOUSLY"
		self:ResetSequence( anim )
		self.AttackDelay = CurTime() + self:SequenceDuration( anim )

		-- Create a timer to apply damage at a random interval between 0.75 and 1.25 seconds
		-- Lets add the delays based from the Convars
		local timerName = "AttackDamage"..self:EntIndex()
		timer.Create( timerName, Rand( 0.7, 1.2 ), self:SequenceDuration( anim ) / Rand( 0.7, 1.2 ), function()
			if IsValid( detectedEnemy ) and IsValid( self ) then
				local distance = self:GetPos():Distance( detectedEnemy:GetPos() )

				if distance > 100 then
					PrintMessage( HUD_PRINTTALK, "Attack Timer Killed" )
					timer.Remove( timerName )
					self.AttackDelay = nil
					return
				end

				local z_Dmg
				local dmginfo = DamageInfo()
				local z_Difficulty = GetConVar( "l4d_sv_difficulty" ):GetInt()
				if z_Difficulty == 0 then
					z_Dmg = 1
				elseif z_Difficulty == 1 then
					z_Dmg = 2
				elseif z_Difficulty == 2 then
					z_Dmg = 5
				elseif z_Difficulty == 3 then
					z_Dmg = 20
				end
				
				dmginfo:SetDamage( z_Dmg )
				dmginfo:SetDamageType( DMG_DIRECT )
				dmginfo:SetInflictor( self )
				dmginfo:SetAttacker( self )
				detectedEnemy:TakeDamageInfo( dmginfo )

				if detectedEnemy:IsPlayer() then
					detectedEnemy:ViewPunch( Angle( random( -1, 8 ), random( -1, 10 ),random( -1, 12 ) ) )
				end
				
				self:SlowEntity( detectedEnemy )
				self:Vocalize( ZCommon_AttackSmack, true )
			end
		end)

		self:LookAtEntity()
	end

	return true
end


function ENT:SlowEntity( ent )
	-- Tested with 200 walk speed, 400 run speed.
	-- May be wonky on modified values.

	-- Start slowing the ent down
	if !ent.IsSlowed and ( !ent.LastSlowTime or CurTime() - ent.LastSlowTime >= 0.75 ) then
		ent.OriginalWalkSpeed = ent:GetWalkSpeed()
		ent:SetWalkSpeed( ent.OriginalWalkSpeed * 0.8 )
		ent.OriginalRunSpeed = ent:GetRunSpeed()
		ent:SetRunSpeed( ent.OriginalRunSpeed * 0.65 )

		ent.IsSlowed = true
		ent.LastSlowTime = CurTime()

		--ent:ChatPrint( "Max Walk Speed: " .. math.floor( ent.OriginalWalkSpeed ) .. ", Slowed Down Walk Speed: " .. math.floor( ent:GetWalkSpeed() ) )
		--ent:ChatPrint( "Max Run Speed: " .. math.floor( ent.OriginalRunSpeed ) .. ", Slowed Down Run Speed: " .. math.floor( ent:GetRunSpeed() ) )
	elseif ent.IsSlowed and ( !ent.LastSlowTime or CurTime() - ent.LastSlowTime >= 0.75 ) then
		-- If the entity is already slowed, apply a minor additional slowdown
		ent:SetWalkSpeed( ent:GetWalkSpeed() * 0.825 )
		ent:SetRunSpeed( ent:GetRunSpeed() * 0.78 )
		ent.LastSlowTime = CurTime()

		--ent:ChatPrint( "Max Walk Speed: " .. math.floor( ent.OriginalWalkSpeed ) .. ", Further Slowed Down Walk Speed: " .. math.floor( ent:GetWalkSpeed() ) )
		--ent:ChatPrint( "Max Run Speed: " .. math.floor( ent.OriginalRunSpeed ) .. ", Further Slowed Down Run Speed: " .. math.floor( ent:GetRunSpeed() ) )
	end

	-- Gradually restore the ent's speed
	local restoreTimerName = "SpeedRestore" .. ent:EntIndex()
	if timer.Exists( restoreTimerName ) then
		timer_Remove( restoreTimerName )
	end

	timer_Create( restoreTimerName, 0.0425, 0, function()
		if IsValid( ent ) then
			local currentWalkSpeed = ent:GetWalkSpeed()
			local currentRunSpeed = ent:GetRunSpeed()
			-- Regen walk spped to normal
			if currentWalkSpeed < ent.OriginalWalkSpeed then
				ent:SetWalkSpeed( currentWalkSpeed + 1.2 )
			else
				ent:SetWalkSpeed( ent.OriginalWalkSpeed )
			end

			-- Regen Run speed to normal
			if currentRunSpeed < ent.OriginalRunSpeed then
				ent:SetRunSpeed( currentRunSpeed + 2.5 )
			else
				ent:SetRunSpeed( ent.OriginalRunSpeed )
			end

			if currentWalkSpeed >= ent.OriginalWalkSpeed and currentRunSpeed >= ent.OriginalRunSpeed then
				ent.IsSlowed = false
				timer_Remove( restoreTimerName )
			end
		else
			timer_Remove( restoreTimerName )
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ChaseTarget( target )
	self:StartRun()
	self.ci_BehaviorState = "ChasingVictim"

	local TargetToChase = target
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( 300 )
	path:SetGoalTolerance( 55 )
	path:Compute( self, TargetToChase:GetPos() )

	if ( !path:IsValid() ) then
		return "failed"
	end

	while (path:IsValid() and TargetToChase:IsValid()) do

		if ( path:GetAge() > 0.1 ) then
			path:Compute( self, TargetToChase:GetPos())
		end

		path:Update( self )

		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			return "stuck"
		end

		coroutine.yield()
	end

	return "ok"
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlayAttackAnimation()
	coroutine.wait( 0.4 )
	self:ResetSequence( "ACT_TERROR_ATTACK_CONTINUOUSLY" )
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:BodyUpdate()
	local velocity = self.loco:GetVelocity()
	if !velocity:IsZero() then
		-- Apparently NEXTBOT:BodyMoveXY() really don't likes swimming animations and sets their playback rate to crazy values, causing the game to crash
		-- So instead I tried to recreate what that function does, but with clamped set playback rate
		if self:GetWaterLevel() >= 2 then
			local selfPos = self:GetPos()

			-- Setup pose parameters (model's legs movement)
			local moveDir = ( ( selfPos + velocity ) - selfPos ); moveDir.z = 0
			local moveXY = ( self:GetAngles() - moveDir:Angle() ):Forward()

			local frameTime = FrameTime()
			self:SetPoseParameter( "move_x", Lerp( 15 * frameTime, self:GetPoseParameter( "move_x" ), moveXY.x ) )
			self:SetPoseParameter( "move_y", Lerp( 15 * frameTime, self:GetPoseParameter( "move_y" ), moveXY.y ) )
			--self:InvalidateBoneCache()

			-- Setup swimming animation's clamped playback rate
			local length = velocity:Length()
			local groundSpeed = self:GetSequenceGroundSpeed( self:GetSequence() )
			self:SetPlaybackRate( Clamp( ( length > 0.2 and ( length / groundSpeed ) or 1 ), 0.5, 2 ) )
		else
			self:BodyMoveXY()
			return
		end
	end

	self:FrameAdvance()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetDeathExpression( ragdoll )

	local expressionKeys = {}
	for key in pairs( _DeathExpressions ) do
		table_insert( expressionKeys, key )
	end

	local randomExpressionKey = expressionKeys[ random( #expressionKeys ) ]
	local bonesToModify = _DeathExpressions[ randomExpressionKey ]

	--PrintMessage(HUD_PRINTTALK, "Expression picked: " .. randomExpressionKey )

	for _, boneData in pairs( bonesToModify ) do
		local boneIndex = ragdoll:LookupBone( boneData.boneName )
		if boneIndex then
			ragdoll:ManipulateBonePosition( boneIndex, boneData.positionOffset )
			ragdoll:ManipulateBoneAngles( boneIndex, boneData.angleOffset )
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Draw()
	self.ci_lastdraw = RealTime() + 0.1
	self:DrawModel()
end
---------------------------------------------------------------------------------------------------------------------------------------------
list.Set( "NPC", "z_common", {
	Name = "Infected",
	Class = "z_common",
	Category = "Left 4 Dead NextBots"
})

if CLIENT then language.Add( "z_common", "Infected" ) end
---------------------------------------------------------------------------------------------------------------------------------------------
