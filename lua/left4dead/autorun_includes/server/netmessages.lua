if SERVER then
    util.AddNetworkString("ZombieDeath")

    local function GetDeathNoticeEntityName( ent )
        if ent:GetClass() == "npc_citizen" then
            if ent:GetModel() == "models/odessa.mdl" then return "Odessa Cubbage" end
    
            local name = ent:GetName()
            if name == "griggs" then return "Griggs" end
            if name == "sheckley" then return "Sheckley" end
            if name == "tobias" then return "Laszlo" end
            if name == "stanley" then return "Sandy" end
        end

        if ent:GetClass() == "z_common" then
            if ent.UnCommonType == "FALLEN" then return "Fallen Survivor" end
            if ent.UnCommonType == "JIMMYGIBBS" then return "Jimmy Gibbs Jr." end
            if ent.UnCommonType == "CEDA" then return "CEDA Agent" end
            if ent.UnCommonType == "ROADCREW" then return "Worker Infected" end
            if ent.UnCommonType == "RIOT" then return "Riot Infected" end
            if ent.UnCommonType == "MUDMEN" then return "Mud Infected" end
            if ent.UnCommonType == "CLOWN" then return "Clown Infected" end
        end
    
        if ent:IsVehicle() and ent.VehicleTable and ent.VehicleTable.Name then
            return ent.VehicleTable.Name
        end
        if ent:IsNPC() and ent.NPCTable and ent.NPCTable.Name then
            return ent.NPCTable.Name
        end
    
        return "#" .. ent:GetClass()
    end
    
    function AddZombieDeath( victim, attacker, inflictor )
        if !attacker:IsWorld() and !IsValid( attacker ) then return end 
            
        local victimname = ( ( victim.IsLambdaPlayer or victim:IsPlayer() ) and victim:Nick() or ( victim.IsZetaPlayer and victim.zetaname or GetDeathNoticeEntityName( victim ) ) )
        
        local attackerclass = attacker:GetClass()
        local attackername = ( ( attacker.IsLambdaPlayer or attacker:IsPlayer() ) and attacker:Nick() or ( attacker.IsZetaPlayer and attacker.zetaname or GetDeathNoticeEntityName( attacker ) ) )
    
        local victimteam = ( ( victim.IsLambdaPlayer or victim:IsPlayer() ) and victim:Team() or -1 )
        local attackerteam = ( ( attacker.IsLambdaPlayer or attacker:IsPlayer() ) and attacker:Team() or -1 )
    
        local attackerWep = attacker.GetActiveWeapon
        local inflictorname = ( victim == attacker and "suicide" or ( IsValid( inflictor ) and ( inflictor.l_killiconname or ( ( inflictor == attacker and attackerWep and IsValid( attackerWep( attacker ) ) ) and attackerWep( attacker ):GetClass() or inflictor:GetClass() ) ) or attackerclass ) )
       
        if attacker.IsLambdaPlayer then
            victim.IsLambdaPlayer = true
        end
        net.Start("ZombieDeath")
        net.WriteString( attackername )
        net.WriteInt( attackerteam, 8 )
        net.WriteString( victimname )
        net.WriteInt( victimteam, 8 )
        net.WriteString( inflictorname )
        net.Broadcast()
    end
end


if CLIENT then
    net.Receive("ZombieDeath", function()
        local attacker = net.ReadString()
        local attackerTeam = net.ReadInt(8)
        local victim = net.ReadString()
        local victimTeam = net.ReadInt(8)
        local inflictor = net.ReadString()
        GAMEMODE:AddDeathNotice(attacker, attackerTeam, inflictor, victim, victimTeam)
    end)
end