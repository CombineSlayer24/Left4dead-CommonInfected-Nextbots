local function CreateLeft4DeadMenu()
    spawnmenu.AddToolTab( "Left 4 Dead NextBots", "Left4DeadNextBots", "l4d_icon.png" )
end


local function AddLeft4DeadOptions()
    spawnmenu.AddToolMenuOption( "Common Infected", "Settings", "l4d_ci_settings" , "", "", "", function( panel ) 
        if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
            panel:Help( "Admins can only make changes." )
            return
        end

        Panel:CheckBox( string label, string convar )

    end )
end



hook.Add( "AddToolMenuTabs", "AddLambdaPlayertabs", CreateLeft4DeadMenu )
hook.Add( "PopulateToolMenu", "AddLambdaPlayerPanels", AddLeft4DeadOptions )