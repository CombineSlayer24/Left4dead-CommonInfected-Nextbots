ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Alarm Car"
ENT.Category		= "Fun + Games"

ENT.Spawnable		= true
ENT.AdminOnly 		= true
ENT.IsTriggered 	= false

if SERVER then
	AddCSLuaFile()

	local IsValid = IsValid
	local Vector = Vector
	local CurTime = CurTime
	local EmitSound = EmitSound
	local ipairs = ipairs
	local Color = Color
	local ents_Create = ents.Create
	local timer_Simple = timer.Simple
	local timer_Create = timer.Create
	local timer_TimeLeft = timer.TimeLeft
	local table_Random = table.Random
	local random = math.random
	local Rand = math.Rand
	local Angle = Angle
	
	local chripSnd = "vehicles/car_alarm/car_alarm_chirp2.wav"
	local glassMdl = "models/props_vehicles/cara_95sedan_glass.mdl"
	local carMdl = "models/props_vehicles/cara_95sedan.mdl"

	local matAlarm = "models/props_vehicles/cara_95sedan_glass_alarm"
	local matAlarmExpired = "models/props_vehicles/4carz1024_glass"
	
	local alarmSnd = {
		"vehicles/car_alarm/car_alarm.wav",
		"vehicles/car_alarm/car_alarm2.wav",
		"vehicles/car_alarm/car_alarm3.wav",
	}
	
	local posTbl = {
		Vector( -106, -32, 31 ),
		Vector( -106, 32, 31 ),
		Vector( 101, -37, 30 ),
		Vector( 101, 37, 30 )
	}

	local carColors = {
		Color(200, 90, 45),  -- Orangish
		Color(215, 110, 65),  -- Bright Orange
		Color(200, 145, 45),  -- Yellowish
		Color(175, 75, 20),  -- Redish
	}


	local Rad = math.rad
	local Cos = math.cos
	local VectorRand = VectorRand
	local util_TraceHull = util.TraceHull
	
	-- Check if a vector is within the player's FOV and visible from the player's perspective
	local function IsInFOVAndVisible( player, vec )
		local direction = ( vec - player:GetPos() ):GetNormalized()
		local dot = player:EyeAngles():Forward():Dot( direction )
		local fov_desired = GetConVar( "fov_desired" ):GetInt()
		local isInFOV = dot > Cos( Rad( fov_desired / 2 ) )
	
		local plyradius = GetConVar( "l4d_z_spawn_radius" ):GetFloat()
		local distance = player:GetPos():Distance( vec )
		local isVisible = distance < plyradius   -- Consider points visible if they are within the spawn radius
	
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
	local function GetNavAreasNear( pos, radius, ply )
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
				if !IsNavMeshVisible( ply, nav ) then
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
	
	local function SpawnNPC( class, ply, amount )
		if !IsValid( ply ) then return end
	
		local areas = GetNavAreasNear( ply:GetPos(), 2000, ply )
		if !areas or #areas == 0 then return end
		local spawnTimerName = "SpawnTimer_" .. ply:UserID() -- Unique timer name for each player
	
		local pos

		pos = areas[ random( #areas ) ]
	
		timer.Create(spawnTimerName, 0.065, amount, function()

			local npc = ents_Create( class )
	
			-- Add a random offset to the spawn position
			local offset = Vector( Rand( -5, 5 ), Rand(- 5, 5 ), 0 )
			npc:SetPos( pos + offset )
	
			npc:SetAngles( Angle( 0, math.random( -180, 180 ), 0 ) )
			npc:Spawn()
		end)
	end

	local function SpawnMegaHorde( ply )
		if IsValid( ply ) then
	
			local soundPath
			local npcType = "z_common" -- Ent Name
	
			local amount = Rand( 12, 16 )
			timer_Simple( 0.75, function()
				ply:EmitSound("left4dead/vocals/infected/sfx/megamob_" .. random( 2 ) .. ".mp3", 75, 100, 1 )
			end)

			timer_Simple( 3, function()
				soundPath = Z_Music_Germs[ random( #Z_Music_Germs ) ]
				ply:EmitSound( soundPath, 75, 100, 1 )
				SpawnNPC( npcType, ply, amount )
			end)
		end
	end
	
	function ENT:SpawnFunction( ply, tr )
		if !tr.Hit then return end
		local SpawnPos = tr.HitPos + tr.HitNormal * 20
		local ent = ents_Create( "sent_car_alarm_95" )
		local color = table_Random( carColors )
		
			-- Adjust the angle of the car to face the player
		local ang = ply:GetAngles()
		ang.yaw = ang.yaw + 90 -- Rotate the car 90 degrees
		ent:SetAngles(ang)

		ent:SetPos( SpawnPos )
		ent:Spawn()
		ent:Activate()
		ent:SetColor( color )

		-- Save the selected color
		ent.CarColor = color
		return ent
	end

	function ENT:CreateGlass()
		local glass = ents.Create( "prop_physics" )
		glass:SetModel( glassMdl )
		glass:SetPos( self:GetPos() )
		glass:SetAngles( self:GetAngles() )
		glass:SetParent( self )
		glass:Spawn()
		glass:Activate()
		glass:SetMaterial( matAlarm )
		glass:SetSubMaterial( 0, matAlarm )
		glass:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
		glass.PhysgunDisabled = true
	
		local phys = glass:GetPhysicsObject()
		if ( phys:IsValid() ) then
			phys:EnableMotion( false )
		end

		self.Glass = glass
	
		return glass
	end
	
	function ENT:Initialize()
		self:SetModel( carMdl )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:DrawShadow( false )
		self:SetCollisionGroup( COLLISION_GROUP_NONE )
		self:CreateGlass()
		
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
	
		self.IsTriggered = false
	end
	
	function ENT:ValidAttacker( ent )
		if ent:IsPlayer() then return ent end
		if IsValid( ent:GetPhysicsAttacker() ) then
			return ent:GetPhysicsAttacker()
		end
	end
	
	function ENT:TriggerAlarm( ent )
		local mytarget = self:ValidAttacker( ent )
	
		if !self.IsTriggered and IsValid( mytarget ) then
			if timer_TimeLeft( "car_alarm" .. self:EntIndex() ) == nil then
				self.IsTriggered = true

				local snd = table_Random( alarmSnd )
				local killAlarmTime = 15
				self:EmitSound( snd, 150, 100, 1 )

				SpawnMegaHorde( ent )
				
				timer_Simple( killAlarmTime, function() 
					if IsValid( self ) then
						self:EndSounds()

						if IsValid( self.Glass ) then
							self.Glass:SetMaterial( matAlarmExpired )
							self.Glass:SetSubMaterial( 0, matAlarmExpired )
						end
					end
				end)
				
				for i = 1, 4 do
					local glow = ents_Create( "env_sprite" )
					glow:SetKeyValue( "model","sprites/glow1.vmt" )
					glow:SetKeyValue( "scale","0.5" )
					glow:SetKeyValue( "rendermode","5" )
					glow:SetKeyValue( "rendercolor","255 255 150" )
					glow:AddEFlags( EFL_NO_THINK_FUNCTION )
					glow:SetParent( self )
					glow:SetPos(self:LocalToWorld( posTbl[ i ] ) )
					glow:Spawn()
					glow:Activate()

					for ii = 0, 20 do
						timer_Simple( ii, function() 
							if IsValid( glow ) then
								glow:Fire( "Hidesprite", "", 0 )
								glow:Fire( "Showsprite", "", 0.5 )
							end
						end)
					end

					glow:Fire( "Kill", "", killAlarmTime )
					self:DeleteOnRemove( glow )
				end
				
				self:NextThink( CurTime() + killAlarmTime )
				
				timer_Create( "car_alarm" .. self:EntIndex(), 30, 1, function() end)
			end
		end
	end
	
	function ENT:OnTakeDamage( damage )
		if IsValid( damage:GetAttacker() ) then
			self:TakePhysicsDamage( damage )
			self:TriggerAlarm( damage:GetAttacker() )
		end
	end
	
	function ENT:Touch( ent )
		self:TriggerAlarm( ent )
	end
	
	function ENT:EndSounds()
		for _, snd in ipairs( alarmSnd ) do
			self:StopSound( snd )
		end
	end
	
	function ENT:OnRemove()
		self:EndSounds()
	end
	
	function ENT:Think()
		if !self.IsTriggered then

			-- Only chirp and flash warnings when close
			for _, ply in ipairs( ents.FindInSphere( self:GetPos(), 500 ) ) do
				if ply:IsPlayer() then
			
					if random( 2 ) == 1 then
						self:EmitSound( chripSnd, 150 )
					end
					
					for i = 1, 4 do
						local glow = ents_Create( "env_sprite" )
						glow:SetKeyValue( "model", "sprites/glow1.vmt" )
						glow:SetKeyValue( "scale", "0.5" )
						glow:SetKeyValue( "rendermode", "5" )
						glow:SetKeyValue( "rendercolor", "255 255 150" )
						glow:AddEFlags( EFL_NO_THINK_FUNCTION )
						glow:SetParent( self )
						glow:SetPos( self:LocalToWorld( posTbl[ i ] ) )
						glow:Spawn()
						glow:Activate()
						glow:Fire( "Hidesprite", "", 0.2 )
						glow:Fire( "Showsprite", "", 0.4 )
						glow:Fire( "Kill","", 0.6 )
						self:DeleteOnRemove( glow )
					end
				end
			end
		end

		if self.IsTriggered then
			timer_Simple( 30, function()
				if IsValid( self ) and IsValid( self.Glass ) then
					-- Start fading out the car entity
					self:SetRenderMode( RENDERMODE_TRANSALPHA )
					self.Glass:SetRenderMode( RENDERMODE_TRANSALPHA )
					local fadeTime = 2.5 -- Time in seconds for the car to fade out
					local rate = 255 / fadeTime -- Rate at which the car should fade out
		
					for i = 0, fadeTime, 0.025 do
						timer_Simple( i, function()
							if IsValid( self ) and IsValid( self.Glass ) then
								local alpha = 255 - i * rate
								self:SetColor( Color( self.CarColor.r, self.CarColor.g, self.CarColor.b, alpha ) )
								self.Glass:SetColor( Color(255, 255, 255, alpha ) )
							end
						end)
					end
		
					-- Remove the car entity after it has faded out
					timer_Simple( fadeTime, function()
						if IsValid( self ) then
							self:Remove()
						end
					end)
				end
			end)
		end

		self:NextThink( CurTime() + 4 + Rand( -0.4, 0.4 ) )
		return true
	end

	function ENT:PhysicsCollide( data, phys )
		if data.DeltaTime > 0.2 then
			if data.Speed > 250 then
				self:EmitSound( "vehicles/v8/vehicle_impact_heavy" .. random( 4 ) .. ".wav", 75, random( 90, 110 ), 1 )
			else
				self:EmitSound( "vehicles/v8/vehicle_impact_medium" .. random( 4 ) .. ".wav", 75, random( 90, 110 ), 0.7 )
			end
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
		render.CullMode( MATERIAL_CULLMODE_CCW )
	end
end