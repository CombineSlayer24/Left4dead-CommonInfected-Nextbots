AddCSLuaFile()

ENT.Base = "base_nextbot"
ENT.PrintName = "Common Infected"
ENT.Author = "Pyri"
ENT.IsL4DCommonInfected = true
ENT.IsL4DUnCommonInfected = false
ENT.IsWalking = false
ENT.IsRunning = false
ENT.IsLyingOrSitting = false
ENT.IsClimbing = false

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

local collisionmins = Vector( -16, -16, 0 )
local standingcollisionmaxs = Vector( 16, 16, 72 )
local crouchingcollisionmaxs = Vector( 16, 16, 36 )

local AddGestureSequence = AddGestureSequence
local LookupSequence = LookupSequence
local SequenceDuration = SequenceDuration
local IsValid = IsValid
local Vector = Vector

-- Convars
local ignorePlys = GetConVar( "ai_ignoreplayers" )
local sv_gravity = GetConVar( "sv_gravity" )
--local droppableProps = GetConVar( "left4dead_nb_sv_itemdrops" )

if CLIENT then language.Add( "nb_common_infected", ENT.PrintName ) end

-- For voices and animations
local femaleModels = {
}

local maleModels = {
	"models/infected/c_inf_nextbot/common_police_male01.mdl",
}

local itemModels = {
	nightstick = "models/weapons/melee/w_tonfa.mdl",
	bileJar = "models/w_models/weapons/w_eq_bile_flask.mdl",

	-- Should these give Grenade ammo to player?
	molotov = "models/w_models/weapons/w_eq_molotov.mdl",
	pipeBomb = "models/w_models/weapons/w_eq_pipebomb.mdl",

	--Should we makes this into Entities so the players can heal from them?
	healthKit = "models/w_models/weapons/w_eq_medkit.mdl",
	painPills = "models/w_models/weapons/w_eq_painpills.mdl",
	-- Add more items here as needed
}


function ENT:Initialize()
	if SERVER then
		-- When it comes down to models, we make all of the models available for the player/admins to customize. 
		-- Sorta similar to how the population is handled in L4D2.
		-- Should the player only want Military, Police, Rural, Common, Hospital, or all of above? ect ect.
		self:SetModel( "models/infected/c_inf_nextbot/common_police_male01.mdl" )
		local mdl = self:GetModel()
		
		self.ci_BehaviorState = "Idle"

		self:SetHealth( 50 )
		self:SetShouldServerRagdoll( true )

		--if droppableProps:GetBool() then
		if mdl == "models/infected/c_inf_nextbot/common_police_male01.mdl" && random( 1, 100 ) <= 15 then
			self:CreateItem( "nightstick",  true, "baton" )
		end
		--end

		self.loco:SetAcceleration( random( 120, 180 ) )
		self.loco:SetDeceleration( 200 )
		self.loco:SetStepHeight( 30 )
		self.loco:SetGravity( sv_gravity:GetFloat() ) -- Makes us fall at the same speed as the real players do

		-- Animations will match the speed
		-- We need to change the speed for walking and running, here for now
		self.loco:SetDesiredSpeed( 280 )

		self:SetCollisionBounds( collisionmins, standingcollisionmaxs )
		self:PhysicsInitShadow()

		self:SetCollisionGroup( COLLISION_GROUP_PLAYER )

		self:SetLagCompensated( true )
		self:AddFlags( FL_OBJECT + FL_NPC )
		self:SetSolidMask( MASK_PLAYERSOLID )

		-- from Lambdaplayers
		for _, v in ipairs( self:GetBodyGroups() ) do
			local subMdls = #v.submodels
			if subMdls == 0 then continue end 
			self:SetBodygroup( v.id, random( 0, subMdls ) )
		end

		local skinCount = self:SkinCount()
		if skinCount > 0 then self:SetSkin( random( 0, skinCount - 1 ) ) end

		-- Layer idle Animations
		timer_Create("IdleAnimationLayer", 0, 0, function()
			if !IsValid( self ) then return end

			local anim = self:LookupSequence( "exp_idle_0" .. random( 1, 6 ) )
			self:AddGestureSequence( anim, true )

			timer_Adjust( "IdleAnimationLayer", self:SequenceDuration( anim ) - 0.2)
		end)

		local anim = self:LookupSequence( "idlenoise" )
		self:AddGestureSequence(anim,false)

	elseif CLIENT then
		self.ci_lastdraw = 0
	end
end

-- Certain Common/Uncommon Infected will have
-- props attached to them... Riot Cops, Cops
-- CEDA, ect. Create some props for them to carry
function ENT:CreateItem( itemName, canparent, id )
	local model = itemModels[ itemName ]
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
	item:SetSolid( SOLID_VPHYSICS )

	self.item = item
	self.canparent = canparent
end

function ENT:OnKilled(dmginfo)
	hook_Run("OnNPCKilled", self, dmginfo:GetAttacker(), dmginfo:GetInflictor())

	local ragdoll = self:BecomeRagdoll(dmginfo)
	ragdoll:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

	if IsValid( self.item ) then
		local item = self.item
		local dropChance = random( 1, 100) <= 60

		if dropChance or !self.canparent then
			item:SetParent( nil )
			item:SetPos(self:GetPos() + Vector( 0, 0, 50 ) )
			item:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
			item:PhysicsInit( SOLID_VPHYSICS )

			local phys = item:GetPhysicsObject()
			if IsValid( phys ) then
				phys:EnableGravity( true )
				phys:Wake()

				-- Apply a force so they fly up or around.
				local force = Vector( random( -1000, 1000 ), random( -1000, 1000 ), random( 450, 1000 ) )
				local position = item:WorldToLocal( item:OBBCenter() ) + Vector( Rand( 5, 10 ), Rand( 5, 10 ), Rand( -10, 60 ) )
				phys:ApplyForceOffset( force, position )
			end

			SimpleTimer(15, function()
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
end

function ENT:Draw()
	self.ci_lastdraw = RealTime() + 0.1
	self:DrawModel()
	--Msg("Being drawn")
end

function ENT:OnRemove()
	timer_Remove( "IdleAnimationLayer" )
end

function ENT:HandleStuck()

	local dmginfo = DamageInfo()
	dmginfo:SetAttacker( self )
	dmginfo:SetInflictor( self )
	dmginfo:SetDamageType( DMG_CRUSH )
	dmginfo:SetDamage( self:Health() )
	self:OnKilled( dmginfo )
	self.loco:ClearStuck()

	--self:EmitSound( "npc/infected/gore/bullets/bullet_impact_05.wav", 65 )
end

-- Move this over to left4dead/autorun_includes/server/globals.lua later
-- Some animations don't worry, why? All of running animations and the "Walk"
-- animations are in place...
_CommonInfected_WalkAnims = {
	"Walk_Neutral_01",
	"Walk_Neutral_02",
	"Walk_Neutral_02b",
	"Walk_Neutral_03",
	"Walk_Neutral_04a",
	"Walk_Neutral_04b",
    "Shamble_01",
    "Shamble_02",
    "Shamble_03",
	-- "Walk_Neutral_South",
    "Walk" -- beta animation
}

function ENT:RunBehaviour()
	while ( true ) do
		if ( self:IsOnGround() ) then
			if ( random( 1, 200 ) == 1 ) then
				local anim = _CommonInfected_WalkAnims[ random( #_CommonInfected_WalkAnims ) ]
				self:ResetSequence( self:LookupSequence( anim ) )

				self.loco:SetDesiredSpeed( 15 )
				self:MoveToPos( self:GetPos() + VectorRand() * random( 250, 500 ) )

				self:ResetSequence( self:LookupSequence("Idle") ) -- revert to idle activity
				self.IsWalking = true 
			else
				self.IsWalking = false
			end
		end
		
		coroutine.wait(0.05)
	end
end

list.Set( "NPC", "nb_common_infected", {
	Name = "Common Infected",
	Class = "nb_common_infected",
	Category = "Left 4 Dead 2"
})