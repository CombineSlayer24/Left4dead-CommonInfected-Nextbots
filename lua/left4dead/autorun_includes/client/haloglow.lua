local hook_Add = hook.Add
local hook_Remove = hook.Remove
local timer_Simple = timer.Simple
local IsValid = IsValid
local CurTime = CurTime
local Color = Color

local glow_Item = Color( 178, 178, 255 )

CreateClientConVar( "l4d_cl_glow", 1, true, false, "Enable the glow system" )

-- Infected that's has been vomited on
CreateClientConVar( "l4d_cl_glow_infected_vomit_r", 201, true, false, "Red color for Vomited Infected" )
CreateClientConVar( "l4d_cl_glow_infected_vomit_g", 17, true, false, "green color for Vomited Infected" )
CreateClientConVar( "l4d_cl_glow_infected_vomit_b", 183, true, false, "blue color for Vomited Infected" )

-- NPC/NextBot/Players that's been vomited
CreateClientConVar( "l4d_cl_glow_npc_vomit_r", 255, true, false, "Red color for Vomited npcs/players" )
CreateClientConVar( "l4d_cl_glow_npc_vomit_g", 102, true, false, "green color for Vomited npcs/players" )
CreateClientConVar( "l4d_cl_glow_npc_vomit_b", 0, true, false, "blue color for Vomited npcs/players" )

-- NPC/NextBot/Players glow
CreateClientConVar( "l4d_cl_glow_npc_r", 76, true, false, "Red color for npcs/players" )
CreateClientConVar( "l4d_cl_glow_npc_g", 102, true, false, "green color for npcs/players" )
CreateClientConVar( "l4d_cl_glow_npc_b", 255, true, false, "blue color for npcs/players" )

local glow_enable = GetConVar( "l4d_cl_glow" )
local glow_infected_vomit_r = GetConVar( "l4d_cl_glow_infected_vomit_r" )
local glow_infected_vomit_g = GetConVar( "l4d_cl_glow_infected_vomit_g" )
local glow_infected_vomit_b = GetConVar( "l4d_cl_glow_infected_vomit_b" )

local glow_npc_vomit_r = GetConVar( "l4d_cl_glow_npc_vomit_r" )
local glow_npc_vomit_g = GetConVar( "l4d_cl_glow_npc_vomit_g" )
local glow_npc_vomit_b = GetConVar( "l4d_cl_glow_npc_vomit_b" )

local glow_npc_r = GetConVar( "l4d_cl_glow_npc_r" )
local glow_npc_g = GetConVar( "l4d_cl_glow_npc_g" )
local glow_npc_b = GetConVar( "l4d_cl_glow_npc_b" )
---------------------------------------------------------------------------------------------------------------------------------------------
concommand.Add( "l4d_cl_reset_glowcolors", function()
	local oldValues = {
		["l4d_cl_glow_infected_vomit_r"] = glow_infected_vomit_r:GetInt(),
		["l4d_cl_glow_infected_vomit_g"] = glow_infected_vomit_g:GetInt(),
		["l4d_cl_glow_infected_vomit_b"] = glow_infected_vomit_b:GetInt(),
		["l4d_cl_glow_npc_vomit_r"] = glow_npc_vomit_r:GetInt(),
		["l4d_cl_glow_npc_vomit_g"] = glow_npc_vomit_g:GetInt(),
		["l4d_cl_glow_npc_vomit_b"] = glow_npc_vomit_b:GetInt(),
		["l4d_cl_glow_npc_r"] = glow_npc_r:GetInt(),
		["l4d_cl_glow_npc_g"] = glow_npc_g:GetInt(),
		["l4d_cl_glow_npc_b"] = glow_npc_b:GetInt()
	}

	for convar, oldValue in pairs(oldValues) do
		MsgC(Color(255, 0, 0), "- " .. convar .. " has changed, old value " .. oldValue .. "\n")
	end

	RunConsoleCommand( "l4d_cl_glow_infected_vomit_r", "201" )
	RunConsoleCommand( "l4d_cl_glow_infected_vomit_g", "17" )
	RunConsoleCommand( "l4d_cl_glow_infected_vomit_b", "183" )

	RunConsoleCommand( "l4d_cl_glow_npc_vomit_r", "255" )
	RunConsoleCommand( "l4d_cl_glow_npc_vomit_g", "102" )
	RunConsoleCommand( "l4d_cl_glow_npc_vomit_b", "0" )

	RunConsoleCommand( "l4d_cl_glow_npc_r", "76" )
	RunConsoleCommand( "l4d_cl_glow_npc_g", "102" )
	RunConsoleCommand( "l4d_cl_glow_npc_b", "255" )

	MsgC(Color(255, 255, 255), "Glow colors have been reset!\n")
end)
---------------------------------------------------------------------------------------------------------------------------------------------
local function AddHalo( victim, color, time )
	if !glow_enable:GetBool() then return end

	if IsValid( victim ) then
		local timerName = "victimHalo" .. victim:EntIndex()

		hook_Add( "PreDrawHalos", timerName, function()
			halo.Add( { victim }, color, 2, 2, 5, true, true )
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
			local r = glow_infected_vomit_r:GetInt()
			local g = glow_infected_vomit_g:GetInt()
			local b = glow_infected_vomit_b:GetInt()
			AddHalo( victim, Color( r, g, b ), 20 )
		elseif type == "LambdaPlayer" or type == "GenericNextBot" or type == "HumanPlayer" or type == "NPC" then
			local r = glow_npc_vomit_r:GetInt()
			local g = glow_npc_vomit_g:GetInt()
			local b = glow_npc_vomit_b:GetInt()
			AddHalo( victim, Color( r, g, b ), 8 )
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------