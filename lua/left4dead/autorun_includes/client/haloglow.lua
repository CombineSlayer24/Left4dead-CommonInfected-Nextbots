local hook_Add = hook.Add
local hook_Remove = hook.Remove
local timer_Simple = timer.Simple
local IsValid = IsValid

local cVomit_Infected = Color( 201, 17, 183 )
local cVomit_Survivor = Color( 255, 102, 0 )
---------------------------------------------------------------------------------------------------------------------------------------------
local function AddHalo( entity, color, time )
	if IsValid( entity ) then
		hook_Add( "PreDrawHalos", entity, function()
			halo.Add( { entity }, color, 5, 5, 2, true, true )
		end)

		ParticleEffect( "boomer_vomit_survivor_b", entity:GetPos() + Vector(0, 0, 0), entity:GetAngles() )

		timer_Simple( time, function()
			if IsValid( entity ) then
				hook_Remove( "PreDrawHalos", entity )
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
net.Receive( "Event_Vomited", function()
	local entity = net.ReadEntity()
	local type = net.ReadString()

	if type == "Infected" then
		AddHalo( entity, cVomit_Infected, 20 )
	elseif type == "LambdaPlayer" or type == "GenericNextBot" or type == "HumanPlayer" or type == "NPC" then
		AddHalo( entity, cVomit_Survivor, 8 )
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------