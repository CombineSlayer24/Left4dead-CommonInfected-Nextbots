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

InitializeAddon()

concommand.Add( "l4d_dev_reloadaddon", InitializeAddon )
-- Down below will be how we spawn Zombies in to
-- implement into our director. Will be here
-- for now.

local IsValid = IsValid
local random = math.random
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
local util_TraceHull = util.TraceHull

-- Check if a vector is within the player's FOV

local function IsInFOV( player, vec )
    local direction = ( vec - player:GetPos() ):GetNormalized()
    local dot = player:EyeAngles():Forward():Dot( direction )
    local fov_desired = GetConVar( "fov_desired" ):GetInt()
    return dot > Cos( Rad( fov_desired / 2 ) )
end


-- Check if a vector is visible from the player's perspective
local function IsVisible( player, vec )
    local tr = util.TraceLine({
        start = player:EyePos(),
        endpos = vec,
        filter = player
    })

    if tr.HitWorld then
        local material = tr.MatType
        if material == MAT_GLASS or material == MAT_GRATE then return true end
        return false
    end

    return true
end

CreateConVar( "l4d_nb_z_spawn_radius", 2000, FCVAR_ARCHIVE, "Should Zombies spawn in player sightlines?", 250, 25000 )

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
		   nav:GetCenter().z >= playerZ - 40 and nav:GetCenter().z <= playerZ + 40 ) then

			-- Check if the center of the nav area is visible to the player and within their FOV 
			if ( !IsVisible( caller, nav:GetCenter() ) and !IsInFOV( caller, nav:GetCenter() )) then 
				local width = nav:GetSizeX()
				local height = nav:GetSizeY()
				local maxOffset = width <= 40 and height <= 40 and 1 or 20  -- Set the max offset based on the size of the navmesh area 
				local xyOffset = VectorRand() * maxOffset -- Randomize X and Y components, keep Z at 0 
				xyOffset.z = 25

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

local function SpawnNPC( pos, class, caller )
	local plyradius = GetConVar( "l4d_nb_z_spawn_radius" )
	if !IsValid( caller ) then return end
	
	if !pos then
		local areas = GetNavAreasNear( caller:GetPos(), plyradius:GetInt(), caller )
		pos = areas[ random( #areas ) ]
		if !pos then return end
	end

	local npc = ents_Create( class )
	npc:SetPos( pos )
	npc:SetAngles( Angle( 0, random( -180, 180 ), 0 ) )
	npc:Spawn()

	local effect = EffectData()
	effect:SetEntity( npc )
	util_Effect( "propspawn", effect )

	undo_Create( "NPC (" .. class .. ")" )
	undo_SetPlayer( caller )
	undo_SetCustomUndoText( "Undone " .. "NPC (" .. class .. ")" )
	undo_AddEntity( npc )
	undo_Finish( "NPC (" .. class .. ")" )

	return npc
end

local function SpawnRandomZombie(caller)

	SpawnNPC( nil, "z_common", caller )
end

concommand.Add( "l4d_nb_z_spawn", SpawnRandomZombie, nil, "Spawn a Zombie at a random Navmesh area")

local function SpawnMob(caller)

	SpawnNPC( nil, "z_common", caller )
	SpawnNPC( nil, "z_common", caller )
	SpawnNPC( nil, "z_common", caller )
	SpawnNPC( nil, "z_common", caller )
	SpawnNPC( nil, "z_common", caller )
	SpawnNPC( nil, "z_common", caller )
	SpawnNPC( nil, "z_common", caller )
	SpawnNPC( nil, "z_common", caller )
	SpawnNPC( nil, "z_common", caller )
	SpawnNPC( nil, "z_common", caller )
	SpawnNPC( nil, "z_common", caller )
	SpawnNPC( nil, "z_common", caller )
	SpawnNPC( nil, "z_common", caller )
	SpawnNPC( nil, "z_common", caller )
	SpawnNPC( nil, "z_common", caller )
	SpawnNPC( nil, "z_common", caller )
	SpawnNPC( nil, "z_common", caller )

	if IsValid(caller) then
		local soundPath = Z_Music_Germs[math.random(#Z_Music_Germs)]
		caller:EmitSound(soundPath,75,100,1)
		PrintMessage(HUD_PRINTCENTER, "[Incoming Attack!]")
	end
end

concommand.Add( "l4d_nb_z_spawn_mob", SpawnMob, nil, "Spawn a Mob at a random Navmesh area")

-- Used for cleaning up stuff for debugging
-- Credit to VJ Base
if SERVER then
	local IsValid = IsValid
	local ipairs = ipairs
	local ents_GetAll = ents.GetAll
	local player_GetAll = player.GetAll
	
	local cTypes = {
		infected = "Infected",
		groundweapons = "Ground Weapons",
		props = "Props",
		decals = "Removed All Decals",
		allweapons = "Removed All Your Weapons",
		allammo = "Removed All Your Ammo",
	}
	
	concommand.Add("l4d_d_cleanup", function( ply, cmd, args )
		local plyValid = IsValid( ply )
		if plyValid and !ply:IsAdmin() then return end
		
		local cType = args[ 1 ]
		local i = 0
		
		if !cType then
			game.CleanUpMap()
		elseif cType == "decals" then
			for _, v in ipairs( player_GetAll() ) do
				v:ConCommand( "r_cleardecals" )
			end
		elseif plyValid and cType == "allweapons" then
			ply:StripWeapons()
		elseif plyValid and cType == "allammo" then
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
			if !cType then
				ply:SendLua( "GAMEMODE:AddNotify( \"Cleaned Up Everything!\", NOTIFY_CLEANUP, 5 )" )
			elseif cType == "decals" or cType == "allweapons" or cType == "allammo" then
				ply:SendLua( "GAMEMODE:AddNotify( \""..cTypes[ cType ].."\", NOTIFY_CLEANUP, 5 )" )
			else
				ply:SendLua( "GAMEMODE:AddNotify( \"Removed "..i.." "..cTypes[ cType ].."\", NOTIFY_CLEANUP, 5 )" )
			end
			ply:EmitSound( "ui/beepclear.wav" )
		end
	end, nil, "", {FCVAR_DONTRECORD})
end
