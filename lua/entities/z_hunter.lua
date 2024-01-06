---------------------------------------------------------------------------------------------------------------------------------------------
AddCSLuaFile()

ENT.Base = "base_nextbot"
ENT.PrintName = "Hunter"
ENT.Author = "Pyri"
ENT.IsSpecialInfected = true
ENT.IsHunter = true
ENT.IsWalking = false
ENT.IsRunning = false
ENT.Gender = nil
ENT.IsClimbing = false
ENT.HasLanded = false
---------------------------------------------------------------------------------------------------------------------------------------------

--- Include files based on sv_ sh_ or cl_
--- These will load hunter files for our Hunter to use
--[[local ENT_HunterFiles = file.Find( "left4dead/hunter/*", "LUA", "nameasc" )

for k, luafile in ipairs( ENT_HunterFiles ) do
	if string.StartWith( luafile, "sv_" ) then -- Server Side Files
		include( "left4dead/hunter/" .. luafile )
		print( "Left 4 Dead Hunter ENT TABLE: Included Server Side ENT Lua File [" .. luafile .. "]" )
	elseif string.StartWith( luafile, "sh_" ) then -- Shared Files
		if SERVER then
			AddCSLuaFile( "left4dead/hunter/" .. luafile )
		end
		include( "left4dead/hunter/" .. luafile )
		print( "Left 4 Dead Hunter ENT TABLE: Included Shared ENT Lua File [" .. luafile .. "]" )
	elseif string.StartWith( luafile, "cl_" ) then -- Client Side Files
		if SERVER then
			AddCSLuaFile( "left4dead/hunter/" .. luafile )
		else
			include( "left4dead/hunter/" .. luafile )
			print( "Left 4 Dead Hunter ENT TABLE: Included Client Side ENT Lua File [" .. luafile .. "]" )
		end
	end
end]]

--Handling Killfeed entries.
include( "left4dead/autorun_includes/server/netmessages.lua" )
local OnNPCKilledHook = GetConVar( "l4d_sv_call_onnpckilled" )

-- Set our global locals later!!!!

local collisionmins = Vector( -12, -12, 0 )
local collisionmaxs = Vector( 8, 10, 72 )
local crouchingcollisionmaxs = Vector( 16, 16, 36 )

-- Convars
local ignorePlys = GetConVar( "ai_ignoreplayers" )
local sv_gravity = GetConVar( "sv_gravity" )
local developer = GetConVar( "developer" )
local z_Difficulty = GetConVar( "l4d_sv_difficulty" )
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	--game.AddParticles( "particles/boomer_fx.pcf" )

	if SERVER then

		self:SetModel( "models/infected/specials/hunter_l4d1.mdl" )

		local skinCount = self:SkinCount()
		if skinCount > 0 then self:SetSkin( math.random( 0, skinCount - 1 ) ) end

		self:SetBehavior( "Idle" ) -- The state for our behavior thread is currently running
		self.h_lastfootsteptime = 0 -- The last time we played a footstep sound
		self.SpeakDelay = 0 -- the last time we spoke

		self:SetMaxHealth( 250 )
		self:SetHealth( 250 )

		self:SetShouldServerRagdoll( true )

		-- Adjust Step Height for climbing
		self.loco:SetStepHeight( 22 )
		self.loco:SetGravity( sv_gravity:GetFloat() )

		self:SetCollisionBounds( collisionmins, collisionmaxs )
		self:PhysicsInitShadow()
		self:SetSolid( SOLID_BBOX )

		self:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )

		self:SetLagCompensated( true )
		self:AddFlags( FL_OBJECT + FL_NPC + FL_CLIENT )
		self:SetSolidMask( MASK_PLAYERSOLID )

		-- Breathing Anims layer
		self:AddGestureSequence( self:LookupSequence( "idlenoise" ), false )

	elseif CLIENT then
		self.h_lastdraw = 0
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--Bypass for Lambda Players, so there wont be duplicate entires caused by netmessages from both l4d2 nextbots and lambda players
--TL:DR This suppresses lambda players DeathNotice hook overide.
function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 1, "IsDead" )
end

function ENT:Alive()
	return !self:GetIsDead()
end

function ENT:Nick()
	return GetDeathNoticeZombieName( self )
end

function ENT:Name()
	return GetDeathNoticeZombieName( self )
end

function ENT:IsPlayingTaunt()
	return false
end

function ENT:GetState()
	return "Nothing"
end

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Draw()
	self.h_lastdraw = RealTime() + 0.1
	self:DrawModel()
end
---------------------------------------------------------------------------------------------------------------------------------------------
list.Set( "NPC", "z_hunter", {
	Name = "Hunter",
	Class = "z_hunter",
	Category = "Left 4 Dead NextBots"
})

if CLIENT then language.Add( "z_hunter", "Hunter" ) end
---------------------------------------------------------------------------------------------------------------------------------------------


-- MOVE THISE INTO IT"S HUNTER FILE LATER
---------------------------------------------------------------------------------------------------------------------------------------------
-- Get the current behavior
function ENT:GetCurrentBehavior()
	return self.ci_BehaviorState
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Set our behavior
function ENT:SetBehavior( action )
	self.ci_BehaviorState = action
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Play the requested voiceline
-- Action = the global voiceset
-- Need to make a check for IsSpeaking
function ENT:Vocalize( action, isSFX )
	local pitch
	local Snd = action[ random( #action ) ]

	if isSFX == true then
		pitch = 100
	else
		if self.Gender == "Female" then
			pitch = random( 100, 112 )
		elseif self.Gender == "Male" then
			pitch = random( 94, 104 )
		end
	end

	self:EmitSound( Snd, 80, pitch )
end
---------------------------------------------------------------------------------------------------------------------------------------------