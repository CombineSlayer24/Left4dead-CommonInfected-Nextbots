---------------------------------------------------------------------------------------------------------------------------------------------
AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Spawnable = false

include( "left4dead/autorun_includes/client/haloglow.lua" )
include( "left4dead/z_common/sh_util.lua" )

local random = math.random
local ents_FindInSphere = ents.FindInSphere
local pairs = pairs
local EmitSound = EmitSound
local abs = math.abs
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Draw()
	self:DrawModel()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	if SERVER then
		self:SetModel( "models/w_models/weapons/w_eq_bile_flask.mdl" )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_NONE )
		self:DrawShadow( false )
		self:SetModelScale( 1.5, 0 )
	end

	self:EmitSound("TFA_L4D1_SNIPER.DRAW")
	self.ActiveTimer = CurTime() + 1.5
	self:PhysicsInitSphere( 8 )
	self.HasExploded = false
	self.ExplodeTime = CurTime() + 3.6
end

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	if SERVER and self.ExplodeTime <= CurTime() then
		self:JarExplode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:JarExplode()
	if self.HasExploded then return end

	self:EmitSound( "weapons/ceda_jar/ceda_jar_explode.wav", 85, 100, 1 , CHAN_WEAPON )
	ParticleEffect( "vomit_jar", self:GetPos() + Vector(0, 0, 0), self:GetAngles() )
	SafeRemoveEntityDelayed( self, 13 )
	
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_NONE )
	self:PhysicsInit( SOLID_NONE )
	self:SetCollisionGroup( COLLISION_GROUP_NONE )
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self:SetColor( Color( 255, 255, 255, 0 ) )
	self:DrawShadow( false )
	self:StopParticles()

	local entities = ents_FindInSphere( self:GetPos(), 200 )
	for _, entity in pairs( entities ) do
		if entity:IsNextBot() then
			entity:EmitSound( "left4dead/music/tags/pukricidehit.wav", 75, 100, 0.6 )
			--PrintMessage( HUD_PRINTTALK, "Boomer juice slopped on nextbot" )
			
			if entity.IsCommonInfected then HandleVomitEvent( entity, "Infected" ) end
			if entity.IsLambdaPlayer then HandleVomitEvent( entity, "LambdaPlayer" ) end

			-- If our nb isn't a Infected or Lambda, then assume Generic
			if !entity.IsCommonInfected and !entity.IsLambdaPlayer then
				HandleVomitEvent( entity, "GenericNextBot" )
			end
		end

		-- Player vomit event
		if entity:IsPlayer() then
			HandleVomitEvent( entity, "HumanPlayer" )
		end

		-- NPC vomit event
		if entity:IsNPC() then
			HandleVomitEvent( entity, "NPC" )
		end
	end

	self.HasExploded = true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide( data, phys )
	if self.HasExploded then return end

	if SERVER and self.ActiveTimer > CurTime() || data.Speed >= 150 then
		self:EmitSound(Sound( "GlassBottle.ImpactHard" ) )
	end

	-- If it's a direct hit, deal minor damage
	local hitEntity = data.HitEntity
	if hitEntity and hitEntity:IsValid() then
		hitEntity:TakeDamage( 50, self:GetOwner(), self )
	end

	local ang = data.HitNormal:Angle()
	ang.p = abs( ang.p )
	ang.y = abs( ang.y )
	ang.r = abs( ang.r )
	
	-- We hit the wall, bounce off of it
	if ang.p > 90 or ang.p < 60 and data.HitEntity:IsWorld() then
		self:EmitSound(Sound( "GlassBottle.ImpactHard" ) )

		local impulse = ( data.OurOldVelocity - 0.2 * data.OurOldVelocity:Dot( data.HitNormal ) * data.HitNormal ) * 0.05
		phys:ApplyForceCenter( impulse )

		-- Our jar spins like crazy, limit the spinning
		phys:AddAngleVelocity( -0.8 * phys:GetAngleVelocity() )
	else
		self:JarExplode()
	end

	SafeRemoveEntityDelayed(self, 10)
end
---------------------------------------------------------------------------------------------------------------------------------------------