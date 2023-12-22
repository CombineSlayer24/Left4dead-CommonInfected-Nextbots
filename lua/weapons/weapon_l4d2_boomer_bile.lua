
-- SWEP Bases Variables

SWEP.FiresUnderwater 		    = true
SWEP.Category				    = "TFA L4D2 Throwables"
SWEP.Author					    = ""
SWEP.Contact				    = ""
SWEP.Purpose				    = ""
SWEP.Instructions			    = "Press B to Shove And Press Left Mouse Button to Throw!"
SWEP.PrintName				    = "Boomer Bile"
SWEP.Slot					    = 4
SWEP.SlotPos				    = 40
SWEP.DrawAmmo				    = true
SWEP.DrawWeaponInfoBox		    = false
SWEP.BounceWeaponIcon   	    = false
SWEP.DrawCrosshair			    = true
SWEP.Weight					    = 2
SWEP.AutoSwitchTo			    = true
SWEP.AutoSwitchFrom			    = true
SWEP.HoldType 				    = "grenade"

SWEP.ViewModelFOV			    = 74
SWEP.ViewModelFlip			    = false
SWEP.ViewModel				    = "models/weapons/viewmodels/c_bile_jar.mdl"
SWEP.WorldModel				    = "models/w_models/weapons/w_eq_bile_flask.mdl"
SWEP.ShowWorldModel			    = true
SWEP.Base					    = "tfa_nade_base"
SWEP.Spawnable				    = true
SWEP.UseHands 				    = true
SWEP.AdminSpawnable			    = true

SWEP.ProceduralHoslterEnabled 	= true
SWEP.ProceduralHolsterTime 		= 0.0
SWEP.ProceduralHolsterPos 		= Vector(0, 0, 0)
SWEP.ProceduralHolsterAng 		= Vector(0, 0, 0)

SWEP.Primary.RPM				= 120		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 1		-- Size of a clip
SWEP.Primary.DefaultClip		= 1		-- Bullets you start with
SWEP.Primary.Automatic			= false		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo				= "Grenade"				

SWEP.Primary.Round 				= ("tfa_l4d2_bile")	--NAME OF ENTITY GOES HERE

SWEP.Velocity 					= 300 -- Entity Velocity
SWEP.Velocity_Underhand 		= 350 -- Entity Velocity

SWEP.EventTable = {
	[ACT_VM_DRAW] = {
		{time = 0, type = "sound", value = Sound("TFA_L4D1_UZI.DRAW")},
	},
	[ACT_VM_HOLSTER] = {
		{time = 0, type = "sound", value = Sound("TFA_L4D1_UZI.DRAW")},
	}
}

SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
		Pos = {
		Up = 0,
		Right = 1,
		Forward = 3,
		},
		Ang = {
		Up = -1,
		Right = -2,
		Forward = 178
		},
		Scale = 1
}

SWEP.SprintAnimation = {
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "molotov_run", --Number for act, String/Number for sequence
		["is_idle"] = true
	},	
}

SWEP.WalkAnimation = { 
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "molotov_walk", --Number for act, String/Number for sequence
		["is_idle"] = true
	},
}


SWEP.AllowViewAttachment = true --Allow the view to sway based on weapon attachment while reloading or drawing, IF THE CLIENT HAS IT ENABLED IN THEIR CONVARS.
SWEP.Sprint_Mode = TFA.Enum.LOCOMOTION_HYBRID -- ANI = mdl, HYBRID = ani + lua, Lua = lua only
SWEP.Walk_Mode = TFA.Enum.LOCOMOTION_HYBRID -- ANI = mdl, HYBRID = ani + lua, Lua = lua only
SWEP.Idle_Mode = TFA.Enum.IDLE_BOTH --TFA.Enum.IDLE_DISABLED = no idle, TFA.Enum.IDLE_LUA = lua idle, TFA.Enum.IDLE_ANI = mdl idle, TFA.Enum.IDLE_BOTH = TFA.Enum.IDLE_ANI + TFA.Enum.IDLE_LUA
SWEP.Idle_Blend = 0 --Start an idle this far early into the end of a transition
SWEP.Idle_Smooth = 0 --Start an idle this far early into the end of another animation
SWEP.SprintBobMult = 0

DEFINE_BASECLASS (SWEP.Base)


SWEP.Secondary.BashDamage = 15
SWEP.Secondary.BashSound = Sound("TFA.Bash")
SWEP.Secondary.BashHitSound = Sound("TFA.BashWall")
SWEP.Secondary.BashHitSound_Flesh = Sound("TFA.BashFlesh")
SWEP.Secondary.BashLength = 54
SWEP.Secondary.BashDelay = 0.2
SWEP.Secondary.BashDamageType = DMG_SONIC
SWEP.Secondary.BashEnd = nil --Override bash sequence length easier
SWEP.Secondary.BashInterrupt = false --Do you need to be in a "ready" status to bash?
SWEP.BashBase = true

--SWEP.tmptoggle = true
function SWEP:BashForce(ent, force, pos, now)
	if not IsValid(ent) or not ent.GetPhysicsObjectNum then return end

	if now then
		if ent.GetRagdollEntity then
			ent = ent:GetRagdollEntity() or ent
		end

		local phys = ent:GetPhysicsObjectNum(0)

		if IsValid(phys) then
			if ent:IsPlayer() or ent:IsNPC() then
				ent:SetVelocity( force * 0.1)
				phys:SetVelocity(phys:GetVelocity() + force * 0.1)
			else
				phys:ApplyForceOffset(force, pos)
			end
		end
	else
		timer.Simple(0, function()
			if IsValid(self) and self:OwnerIsValid() and IsValid(ent) then
				self:BashForce(ent, force, pos, true)
			end
		end)
	end
end

local function bashcallback(a, b, c, wep, pain)
	if not IsValid(wep) then return end

	c:SetInflictor(wep)

	if c then
		c:SetDamageType(wep:GetStat("Secondary.BashDamageType"))
	end

	if IsValid(b.Entity) and b.Entity.TakeDamageInfo then
		local dmg = DamageInfo()
		dmg:SetAttacker(wep:GetOwner())
		dmg:SetInflictor(wep)
		dmg:SetDamagePosition(wep:GetOwner():GetShootPos())
		dmg:SetDamageForce(wep:GetOwner():GetAimVector() * 1) --(pain))
		dmg:SetDamage(pain)
		dmg:SetDamageType(DMG_SONIC)
		b.Entity:TakeDamageInfo(dmg)
		wep:BashForce(b.Entity, wep:GetOwner():GetAimVector() * math.sqrt(pain / 80) * 32 * 80, b.HitPos)
	end
end

function SWEP:HandleDoor(slashtrace)
	if CLIENT or not IsValid(slashtrace.Entity) then return end

	if slashtrace.Entity:GetClass() == "func_door_rotating" or slashtrace.Entity:GetClass() == "prop_door_rotating" then
		slashtrace.Entity:EmitSound("ambient/materials/door_hit1.wav", 100, math.random(80, 120))

		local newname = "TFABash" .. self:EntIndex()
		self.PreBashName = self:GetName()
		self:SetName(newname)

		slashtrace.Entity:SetKeyValue("Speed", "500")
		slashtrace.Entity:SetKeyValue("Open Direction", "Both directions")
		slashtrace.Entity:SetKeyValue("opendir", "0")
		slashtrace.Entity:Fire("unlock", "", .01)
		slashtrace.Entity:Fire("openawayfrom", newname, .01)

		timer.Simple(0.02, function()
			if not IsValid(self) or self:GetName() ~= newname then return end

			self:SetName(self.PreBashName)
		end)

		timer.Simple(0.3, function()
			if IsValid(slashtrace.Entity) then
				slashtrace.Entity:SetKeyValue("Speed", "100")
			end
		end)
	end
end

local l_CT = CurTime
local sp = game.SinglePlayer()

function SWEP:AltAttack()
	if self:GetStat("Secondary.CanBash") == false then return end
	if not self:OwnerIsValid() then return end
	if l_CT() < self:GetNextSecondaryFire() then return end
	local stat = self:GetStatus()
	if ( not TFA.Enum.ReadyStatus[stat] ) and not self.Secondary.BashInterrupt then return end
	if ( stat == TFA.Enum.STATUS_BASHING ) and self.Secondary.BashInterrupt then return end
	if self:IsSafety() then return end
	if self:GetHolding() then return end
	local enabled, act = self:ChooseBashAnim()

	if not enabled then return end

	if self:GetOwner().Vox then
		self:GetOwner():Vox("bash", 0)
	end
	self.unpredbash = true

	timer.Simple(0.1, function()
		if IsValid(self) then
			self.unpredbash = false
		end
	end)

	self:BashAnim()
	if sp and SERVER then self:CallOnClient("BashAnim","") end

	self.tmptoggle = not self.tmptoggle
	self:SetNextPrimaryFire(l_CT() + (self:GetStat("Secondary.BashEnd") or self:GetActivityLength(act, false) ) )
	self:SetNextSecondaryFire(l_CT() + (self:GetStat("Secondary.BashEnd") or self:GetActivityLength(act, true) ) )

	self:EmitSoundNet(self:GetStat("Secondary.BashSound"))

	self:SetStatus(TFA.Enum.STATUS_BASHING)
	self:SetStatusEnd( l_CT() + (self:GetStat("Secondary.BashEnd") or self:GetActivityLength(act, true) ) )

	self:SetNW2Float("BashTTime", l_CT() + self:GetStat("Secondary.BashDelay"))
end

function SWEP:BashAnim()
	--if IsValid(wep) and wep.GetHoldType then
	local ht = self.DefaultHoldType or self.HoldType
	local altanim = false

	if ht == "ar2" or ht == "shotgun" or ht == "crossbow" or ht == "physgun" then
		altanim = true
	end

	self:GetOwner():AnimRestartGesture(0, altanim and ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND or ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2, true)
end

local ttime = -1

function SWEP:Think2()
	ttime = self:GetNW2Float("BashTTime", -1)

	if ttime ~= -1 and l_CT() > ttime then
		self:SetNW2Float("BashTTime", -1)
		local pos = self:GetOwner():GetShootPos()
		local av = self:GetOwner():EyeAngles():Forward()
		local slash = {}
		slash.start = pos
		slash.endpos = pos + (av * self:GetStat("Secondary.BashLength"))
		slash.filter = self:GetOwner()
		slash.mins = Vector(-10, -5, 0)
		slash.maxs = Vector(10, 5, 5)
		local slashtrace = util.TraceHull(slash)
		local pain = self:GetStat("Secondary.BashDamage")

		
		if slashtrace.Hit then
			self:HandleDoor(slashtrace)
			if not ( sp and CLIENT ) then
				self:EmitSound((slashtrace.MatType == MAT_FLESH or slashtrace.MatType == MAT_ALIENFLESH) and self:GetStat("Secondary.BashHitSound_Flesh") or self:GetStat("Secondary.BashHitSound"))
			end

			if game.GetTimeScale() > 0.99 then
				self:GetOwner():FireBullets({
					Attacker = self:GetOwner(),
					Inflictor = self,
					Damage = 1,
					Force = 1, --pain,
					Distance = self:GetStat("Secondary.BashLength") + 10,
					HullSize = 10,
					Tracer = 0,
					Src = self:GetOwner():GetShootPos(),
					Dir = slashtrace.Normal,
					Callback = function(a, b, c)
						bashcallback(a, b, c, self, pain)
					end
				})
			else
				local dmg = DamageInfo()
				dmg:SetAttacker(self:GetOwner())
				dmg:SetInflictor(self)
				dmg:SetDamagePosition(self:GetOwner():GetShootPos())
				dmg:SetDamageForce(self:GetOwner():GetAimVector() * pain)
				dmg:SetDamage(pain)
				dmg:SetDamageType(DMG_SONIC)

				if IsValid(slashtrace.Entity) and slashtrace.Entity.TakeDamageInfo then
					slashtrace.Entity:TakeDamageInfo(dmg)
				end
			end

			local ent = slashtrace.Entity
			if not IsValid(ent) or not ent.GetPhysicsObject then return end
			local phys

			if ent:IsRagdoll() then
				phys = ent:GetPhysicsObjectNum(slashtrace.PhysicsBone or 0)
			else
				phys = ent:GetPhysicsObject()
			end

			if IsValid(phys) then
				if ent:IsPlayer() or ent:IsNPC() then
					ent:SetVelocity( self:GetOwner():GetAimVector() * self:GetStat("Secondary.BashDamage") * 0.5 )
					phys:SetVelocity(phys:GetVelocity() + self:GetOwner():GetAimVector() * self:GetStat("Secondary.BashDamage") * 0.5 )
				else
					phys:ApplyForceOffset(self:GetOwner():GetAimVector() * self:GetStat("Secondary.BashDamage") * 0.5, slashtrace.HitPos)
				end
			end
		end
	end

	BaseClass.Think2(self)
end

function SWEP:GetBashing()
	if not self:VMIV() or not IsValid(self.OwnerViewModel) then return false end

	local stat = self:GetStatus()

	return ((stat == TFA.Enum.STATUS_BASHING) and self.OwnerViewModel:GetCycle() > 0 and self.OwnerViewModel:GetCycle() < 0.65) or self.unpredbash
end







function SWEP:ChooseShootAnim()
	if not self:OwnerIsValid() then return end

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	--self:ResetEvents()
	local mybool = self:GetNW2Bool("Underhanded", false)
	local tanim = mybool and ACT_VM_SECONDARYATTACK or ACT_VM_THROW or ACT_VM_HAULBACK
	if not self.SequenceEnabled[ACT_VM_SECONDARYATTACK] then
		tanim = ACT_VM_THROW
	end
	local success = true
	self:SendViewModelAnim(tanim)

	if game.SinglePlayer() then
		self:CallOnClient("AnimForce", tanim)
	end

	self.lastact = tanim

	return success, tanim
end


function SWEP:Throw()
	local pOwner = self.Owner;
	if self:Clip1() > 0 then
		local bool = self:GetNW2Bool("Underhanded", false)
		local own = self:GetOwner()

		if not bool then
			self:ThrowGrenade( pOwner )
		elseif self.Owner:KeyDown( IN_DUCK ) and bool then
			self:RollGrenade( pOwner );
		else
			self:LobGrenade( pOwner );
		end
	end

	self:TakePrimaryAmmo(1)
	self:DoAmmoCheck()
end

-- NEW FUNCTIONS

// check a throw from vecSrc.  If not valid, move the position back along the line to vecEye
function SWEP:CheckThrowPosition( pPlayer, vecEye, vecSrc )

	local tr;

	tr = {}
	tr.start = vecEye
	tr.endpos = vecSrc
	tr.mins = -Vector(4.0+2,4.0+2,4.0+2)
	tr.maxs = Vector(4.0+2,4.0+2,4.0+2)
	tr.mask = MASK_PLAYERSOLID
	tr.filter = pPlayer
	tr.collision = pPlayer:GetCollisionGroup()
	local trace = util.TraceHull( tr );

	if ( trace.Hit ) then
		vecSrc = tr.endpos;
	end

	return vecSrc

end

function SWEP:ThrowGrenade( pPlayer )

if ( !CLIENT ) then
	local	vecEye = pPlayer:EyePos();
	local 	vecShoot = pPlayer:GetShootPos();
	local	vForward, vRight;

	vForward = pPlayer:EyeAngles():Forward();
	vRight = pPlayer:EyeAngles():Right();
	local vecSrc = vecEye + vForward * 18.0 + vRight * 8.0;
	vecSrc = self:CheckThrowPosition( pPlayer, vecEye, vecSrc );
//	vForward.x = vForward.x + 0.1;
//	vForward.y = vForward.y + 0.1;

	local vecThrow;
	vecThrow = pPlayer:GetVelocity();
	vecThrow = vecThrow + vForward * 1200;
	local pGrenade = ents.Create( self.Primary.Round );
	pGrenade:SetPos( vecSrc );
	pGrenade:SetAngles( Angle(0,0,0) );
	pGrenade:SetOwner( pPlayer );
	pGrenade:Fire( "SetTimer", GRENADE_TIMER );
	pGrenade:Spawn()
	pGrenade:GetPhysicsObject():SetVelocity( vecThrow );
	pGrenade:GetPhysicsObject():AddAngleVelocity( Vector(600,math.random(-1200,1200),0) );

	
	
	if ( pGrenade ) then
		if ( pPlayer && !pPlayer:Alive() ) then
			vecThrow = pPlayer:GetVelocity();

			local pPhysicsObject = pGrenade:GetPhysicsObject();
			if ( pPhysicsObject ) then
				vecThrow = pPhysicsObject:SetVelocity();
			end
		end

		pGrenade.m_flDamage = self.Primary.Damage;
		pGrenade.m_DmgRadius = GRENADE_DAMAGE_RADIUS;
	end
end
end

function SWEP:LobGrenade( pPlayer )

if ( !CLIENT ) then
	local	vecEye = pPlayer:EyePos();
	local	vForward, vRight;
	local vecShoot = pPlayer:GetShootPos()

	vForward = pPlayer:EyeAngles():Forward();
	vRight = pPlayer:EyeAngles():Right();
	local vecSrc = vecEye + vForward * 18.0 + vRight * 8.0 + Vector( 0, 0, -8 );
	vecSrc = self:CheckThrowPosition( pPlayer, vecEye, vecSrc );

	local vecThrow;
	vecThrow = pPlayer:GetVelocity();
	vecThrow = vecThrow + vForward * 350 + Vector( 0, 0, 50 );
	local pGrenade = ents.Create( self.Primary.Round );
	pGrenade:SetPos( vecSrc );
	pGrenade:SetAngles( Angle(0,0,0) );
	pGrenade:SetOwner( pPlayer );
	pGrenade:Spawn()
	pGrenade:GetPhysicsObject():SetVelocity( vecThrow );
	pGrenade:GetPhysicsObject():AddAngleVelocity( Vector(200,math.random(-600,600),0) );

	if ( pGrenade ) then
		pGrenade.m_flDamage = self.Primary.Damage;
		pGrenade.m_DmgRadius = GRENADE_DAMAGE_RADIUS;
	end
end
end

function SWEP:RollGrenade( pPlayer )

if ( !CLIENT ) then
	// BUGBUG: Hardcoded grenade width of 4 - better not change the model :)
	local vecSrc;
	vecSrc = pPlayer:GetPos();
	vecSrc.z = vecSrc.z + 4.0;

	local vecFacing = pPlayer:GetAimVector( );
	// no up/down direction
	vecFacing.z = 0;
	vecFacing = VectorNormalize( vecFacing );
	local tr;
	tr = {};
	tr.start = vecSrc;
	tr.endpos = vecSrc - Vector(0,0,16);
	tr.mask = MASK_PLAYERSOLID;
	tr.filter = pPlayer;
	tr.collision = COLLISION_GROUP_NONE;
	tr = util.TraceLine( tr );
	if ( tr.Fraction != 1.0 ) then
		// compute forward vec parallel to floor plane and roll grenade along that
		local tangent;
		tangent = CrossProduct( vecFacing, tr.HitNormal );
		vecFacing = CrossProduct( tr.HitNormal, tangent );
	end
	vecSrc = vecSrc + (vecFacing * 18.0);
	vecSrc = self:CheckThrowPosition( pPlayer, pPlayer:GetPos(), vecSrc );

	local vecThrow;
	vecThrow = pPlayer:GetVelocity();
	vecThrow = vecThrow + vecFacing * 700;
	// put it on its side
	local orientation = Angle(0,pPlayer:GetLocalAngles().y,-90);
	// roll it
	local rotSpeed = Vector(0,0,720);
	local pGrenade = ents.Create( self.Primary.Round );
	pGrenade:SetPos( vecSrc );
	pGrenade:SetAngles( orientation );
	pGrenade:SetOwner( pPlayer );
	pGrenade:Fire( "SetTimer", GRENADE_TIMER );
	pGrenade:Spawn();
	pGrenade:GetPhysicsObject():SetVelocity( vecThrow );
	pGrenade:GetPhysicsObject():AddAngleVelocity( rotSpeed );

	if ( pGrenade ) then
		pGrenade.m_flDamage = self.Primary.Damage;
		pGrenade.m_DmgRadius = GRENADE_DAMAGE_RADIUS;
	end

end

	// player "shoot" animation
	pPlayer:SetAnimation( PLAYER_ATTACK1 );

end