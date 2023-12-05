-- Include files in the corresponding folders
-- Autorun files are seperated in folders unlike the ENT include lua files

local file_Find = file.Find
local ipairs = ipairs

-- Base Addon includes --
---------------------------------------------------------------------------------------------------------------------------------------------
function InitializeAddon()
	---------------------------------------------------------------------------------------------------------------------------------------------
	local function FileLoaded()
		return true
	end
	---------------------------------------------------------------------------------------------------------------------------------------------
	if SERVER then
		local serversidefiles = file_Find( "left4dead/autorun_includes/server/*", "LUA", "nameasc" )
		for k, luafile in ipairs( serversidefiles ) do

			include( "left4dead/autorun_includes/server/" .. luafile )

			if FileLoaded() then
				print( "Left 4 Dead Nextbots: Included Server Side Lua File [ " .. luafile .. " ]" )
			else
				print( "Failed to load Server Side Lua File [ " .. luafile .. " ]" )
			end
		end
	end
	---------------------------------------------------------------------------------------------------------------------------------------------
	local sharedfiles = file_Find( "left4dead/autorun_includes/shared/*", "LUA", "nameasc" )
	for k, luafile in ipairs( sharedfiles ) do

		if SERVER then
			AddCSLuaFile( "left4dead/autorun_includes/shared/" .. luafile )
		end

		include( "left4dead/autorun_includes/shared/" .. luafile )

		if FileLoaded() then
			print( "Left 4 Dead Nextbots: Included Shared Lua File [ " .. luafile .. " ]" )
		else
			print( "Failed to load Shared Lua File [ " .. luafile .. " ]" )
		end
	end
	---------------------------------------------------------------------------------------------------------------------------------------------
	local clientsidefiles = file_Find( "left4dead/autorun_includes/client/*", "LUA", "nameasc" )
	for k, luafile in ipairs( clientsidefiles ) do
		if SERVER then
			AddCSLuaFile( "left4dead/autorun_includes/client/" .. luafile )
		elseif CLIENT then
			include( "lambdaplayers/autorun_includes/client/" .. luafile )
			
			if FileLoaded() then
				print( "Lambda Players: Included Client Side Lua File [ " .. luafile .. " ]" )
			else
				print( "Failed to load Client Side Lua File [ " .. luafile .. " ]" )
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
InitializeAddon()

concommand.Add( "l4d_dev_reloadaddon", InitializeAddon )
-- Down below will be how we spawn Zombies in to
-- implement into our director. Will be here
-- for now.

---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
local IsValid = IsValid
local random = math.random
local Rand = math.Rand
local GetConVar = GetConVar
local Rad = math.rad
local Cos = math.cos
local VectorRand = VectorRand
local ents_Create = ents.Create
local Angle = Angle
local EffectData = EffectData
local util_Effect = util.Effect
local undo_Create = undo.Create
local undo_SetPlayer = undo.SetPlayer
local undo_SetCustomUndoText = undo.SetCustomUndoText
local undo_AddEntity = undo.AddEntity
local undo_Finish = undo.Finish
local Vector = Vector
local tonumber = tonumber
local util_TraceHull = util.TraceHull
local SimpleTimer = timer.Simple

-- Check if a vector is within the player's FOV and visible from the player's perspective
local function IsInFOVAndVisible( player, vec )
    local direction = ( vec - player:GetPos() ):GetNormalized()
    local dot = player:EyeAngles():Forward():Dot( direction )
    local fov_desired = GetConVar( "fov_desired" ):GetInt()
    local isInFOV = dot > Cos( Rad( fov_desired / 2 ) )

    local plyradius = GetConVar( "l4d_z_spawn_radius" ):GetFloat()
    local distance = player:GetPos():Distance( vec )
    local isVisible = distance < plyradius  -- Consider points visible if they are within the spawn radius

    print( "IsInFOV: " .. tostring( isInFOV ) )
    print( "IsVisible: " .. tostring( isVisible ) )

    return isInFOV and isVisible
end

local function IsNavMeshVisible( player, nav )
    local point = nav:GetRandomPoint()
    if nav:IsVisible( point ) and IsInFOVAndVisible( player, point ) then
        return true
    end

    return false
end

--Get's the same height level as player
local function GetNavAreasNear( pos, radius, caller )
	local navareas = navmesh.GetAllNavAreas()
	local foundareas = {}
	local playerZ = pos.z

	for i = 1, #navareas do
		local nav = navareas[ i ]
		if IsValid( nav ) and nav:GetSizeX() > 40 and nav:GetSizeY() > 40 and !nav:IsUnderwater() and 
		   ( pos:DistToSqr( nav:GetClosestPointOnArea( pos ) ) < ( radius * radius ) and 
		   pos:DistToSqr( nav:GetClosestPointOnArea( pos ) ) > ( ( radius / 3 ) * ( radius / 3 ) ) and 
		   nav:GetCenter().z >= playerZ - 250 and nav:GetCenter().z <= playerZ + 250 ) then

			-- Check if the center of the nav area is visible to the player and within their FOV 
			if !IsNavMeshVisible( caller, nav ) then 
				local width = nav:GetSizeX()
				local height = nav:GetSizeY()
				local maxOffset = width <= 40 and height <= 40 and 1 or 20  -- Set the max offset based on the size of the navmesh area 
				local xyOffset = VectorRand() * maxOffset -- Randomize X and Y components, keep Z at 0 
				xyOffset.z = 25 -- In case if our tracehull doesn't work, spawn the entity up a bit

				local spawnPos = nav:GetCenter() + xyOffset -- Add randomized offset to the center of the nav area 

				-- Perform a trace hull from a point slightly above the spawn position to a point slightly higher 
				local tr = util_TraceHull({
					start = spawnPos + Vector( 0, 0, 1 ),
					endpos = spawnPos + Vector( 0, 0, 2 ),
					mins = Vector( -16, -16, 0 ),
					maxs = Vector( 16, 16, 72 ),
					mask = MASK_PLAYERSOLID_BRUSHONLY,
					filter = player.GetAll()
				})

				if !tr.Hit then 
					foundareas[ #foundareas + 1 ] = spawnPos 
				end 
			end 
		end 
	end 

	return foundareas 
end 

local function SpawnNPC( class, caller, amount, spawnAtCrosshair )
	local plyradius = GetConVar( "l4d_z_spawn_radius" )
	if !IsValid( caller ) then return end

	local areas = GetNavAreasNear( caller:GetPos(), plyradius:GetInt(), caller )
	if !areas or #areas == 0 then return end
	local spawnTimerName = "SpawnTimer_" .. caller:UserID() -- Unique timer name for each player

	local pos
	if amount > 6 then
		pos = areas[ random( #areas ) ]
	end

	timer.Create(spawnTimerName, 0.065, amount, function()
		if amount <= 6 then
			pos = areas[ random( #areas ) ]
		end

		if spawnAtCrosshair then
			local trace = caller:GetEyeTrace()
			pos = trace.HitPos
		end
		
		local npc = ents_Create( class )
		
		-- Add a random offset to the spawn position
		local offset = Vector( Rand( -5, 5 ), Rand(- 5, 5 ), 0 )
		npc:SetPos( pos + offset )
		
		npc:SetAngles( Angle( 0, math.random( -180, 180 ), 0 ) )
		npc:Spawn()
	end)
end

local function SpawnZombie( caller, command, arguments )
	if IsValid( caller ) then
		if #arguments == 0 then
			MsgC(Color(255, 255, 255), "Usage: l4d_z_spawn <common/mob/megamob> <amount> <optional spawn options>\nYou can also set amount to false to access the 3rd paramter\nEx: l4d_z_spawn mob false true\n")
			return
		end

		local zombieType = arguments[ 1 ] or "common"
		local amount = tonumber( arguments[ 2 ] ) or 1
		local spawnAtCrosshair = arguments[ 3 ] or false

		local npcType = "z_common" -- Default to Common Infected

		if zombieType == "mob" then
			amount = tonumber( arguments[ 2 ] ) or Rand( 8, 16 )
			local soundPath = Z_Music_Germs[ random( #Z_Music_Germs ) ]
			caller:EmitSound( soundPath, 75, 100, 1 )
			PrintMessage( HUD_PRINTCENTER, "[Incoming Attack!]" )
		elseif zombieType == "megamob" then
			amount = tonumber( arguments[ 2 ] ) or Rand( 16, 24 )
			caller:EmitSound("left4dead/vocals/infected/sfx/megamob_" .. random( 2 ) .. ".mp3", 75, 100, 1 )
			SimpleTimer(Rand( 1, 3 ), function() 
				local soundPath = Z_Music_Germs[ random( #Z_Music_Germs ) ]
				caller:EmitSound( soundPath, 75, 100, 1 )
			end)
		end

		SpawnNPC( npcType, caller, amount, spawnAtCrosshair )
	end
end

concommand.Add( "l4d_z_spawn", SpawnZombie, nil )
CreateConVar( "l4d_z_spawn_radius", 2000, FCVAR_ARCHIVE, "Zombie Spawn radius from player.", 250, 25000 )

-- Used for cleaning up stuff for debugging
-- Credit to VJ Base
if SERVER then
	local IsValid = IsValid
	local ipairs = ipairs
	local ents_GetAll = ents.GetAll
	local player_GetAll = player.GetAll
	
	local cTypes = {
		infected = "Infected",
		droppedguns = "Ground Weapons",
		props = "Props",
		decals = "Removed All Decals",
		guns = "Removed Your Weapons",
		ammo = "Removed Your Ammo",
	}
	
	concommand.Add("l4d_dev_cleanup", function( ply, cmd, args )
		local plyValid = IsValid( ply )
		if plyValid and !ply:IsAdmin() then return end
		
		local cType = args[ 1 ]
		local i = 0

		if !cType then
			MsgC(Color(255, 255, 255), "Usage: l4d_dev_cleanup <all|infected|droppedguns|props|decals|guns|ammo>\n")
			return

		elseif cType == "all" then
			game.CleanUpMap()
		elseif cType == "decals" then
			for _, v in ipairs( player_GetAll() ) do
				v:ConCommand( "r_cleardecals" )
			end
		elseif plyValid and cType == "guns" then
			ply:StripWeapons()
		elseif plyValid and cType == "ammo" then
			ply:RemoveAllAmmo()
		else
			for _, v in ipairs( ents_GetAll() ) do
				if ( v:IsNextBot() and ( cType == "infected" and v.IsCommonInfected ) ) 
				or ( cType == "groundweapons" and v:IsWeapon() and !IsValid( v:GetOwner() ) ) 
				or ( cType == "props" and v:GetClass() == "prop_physics" and ( !IsValid(v:GetParent() ) 
				or ( IsValid( v:GetParent() ) and v:GetParent():Health() <= 0 and ( v:GetParent():IsNextBot() 
				or v:GetParent():IsPlayer() ) ) ) ) then
					v:Remove()
					i = i + 1
				end
			end
		end
		
		if plyValid then
			if cType == "all" then
				ply:SendLua( "GAMEMODE:AddNotify( \"Cleaned Up Everything!\", NOTIFY_CLEANUP, 5 )" )
			elseif cType == "decals" or cType == "guns" or cType == "ammo" then
				ply:SendLua( "GAMEMODE:AddNotify( \""..cTypes[ cType ].."\", NOTIFY_CLEANUP, 5 )" )
			else
				ply:SendLua( "GAMEMODE:AddNotify( \"Removed "..i.." "..cTypes[ cType ].."\", NOTIFY_CLEANUP, 5 )" )
			end
			ply:EmitSound( "ui/beepclear.wav" )
		end
	end, nil, "", {FCVAR_DONTRECORD})
end

CreateConVar( "l4d_z_drawcount", 1, FCVAR_ARCHIVE, "Show the amount of zombies on screen?", 0, 1 )

local function DrawZombieCount()
	if !GetConVar("l4d_z_drawcount"):GetBool() then return end
	local count = 0
	local color = Color(0, 255, 0) -- Placeholder "default" local color

	for _, ent in pairs(ents.FindByClass("z_common")) do
		count = count + 1
	end

	if count >= 1 and count <= 6 then
		color = Color(0, 255, 0) -- Green
	elseif count >= 7 and count <= 11 then
		color = Color(255, 255, 0) -- Yellow
	elseif count >= 12 and count <= 15 then
		color = Color(255, 0, 0) -- Red
	elseif count >= 16 then
		color = Color(128, 0, 0) -- Darker red
	else
		color = Color(255, 255, 255)
	end
	
	if count > 0 then
		draw.SimpleTextOutlined("Total Zombies Alive: " .. count, "DermaLarge", ScrW() / 2, 42, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
	else
		draw.SimpleTextOutlined("Total Zombies Alive:", "DermaLarge", ScrW() / 2, 42, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
	end
end

hook.Add("HUDPaint", "DrawZombieCount", DrawZombieCount)