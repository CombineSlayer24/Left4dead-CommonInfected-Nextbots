local random = math.random
local IsValid = IsValid

if SERVER then
	util.AddNetworkString("ZombieDeath")
	util.AddNetworkString( "Event_Vomited" )
	util.AddNetworkString( "Event_Highlight_Entity" )

	local KillfeedOverride = CreateConVar("l4d_sv_killfeed_override", 0, FCVAR_ARCHIVE + FCVAR_NOTIFY, "If L4D2 Nextbots should override killfeed so it wont display two killfeed entries?", 0, 1)
	local CallNPCKilled = CreateConVar("l4d_sv_call_onnpckilled", 0, FCVAR_ARCHIVE + FCVAR_NOTIFY, "If L4D2 Nextbots should call 'OnNPCKilled' hook?", 0, 1)

	function GetDeathNoticeZombieName( ent )
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
			
		local victimname = ( ( victim.IsLambdaPlayer or victim:IsPlayer() ) and victim:Nick() or ( victim.IsZetaPlayer and victim.zetaname or GetDeathNoticeZombieName( victim ) ) )
		
		local attackerclass = attacker:GetClass()
		local attackername = ( ( attacker.IsLambdaPlayer or attacker:IsPlayer() ) and attacker:Nick() or ( attacker.IsZetaPlayer and attacker.zetaname or GetDeathNoticeZombieName( attacker ) ) )
	
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

	function HandleHaloEvent( entity, entityType )
		net.Start( "Event_Highlight_Entity" )
		net.WriteEntity( entity )
		net.WriteString( entityType )
		net.Broadcast()
	end

	function HandleVomitEvent( victim, type )
		if IsValid( victim ) and ( !victim.NextVomitTime or victim.NextVomitTime < CurTime() ) then
			victim.NextVomitTime = CurTime() + 2
			victim.Is_Vomited = true
			net.Start( "Event_Vomited" )
			net.WriteEntity( victim )
			net.WriteString( type )
			net.Broadcast()

			if type == "Infected" then 
				victim:Vocalize( ZCommon_Pain )
				victim:EmitSound( "left4dead/music/tags/pukricidehit.wav", 75, 100, 0.6 )
			end

			if type == "HumanPlayer" then 
				victim:ViewPunch( Angle( random( -1, 8 ), random( -1, 10 ), random( -1, 12 ) ) )
			end

			if type == "LambdaPlayer" then
				if random( 100 ) <= victim:GetVoiceChance() then
					local soundFiles = { "death", "panic", "witness" }
					victim:PlaySoundFile( soundFiles[random( 3 ) ] )
				end

				if random( 2 ) == 1 then
					victim:RetreatFrom()
				end

				victim:EmitSound( "left4dead/music/tags/pukricidehit.wav", 75, 100, 0.6 )
			end
		end
	end

	concommand.Add("l4d_dev_check_vomit", function(ply, cmd, args)
		local entity
	
		if args[1] == "self" then
			entity = ply
		else
			local trace = ply:GetEyeTrace()
			entity = trace.Entity
		end
	
		if IsValid(entity) then
			print("Classname: " .. entity:GetClass())
	
			if entity.Is_Vomited then
				print("This entity has been vomited on.")
			else
				print("This entity has not been vomited on.")
			end
		else
			print("No entity found.")
		end
	end)
	
end


if CLIENT then
	local KillfeedOverrideClient = GetConVar("l4d_sv_killfeed_override"):GetBool()
	
	hook.Add( "Initialize", "l4d_killfeedoverride", function()
		if !KillfeedOverrideClient then return end
		local olddeathnoticehookfunc = GAMEMODE.AddDeathNotice

		function GAMEMODE:AddDeathNotice( attacker, attackerTeam, inflictor, victim, victimTeam, flags )
			if attacker == "#z_common" then return end
			if attacker == "#npc_lambdaplayer" then return end --If user have lambdas, adding this wont break lambdas killfeed and cause broken override from Lambda Players.
			olddeathnoticehookfunc( self, attacker, attackerTeam, inflictor, victim, victimTeam, flags )
		end
	end)

	net.Receive("ZombieDeath", function()
		local attacker = net.ReadString()
		local attackerTeam = net.ReadInt(8)
		local victim = net.ReadString()
		local victimTeam = net.ReadInt(8)
		local inflictor = net.ReadString()
		GAMEMODE:AddDeathNotice(attacker, attackerTeam, inflictor, victim, victimTeam)
	end)
end