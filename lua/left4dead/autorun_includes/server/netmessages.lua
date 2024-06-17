local random 					= math.random
local IsValid 					= IsValid
local Angle 					= Angle
local hook_Add 					= hook.Add
local util_AddNetworkString 	= util.AddNetworkString
local net_Start 				= net.Start
local net_Receive 				= net.Receive
local net_WriteString 			= net.WriteString
local net_WriteInt 				= net.WriteInt
local net_Broadcast 			= net.Broadcast
local net_WriteEntity 			= net.WriteEntity
local net_ReadString 			= net.ReadString
local net_ReadInt 				= net.ReadInt

if SERVER then
	util_AddNetworkString( "ZombieDeath" )
	util_AddNetworkString( "Event_Vomited" )
	util_AddNetworkString( "Event_Highlight_Entity" )

	local KillfeedOverride 	= CreateConVar("l4d_sv_killfeed_override", 0, FCVAR_ARCHIVE + FCVAR_NOTIFY, "If L4D2 Nextbots should override killfeed so it wont display two killfeed entries?", 0, 1)
	local CallNPCKilled 	= CreateConVar("l4d_sv_call_onnpckilled", 0, FCVAR_ARCHIVE + FCVAR_NOTIFY, "If L4D2 Nextbots should call 'OnNPCKilled' hook?", 0, 1)

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
			--if ent.UnCommonType == "CLOWN_L4D1" then return "Noisemaker Infected" end
			-- Need permission to use Noisemaker infected before we can use it
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

		net_Start( "ZombieDeath" )
		net_WriteString( attackername )
		net_WriteInt( attackerteam, 8 )
		net_WriteString( victimname )
		net_WriteInt( victimteam, 8 )
		net_WriteString( inflictorname )
		net_Broadcast()
	end

	function HandleHaloEvent( entity, entityType )
		net_Start( "Event_Highlight_Entity" )
		net_WriteEntity( entity )
		net_WriteString( entityType )
		net_Broadcast()
	end

	function HandleVomitEvent( victim, entType )
		if IsValid( victim ) and ( !victim.NextVomitTime or victim.NextVomitTime < CurTime() ) then
			victim.NextVomitTime = CurTime() + 2
			victim.Is_Vomited = true
			net_Start( "Event_Vomited" )
			net_WriteEntity( victim )
			net_WriteString( entType )
			net_Broadcast()

			if entType == "Infected" then 
				victim:Vocalize( ZCommon_Pain )
			end

			if entType == "HumanPlayer" then 
				victim:ViewPunch( Angle( random( -1, 8 ), random( -1, 10 ), random( -1, 12 ) ) )
			end

			if entType == "LambdaPlayer" then
				if random( 100 ) <= victim:GetVoiceChance() then
					local soundFiles = { "death", "panic", "witness" }
					victim:PlaySoundFile( soundFiles[ random( 3 ) ] )
				end

				if random( 2 ) == 1 then
					victim:RetreatFrom()
				end
			end

			-- The vomit soundeffect to play 
			if entType != "HumanPlayer" then
				victim:EmitSound( "left4dead/music/tags/pukricidehit.wav", 75, 100, 0.6 )
			else
				--TODO: Play the puke music on clientside only for human players!
			end
		end
	end
end


if CLIENT then
	local KillfeedOverrideClient = GetConVar("l4d_sv_killfeed_override"):GetBool()
	
	hook_Add( "Initialize", "l4d_killfeedoverride", function()
		if !KillfeedOverrideClient then return end
		local olddeathnoticehookfunc = GAMEMODE.AddDeathNotice

		function GAMEMODE:AddDeathNotice( attacker, attackerTeam, inflictor, victim, victimTeam, flags )
			if attacker == "#z_common" then return end
			if attacker == "#npc_lambdaplayer" then return end --If user have lambdas, adding this wont break lambdas killfeed and cause broken override from Lambda Players.
			olddeathnoticehookfunc( self, attacker, attackerTeam, inflictor, victim, victimTeam, flags )
		end
	end)

	net_Receive("ZombieDeath", function()
		local attacker 		= net_ReadString()
		local attackerTeam 	= net_ReadInt( 8 )
		local victim 		= net_ReadString()
		local victimTeam 	= net_ReadInt( 8 )
		local inflictor 	= net_ReadString()
		GAMEMODE:AddDeathNotice( attacker, attackerTeam, inflictor, victim, victimTeam )
	end)
end