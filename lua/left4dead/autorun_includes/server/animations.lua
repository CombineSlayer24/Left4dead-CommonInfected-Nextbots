---------------------------------------------------------------------------------------------------------------------------------------------
local timer_Create = timer.Create
local timer_Adjust = timer.Adjust
local random = math.random

local AddGestureSequence = AddGestureSequence
local LookupSequence = LookupSequence
local SequenceDuration = SequenceDuration
local IsValid = IsValid
---------------------------------------------------------------------------------------------------------------------------------------------
-- ent = The Zombie
-- expressionType = Can be "idle" and "angry"
-- expressionType must be typed in as ("idle" and "angry")
function ZombieExpression( ent, expressionType )
	timer_Create( "IdleAnimationLayer", 0, 0, function()
		if !IsValid( ent ) then return end

		local anim = ent:LookupSequence( "exp_" .. expressionType .. "_0" .. random( 6 ) )
		ent:AddGestureSequence( anim, true )

		timer_Adjust( "IdleAnimationLayer", ent:SequenceDuration( anim ) )
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------