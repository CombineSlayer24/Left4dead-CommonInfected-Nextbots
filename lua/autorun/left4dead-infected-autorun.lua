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