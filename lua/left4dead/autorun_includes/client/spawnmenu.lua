--[[ local function CreateLeft4DeadMenu()
	spawnmenu.AddToolTab( "Left 4 Dead NextBots", "Left 4 Dead Next Bots", "l4d_icon.png" )
end

local function AddLeft4DeadOptions()
	spawnmenu.AddToolMenuOption( "Left 4 Dead NextBots", "The Infected", "Settings", "Settings", "", "", function( panel ) 
		if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
			panel:Help( "Admins can only make changes." )
			return
		end
		
		panel:Help( "--------- HEALTH RELATED CONVARS ---------" )

		panel:NumSlider( "CI Health", "l4d_sv_z_health", 1, 1000, 0 )
		panel:ControlHelp( "Spawning health for the Common Infected. \nDefault value = 50" )

		panel:NumSlider( "Fallen Health Multiplier", "l4d_sv_z_fallen_health_multiplier", 1.0, 100.0, 1 )
		panel:ControlHelp( "Health multiplier for Fallen Survivor. \nDefault value = 20.0 (1000 Health)" )

		panel:NumSlider( "Jimmy Health Multiplier", "l4d_sv_z_jimmy_health_multiplier", 1.0, 100.0, 1 )
		panel:ControlHelp( "Health multiplier for Jimmy Gibbs Jr. \nDefault value = 20.0 (3000 Health)" )

		panel:Help( "--------- COMBAT RELATED CONVARS ---------" )

		local comboBox = panel:ComboBox( "Difficulty", "l4d_sv_difficulty" )
		comboBox:AddChoice( "0 = Easy", 0 )
		comboBox:AddChoice( "1 = Normal", 1 )
		comboBox:AddChoice( "2 = Advanced", 2 )
		comboBox:AddChoice( "3 = Expert", 3 )
		panel:ControlHelp( "Difficulty for Infected? \n0 - Easy, 1 - Normal, 2 - Advanced, 3 - Expert" )

	end )
end

hook.Add( "AddToolMenuTabs", "AddLambdaPlayertabs", CreateLeft4DeadMenu )
hook.Add( "PopulateToolMenu", "AddLambdaPlayerPanels", AddLeft4DeadOptions ) ]]