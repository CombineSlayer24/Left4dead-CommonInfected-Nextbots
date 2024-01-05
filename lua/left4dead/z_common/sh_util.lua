local SERVER = SERVER
local random = math.random
local Rand = math.Rand
local MathHuge = math.huge
local Clamp = math.Clamp
local CurTime = CurTime
local EmitSound = EmitSound
local timer_Create = timer.Create
local timer_Adjust = timer.Adjust
local timer_Remove = timer.Remove
local SimpleTimer = timer.Simple
local table_Random = table.Random
local IsValid = IsValid
local ipairs = ipairs
local Color = Color

if CLIENT then
	killicon.Add("z_common", "killicons/z_claw", Color( 255, 255, 255 ) )
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- expressionType must be typed in as "idle" and "angry"
function ENT:ZombieExpression( expressionType )
	local timerName = "AnimationLayer" .. self:EntIndex()

	-- Helper function to remove/reset the timer
	local function RemoveTimer()
		timer_Remove( timerName )
	end

	timer_Create( timerName, 2, 0, function()
		if !IsValid( self ) then 
			RemoveTimer()
			return 
		end

		local anim
		if SERVER then
			anim = self:LookupSequence( "exp_" .. expressionType .. "_0" .. random( 6 ) )
			self:AddGestureSequence( anim, false )
		end

		if anim then
			timer_Adjust( timerName, self:SequenceDuration( anim ) - 0.2, 1, function()
				if IsValid( self ) then
					RemoveTimer()
				end
			end)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Returns the time we will play our next footsteps ound
function ENT:GetStepSoundTime()
	local stepTime = 0.35

	if self:GetWaterLevel() != 2 then
		local maxSpeed = self.loco:GetVelocity():Length2D()
		stepTime = Clamp( stepTime * ( 200 / maxSpeed ), 0.25, 0.45 )
	else
		stepTime = 0.6
	end

	return stepTime
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Play our footstep sounds
-- TODO: We need to mute the male footsteps by hooking into the animation events
local QuickTrace = util.QuickTrace
local _Z_Running_Footsteps = _Z_Running_Footsteps
function ENT:PlayStepSound( volume )
	local stepMat = QuickTrace( self:WorldSpaceCenter(), vector_up * -32756, self ).MatType
	local selfPos = self:GetPos()
	if RunHook( "CommonFootStep", self, selfPos, stepMat ) == true then return end

	local sndPitch, sndName = 100
	local waterLvl = self:GetWaterLevel()
	if waterLvl != 0 and waterLvl != 3 and self:IsOnGround() then
		sndName = "player/footsteps/wade" .. random( 8 ) .. ".wav"
		sndPitch = random( 90, 110 )
		if !volume then volume = 0.65 end
	else
		local stepSnds = ( _Z_Running_Footsteps[ stepMat ] or _Z_Running_Footsteps[ MAT_DEFAULT ] )
		sndName = stepSnds[ random( #stepSnds ) ]
		if !volume then volume = 0.5 end
	end

	self:EmitSound( sndName, 75, sndPitch, volume )
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PlayGesture( activity )
	local seq = self:LookupSequence( activity )
	if seq > 0 then
		self:RestartGesture( self:GetSequenceActivity( seq ), true )
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Set our fall animation
function ENT:IsAirborne()
	if !self.IsLanded then
		self:SetCycle( 0 )

		local anim = self:GetActivity()

		anim = "ACT_TERROR_FALL"

		self:ResetSequence( anim )
		self.IsLanded = true
	end
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
		return self:DirectPoseParametersAt( pos, pitch .. "_pitch", pitch .. "_yaw", yaw )
	elseif isentity( pos ) then
		pos = pos:WorldSpaceCenter()
	end

	if isvector(pos) then
		center = center or WorldSpaceCenter( self )
		local angle = ( pos - center ):Angle()
		SetPoseParameter( self, pitch, AngleDifference( angle.p, GetAngles( self ).p ) )
		SetPoseParameter( self, yaw, AngleDifference( angle.y, GetAngles( self ).y ) )
	else
		SetPoseParameter( self, pitch, 0 )
		SetPoseParameter( self, yaw, 0 )
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
-- Handles our Landing animations
function ENT:DoLandingAnimation()
	if self.IsLanded then
		local landingAnims
		local anim = self:GetActivity()

		-- If they are after their prey, don't do long landing anims
		if IsValid( self:FindNearestEnemy() ) then
			landingAnims = { "ACT_TERROR_JUMP_LANDING_HARD", "ACT_TERROR_JUMP_LANDING_HARD_NEUTRAL", "ACT_TERROR_JUMP_LANDING" }
			anim = table_Random(landingAnims)
		else
			-- If they are just wandering around with no enemies, then use the slow landing anim
			if random( 4 ) == 1 then
				landingAnims = { "ACT_TERROR_JUMP_LANDING_NEUTRAL", "ACT_TERROR_JUMP_LANDING_HARD_NEUTRAL", "ACT_TERROR_JUMP_LANDING" }
				anim = table_Random(landingAnims)
			end
		end

		self:PlaySequenceAndMove( anim )
		--PrintMessage( HUD_PRINTTALK, "I Landed!" )
		self:EmitSound( "left4dead/player/jumplanding_zombie.mp3", 80, 100, 1 )
		self.PlayingAnimSeq = false

		SimpleTimer( self:SequenceDuration( anim ) - 0.5, function()
			if !IsValid( self ) then return end
			self.PlayingAnimSeq = false
			if self:IsOnGround() then
				if IsValid( self:FindNearestEnemy() ) then
					self:StartRun()
				else
					-- No enemy, so transistion to idle
					anim = "ACT_TERROR_RUN_INTENSE_TO_STAND_ALERT"
					self:PlaySequenceAndMove( anim )
				end
			end
		end)

		self.IsLanded = false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Check for our uncommon infected type
function ENT:GetUncommonInf( model )
	if Z_UnCommonModels[ model ] then
		for _, v in ipairs( Z_UnCommonModels[ model ] ) do
			if self:GetModel() == v then
				print( self.UnCommonType .. " GetUncommonInf()" )
				return true
			end
		end
	end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Set our current infected flameproof
function ENT:ExtinguishFire( dmginfo )
	self.Flameproof = true
	if dmginfo:IsDamageType( DMG_BURN ) then
		if SERVER then
			dmginfo:SetDamage( 0 )
			self:Extinguish()
			self:StopSound( "General.BurningFlesh" )

			if dmginfo:GetAttacker():GetClass() == "entityflame" then
				self:StopSound( "General.BurningObject" )
				dmginfo:GetAttacker():Fire( "kill", "", 0.1 )
			end
		end
		return true
	end

	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Get the current behavior
function ENT:GetCurrentBehavior()
	return self.ci_BehaviorState
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Set our behavior
function ENT:SetBehavior( action )
	self.ci_BehaviorState = action
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Play the requested voiceline
-- Action = the global voiceset
-- Need to make a check for IsSpeaking
function ENT:Vocalize( action, isSFX )
	local pitch
	local Snd = action[ random( #action ) ]

	if isSFX == true then
		pitch = 100
	else
		if self.Gender == "Female" then
			pitch = random( 100, 112 )
		elseif self.Gender == "Male" then
			pitch = random( 94, 104 )
		end
	end

	self:EmitSound( Snd, 80, pitch )
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Returns the position and angle of a specified bone
function ENT:GetBoneTransformation( bone, target )
	target = ( target or self )

	local pos, ang = target:GetBonePosition( bone )
	if !pos or pos:IsZero() or pos == target:GetPos() then
		local matrix = target:GetBoneMatrix( bone )
		if matrix and ismatrix( matrix ) then
			pos = matrix:GetTranslation()
			ang = matrix:GetAngles()
		end
	end

	return { Pos = pos, Ang = ang, Bone = bone }
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Performs a Trace from ourselves or the overridestart to the postion
function ENT:Trace( pos, overridestart, ignoreEnt )
	tracetable.start = overridestart or self:WorldSpaceCenter()
	tracetable.endpos = ( isentity( pos ) and IsValid( pos ) and pos:GetPos() or pos )
	tracetable.filter = ( ignoreEnt and { self, ignoreEnt } or self ) 
	return Trace( tracetable )
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Returns if we can see the ent in question.
-- Simple trace 
function ENT:CanSee( ent )
	if !IsValid( ent ) then return false end

	visibilitytrace.start = self:GetAttachmentPoint( "foward" ).Pos
	visibilitytrace.endpos = ent:WorldSpaceCenter()
	visibilitytrace.filter = self

	local result = Trace( visibilitytrace )
	if RunHook( "CanSeeEntity", self, ent, result ) == true then return false end

	return ( result.Fraction == 1.0 )
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Returns a table that contains a position and angle with the specified type. hand or eyes
local eyeOffAng = Angle( 20, 0, 0 )
function ENT:GetAttachmentPoint( pointtype )
	local attachData = { Pos = self:WorldSpaceCenter(), Ang = self:GetForward():Angle(), Index = 0 }

	if pointtype == "hand" then
		local lookup = self:LookupAttachment( "anim_attachment_RH" )
		local handAttach = self:GetAttachment( lookup )

		if !handAttach then
			local bone = self:LookupBone( "ValveBiped.Bip01_R_Hand" )
			if isnumber( bone ) then attachData = self:GetBoneTransformation( bone ) end
		else
			attachData = handAttach
			attachData.Index = lookup
		end
	elseif pointtype == "eyes" then
		local lookup = self:LookupAttachment( "eyes" )
		local eyeAttach = self:GetAttachment( lookup )

		if !eyeAttach then
			attachData.Pos = ( attachData.Pos + vector_up * 30 )
			attachData.Ang = ( attachData.Ang + eyeOffAng )
		else
			attachData = eyeAttach
			attachData.Index = lookup
		end
	end

	return attachData
end
---------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	---------------------------------------------------------------------------------------------------------------------------------------------
	function ENT:GetWaterLevel()
		return ( self:GetAttachmentPoint( "foward" ).Pos:IsUnderwater() and 3 or self:WorldSpaceCenter():IsUnderwater() and 2 or self:GetPos():IsUnderwater() and 1 or 0 )
	end
	---------------------------------------------------------------------------------------------------------------------------------------------
end
---------------------------------------------------------------------------------------------------------------------------------------------