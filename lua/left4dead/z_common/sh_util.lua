local SERVER = SERVER
local random = math.random
local Rand = math.Rand
local MathHuge = math.huge
local CurTime = CurTime
local EmitSound = EmitSound
local timer_Create = timer.Create
local timer_Adjust = timer.Adjust
local timer_Remove = timer.Remove
local IsValid = IsValid
local ipairs = ipairs
---------------------------------------------------------------------------------------------------------------------------------------------
-- expressionType must be typed in as ("idle" and "angry")
function ENT:ZombieExpression( expressionType )
	timer_Remove( "AnimationLayer" )
	timer_Create( "AnimationLayer", 2, 0, function()
		if !IsValid( self ) then return end

		if SERVER then
			local anim = self:LookupSequence( "exp_" .. expressionType .. "_0" .. random( 6 ) )
			self:AddGestureSequence( anim, false )
		end

		timer_Adjust( "AnimationLayer", self:SequenceDuration( anim ) - 0.2 )
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:IsUnCommonInfected( model )
	local modelTable = {
		CEDA = { "models/infected/l4d2_nb/uncommon_male_ceda.mdl" },
	}

	if modelTable[ model ] then
		for _, v in ipairs( modelTable[ model ] ) do
			if self:GetModel() == v then
				return true
			end
		end
	end

	-- Our specific model isn't a uncommon
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Play the requested voiceline
-- Action = the global voiceset
-- Need to make a check for IsSpeaking
function ENT:Vocalize( action )
	local pitch
	local Snd = action[ random( #action ) ]

	if self.Gender == "Female" then
		pitch = random( 100, 112 )
		self:EmitSound( Snd, 80, pitch )
	elseif self.Gender == "Male" then
		pitch = random( 94, 104 )
		self:EmitSound( Snd, 80, pitch )
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Play the requested animation sequence
function ENT:PlaySequence( sequence )
	local seq = self:LookupSequence( sequence )
	if seq > 0 then
		self:ResetSequence( seq )
		self:SetSequence( seq )
	end
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
		return ( self:GetAttachmentPoint( "eyes" ).Pos:IsUnderwater() and 3 or self:WorldSpaceCenter():IsUnderwater() and 2 or self:GetPos():IsUnderwater() and 1 or 0 )
	end
	---------------------------------------------------------------------------------------------------------------------------------------------
end
---------------------------------------------------------------------------------------------------------------------------------------------