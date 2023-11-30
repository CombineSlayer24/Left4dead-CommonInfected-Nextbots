---------------------------------------------------------------------------------------------------------------------------------------------
Z_MaleModels = 
{
	-- Cuba's Common Infected
	"models/infected/c_nb/common_male_police01.mdl",
	"models/infected/c_nb/common_male_tsaagent01.mdl",
	"models/infected/c_nb/common_male_worker01.mdl",
	"models/infected/c_nb/common_male_surgeon01.mdl",
	"models/infected/c_nb/common_male_patient01.mdl",
	"models/infected/c_nb/common_male_military01.mdl",
	"models/infected/c_nb/common_male01.mdl",
	"models/infected/c_nb/common_male02.mdl",
	"models/infected/c_nb/common_male_suit01.mdl",
	"models/infected/c_nb/common_male_rural01.mdl",
	"models/infected/c_nb/common_male_pilot01.mdl",
	"models/infected/c_nb/common_male_baggagehandler01.mdl",
	-- TRS Revision
	"models/infected/c_nb/trs_common_male_police01.mdl",
	"models/infected/c_nb/trs_common_male_tsaagent01.mdl",
	"models/infected/c_nb/trs_common_male_worker01.mdl",
	"models/infected/c_nb/trs_common_male_surgeon01.mdl",
	"models/infected/c_nb/trs_common_male_patient01.mdl",
	"models/infected/c_nb/trs_common_male_military01.mdl",
	"models/infected/c_nb/trs_common_male01.mdl",
	"models/infected/c_nb/trs_common_male02.mdl",
	"models/infected/c_nb/trs_common_male_suit01.mdl",
	"models/infected/c_nb/trs_common_male_rural01.mdl",
	"models/infected/c_nb/trs_common_male_pilot01.mdl",
	"models/infected/c_nb/trs_common_male_baggagehandler01.mdl",
	
	-- L4D2
	"models/infected/l4d2_nb/common_male_dressshirt_jeans.mdl",
	"models/infected/l4d2_nb/uncommon_male_ceda.mdl",
}
---------------------------------------------------------------------------------------------------------------------------------------------
Z_FemaleModels = 
{
	-- Cuba's Common Infected
	"models/infected/c_nb/common_female01.mdl",
	"models/infected/c_nb/common_female_rural01.mdl",
	"models/infected/c_nb/common_female_nurse01.mdl",
	"models/infected/c_nb/common_female_suit01.mdl",
	-- TRS Revision
	"models/infected/c_nb/trs_common_female01.mdl",
	"models/infected/c_nb/trs_common_female_rural01.mdl",
	"models/infected/c_nb/trs_common_female_nurse01.mdl",
	"models/infected/c_nb/trs_common_female_suit01.mdl",

	-- L4D2
	"models/infected/l4d2_nb/common_female_tanktop_jeans.mdl",
	"models/infected/l4d2_nb/common_female_tshirt_skirt.mdl",
}
---------------------------------------------------------------------------------------------------------------------------------------------
-- Spawnable props that get parented to the zombie model
Z_itemModels =
{
	nightstick = "models/weapons/melee/w_tonfa.mdl",
	bileJar = "models/w_models/weapons/w_eq_bile_flask.mdl",

	-- Should these give Grenade ammo to player?
	molotov = "models/w_models/weapons/w_eq_molotov.mdl",
	pipeBomb = "models/w_models/weapons/w_eq_pipebomb.mdl",

	--Should we makes this into Entities so the players can heal from them?
	healthKit = "models/w_models/weapons/w_eq_medkit.mdl",
	painPills = "models/w_models/weapons/w_eq_painpills.mdl",
	-- Add more items here as needed
}
---------------------------------------------------------------------------------------------------------------------------------------------
function PrecacheZombies()
	for k, v in ipairs( Z_MaleModels ) do
		util.PrecacheModel( v )
	end

	for k, v in ipairs( Z_FemaleModels ) do
		util.PrecacheModel( v )
	end

	for k, v in ipairs( Z_itemModels ) do
		util.PrecacheModel( v )
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( "PostGamemodeLoaded", "z_precache", PrecacheZombies )