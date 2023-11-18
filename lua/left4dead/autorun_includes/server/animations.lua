---------------------------------------------------------------------------------------------------------------------------------------------
local timer_Create = timer.Create
local timer_Adjust = timer.Adjust
local random = math.random

local AddGestureSequence = AddGestureSequence
local LookupSequence = LookupSequence
local SequenceDuration = SequenceDuration
local IsValid = IsValid
---------------------------------------------------------------------------------------------------------------------------------------------
_Z_WalkAnims = 
{
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
---------------------------------------------------------------------------------------------------------------------------------------------
_Z_IdleAnims = 
{
	"Idle",
	"Idle_Neutral_01",
	"Idle_Neutral_02",
	"Idle_Neutral_03",
	"Idle_Neutral_06",
	"Idle_Neutral_07",
	"Idle_Neutral_08",
	"Idle_Neutral_10",
	"Idle_Neutral_11",
	"Idle_Neutral_12",
	"Idle_Neutral_13",
	"Idle_Neutral_14",
	"Idle_Neutral_15",
	"Idle_Neutral_16",
	"Idle_Neutral_17",
}
---------------------------------------------------------------------------------------------------------------------------------------------
_Z_CrouchAnims = 
{
	"CrouchWalk_01",
	"CrouchWalk_03",
}
---------------------------------------------------------------------------------------------------------------------------------------------
_Z_RunAnims = 
{
	"Run_01",
	"Run_01b",
	"Run_02",
	"Run_02b",
	"Run_03",
	"Run_03b",
	"Run_04",
	"Run_05" -- Weird scuttle
}
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