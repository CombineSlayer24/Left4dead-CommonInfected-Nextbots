
local pairs = pairs
local table_insert = table.insert
local table_remove = table.remove
local string_gsub = string.gsub
local string_Explode = string.Explode

---------------------------------------------------------------------------------------------------------------------------------------------
Z_MaleModels =
{
	-- Cuba's Common Infected --

	-- L4D1 --
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

	-- L4D2 --

	-- Males
	"models/infected/l4d2_nb/common_male_dressshirt_jeans.mdl",
	"models/infected/l4d2_nb/common_male_tshirt_cargos.mdl",
	"models/infected/l4d2_nb/common_male_tanktop_overalls.mdl",
	"models/infected/l4d2_nb/common_male_tanktop_jeans.mdl",
	"models/infected/l4d2_nb/common_male_polo_jeans.mdl",
	"models/infected/l4d2_nb/common_male_formal.mdl",
	"models/infected/l4d2_nb/common_male_biker.mdl",
	"models/infected/l4d2_nb/common_male_shadertest.mdl",

	-- Swamp
	"models/infected/l4d2_nb/common_male_tanktop_overalls_swamp.mdl",

	-- Uncommon
	"models/infected/l4d2_nb/uncommon_male_jimmy.mdl",
	"models/infected/l4d2_nb/uncommon_male_mud.mdl",
	"models/infected/l4d2_nb/uncommon_male_ceda.mdl",
	"models/infected/l4d2_nb/uncommon_male_roadcrew.mdl",
	"models/infected/l4d2_nb/uncommon_male_fallen_survivor.mdl",
	"models/infected/l4d2_nb/uncommon_male_parachutist.mdl",
	"models/infected/l4d2_nb/uncommon_male_riot.mdl",
	"models/infected/l4d2_nb/uncommon_male_riot_l4d1.mdl",
	"models/infected/l4d2_nb/uncommon_male_clown.mdl",
	
	-- Uncommon L4D1
	"models/infected/l4d2_nb/uncommon_male_ceda_l4d1.mdl",
	"models/infected/l4d2_nb/uncommon_male_roadcrew_l4d1.mdl",
	"models/infected/l4d2_nb/uncommon_male_baggagehandler02.mdl",
	"models/infected/l4d2_nb/uncommon_male_fallen_survivor_l4d1.mdl",
	"models/infected/l4d2_nb/common_male_mud_l4d1.mdl",
}
---------------------------------------------------------------------------------------------------------------------------------------------
Z_FemaleModels =
{
	-- Cuba's Common Infected --
	
	-- L4D1 --
	"models/infected/c_nb/common_female01.mdl",
	"models/infected/c_nb/common_female_rural01.mdl",
	"models/infected/c_nb/common_female_nurse01.mdl",
	"models/infected/c_nb/common_female_suit01.mdl",
	-- TRS Revision
	"models/infected/c_nb/trs_common_female01.mdl",
	"models/infected/c_nb/trs_common_female_rural01.mdl",
	"models/infected/c_nb/trs_common_female_nurse01.mdl",
	"models/infected/c_nb/trs_common_female_suit01.mdl",

	-- L4D2 --
	-- Females
	"models/infected/l4d2_nb/common_female_tanktop_jeans.mdl",
	"models/infected/l4d2_nb/common_female_tshirt_skirt.mdl",
	"models/infected/l4d2_nb/common_female_formal.mdl",

	-- Uncommon
	"models/infected/l4d2_nb/uncommon_female_riot.mdl",
	"models/infected/l4d2_nb/uncommon_female_ceda.mdl",

	-- Uncommon l4d1
	"models/infected/l4d2_nb/uncommon_female_riot_l4d1.mdl",
	"models/infected/l4d2_nb/uncommon_female_ceda_l4d1.mdl",
}

Z_UnCommonModels = {
	CEDA = {
		"models/infected/l4d2_nb/uncommon_male_ceda.mdl",
		"models/infected/l4d2_nb/uncommon_male_ceda_l4d1.mdl",
		"models/infected/l4d2_nb/uncommon_female_ceda.mdl",
		"models/infected/l4d2_nb/uncommon_female_ceda_l4d1.mdl",
	},
	ROADCREW = { 
		"models/infected/l4d2_nb/uncommon_male_roadcrew.mdl", 
		"models/infected/l4d2_nb/uncommon_male_roadcrew_l4d1.mdl", 
		"models/infected/l4d2_nb/uncommon_male_baggagehandler02.mdl" 
	},
	FALLEN = { 
		"models/infected/l4d2_nb/uncommon_male_fallen_survivor.mdl",
		"models/infected/l4d2_nb/uncommon_male_fallen_survivor_l4d1.mdl",
		"models/infected/l4d2_nb/uncommon_male_parachutist.mdl",
 	},
	RIOT = { 
		"models/infected/l4d2_nb/uncommon_male_riot.mdl",
		"models/infected/l4d2_nb/uncommon_male_riot_l4d1.mdl",
		"models/infected/l4d2_nb/uncommon_female_riot.mdl",
		"models/infected/l4d2_nb/uncommon_female_riot_l4d1.mdl",
	},
	JIMMYGIBBS = { "models/infected/l4d2_nb/uncommon_male_jimmy.mdl" },
	MUDMEN = { "models/infected/l4d2_nb/uncommon_male_mud.mdl" },
	CLOWN = { "models/infected/l4d2_nb/uncommon_male_clown.mdl" },
}
---------------------------------------------------------------------------------------------------------------------------------------------
-- Spawnable props that get parented to the zombie model
Z_itemModels =
{
	nightstick = "models/weapons/melee/w_tonfa.mdl",
	bileJar = "models/w_models/weapons/w_eq_bile_flask.mdl",
	pocketPipe = "models/infected/l4d2_nb/cim_fallen_survivor_pocket01.mdl",
	pocketMol = "models/infected/l4d2_nb/cim_fallen_survivor_pocket02.mdl",
	pocketPills = "models/infected/l4d2_nb/cim_fallen_survivor_pocket03.mdl",

	molotov = "models/w_models/weapons/w_eq_molotov.mdl",
	pipeBomb = "models/w_models/weapons/w_eq_pipebomb.mdl",

	--Should we makes this into Entities so the players can heal from them?
	healthKit = "models/w_models/weapons/w_eq_medkit.mdl",
	painPills = "models/w_models/weapons/w_eq_painpills.mdl",
	-- Add more items here as needed
}

local anims = {
	"models/infected/anim_boomer.mdl",
	"models/infected/anim_hunter.mdl",
	"models/infected/anim_smoker.mdl",
	"models/infected/anim_jockey.mdl",
	"models/infected/anim_spitter.mdl",
	"models/infected/anim_charger.mdl",
	"models/infected/anim_hulk.mdl",
	"models/infected/anim_witch.mdl",
	"models/infected/anim_common.mdl",
	"models/infected/anim_common_female.mdl",
	"models/infected/anim_common_female_exp.mdl",
	"models/infected/anim_common_male_exp.mdl",
	"models/infected/anim_common_vomit.mdl",
}
---------------------------------------------------------------------------------------------------------------------------------------------
function PrecacheAssets()
 	local assets = { Z_FemaleModels, Z_MaleModels, Z_itemModels, Z_UnCommonModels, anims }
	for _, modelList in ipairs( assets ) do
		for _, model in ipairs( modelList ) do
			util.PrecacheModel( model )
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
--[[ hook.Add( "Initialize"," Precache", function()
	timer.Simple( 3, function()
		PrecacheAssets()
	end)
end)
]]

-- This will be used for when we want to find specific animation events and other animations
-- Mainly for specials and commons and whatever.
--[[ if CLIENT then
	local modelPath = ""

	local modelEntity = ClientsideModel(modelPath, RENDERGROUP_OPAQUE)
	modelEntity:Spawn()
	modelEntity:SetNoDraw(true)
	
	local sequenceCount = modelEntity:GetSequenceCount()
	
	print("Animations of model: " .. modelPath)
	for sequence = 0, sequenceCount - 1 do
		print("Animation ID " .. sequence .. ": " .. modelEntity:GetSequenceName(sequence))
	end
	modelEntity:Remove()
end ]]
