local hook_Add = hook.Add
local hook_Remove = hook.Remove
local timer_Simple = timer.Simple
local IsValid = IsValid
local CurTime = CurTime
local Color = Color

local cVomit_Infected = Color( 201, 17, 183 )
local cVomit_Survivor = Color( 255, 102, 0 )
---------------------------------------------------------------------------------------------------------------------------------------------
local function AddHalo( victim, color, time )
	if IsValid( victim ) then
		local timerName = "victimHalo" .. victim:EntIndex()

		hook_Add( "PreDrawHalos", timerName, function()
			halo.Add( { victim }, color, 5, 5, 2, true, true )
		end)

		ParticleEffect( "boomer_vomit_survivor_b", victim:GetPos() + Vector(0, 0, 0), victim:GetAngles() )

		if timer.Exists( timerName ) then
			timer.Adjust( timerName, time, 1, function()
				if IsValid( victim ) then
					hook_Remove( "PreDrawHalos", timerName )
					victim.Is_Vomited = false
				end
			end)
		else
			timer.Create( timerName, time, 1, function()
				if IsValid( victim ) then
					hook_Remove( "PreDrawHalos", timerName )
					victim.Is_Vomited = false
				end
			end)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
net.Receive( "Event_Vomited", function()
	local victim = net.ReadEntity()
	local type = net.ReadString()

	if IsValid( victim ) then
		if type == "Infected" then
			AddHalo( victim, cVomit_Infected, 20 )
		elseif type == "LambdaPlayer" or type == "GenericNextBot" or type == "HumanPlayer" or type == "NPC" then
			AddHalo( victim, cVomit_Survivor, 8 )
		end
	end
end)