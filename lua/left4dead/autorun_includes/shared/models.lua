
local pairs = pairs
local table_insert = table.insert
local table_remove = table.remove
local string_gsub = string.gsub
local string_Explode = string.Explode

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
	"models/infected/l4d2_nb/uncommon_male_roadcrew.mdl",
	"models/infected/l4d2_nb/uncommon_male_roadcrew_l4d1.mdl",
	"models/infected/l4d2_nb/uncommon_male_fallen_survivor.mdl",
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
-- JSON RELATED
---------------------------------------------------------------------------------------------------------------------------------------------
--[[ Z_MaleModels =
{
	-- Cuba's Common Infected
	{ "models/infected/c_nb/common_male_police01.mdl", 20 },
	{ "models/infected/c_nb/common_male_military01.mdl", 20 },
	{ "models/infected/c_nb/common_male_worker01.mdl", 30 },
	{ "models/infected/c_nb/common_male_surgeon01.mdl", 20 },
	{ "models/infected/c_nb/common_male_patient01.mdl", 15 },
	{ "models/infected/c_nb/common_male01.mdl", 40 },
	{ "models/infected/c_nb/common_male02.mdl", 40 },
	{ "models/infected/c_nb/common_male_suit01.mdl", 30 },
	{ "models/infected/c_nb/common_male_rural01.mdl", 40 },
	{ "models/infected/c_nb/common_male_tsaagent01.mdl", 20 },
	{ "models/infected/c_nb/common_male_pilot01.mdl", 20 },
	{ "models/infected/c_nb/common_male_baggagehandler01.mdl", 25 },
	-- TRS Revision
	{ "models/infected/c_nb/trs_common_male_police01.mdl", 15 },
	{ "models/infected/c_nb/trs_common_male_military01.mdl", 15 },
	{ "models/infected/c_nb/trs_common_male_worker01.mdl", 15 },
	{ "models/infected/c_nb/trs_common_male_surgeon01.mdl", 10 },
	{ "models/infected/c_nb/trs_common_male_patient01.mdl", 5 },
	{ "models/infected/c_nb/trs_common_male01.mdl", 25 },
	{ "models/infected/c_nb/trs_common_male02.mdl", 25 },
	{ "models/infected/c_nb/trs_common_male_suit01.mdl", 20 },
	{ "models/infected/c_nb/trs_common_male_rural01.mdl", 20 },
	{ "models/infected/c_nb/trs_common_male_tsaagent01.mdl", 15 },
	{ "models/infected/c_nb/trs_common_male_pilot01.mdl", 15 },
	{ "models/infected/c_nb/trs_common_male_baggagehandler01.mdl", 15 },
	-- L4D2
	{ "models/infected/l4d2_nb/common_male_dressshirt_jeans.mdl", 40 },
	{ "models/infected/l4d2_nb/uncommon_male_ceda.mdl", 10 },

}
---------------------------------------------------------------------------------------------------------------------------------------------
Z_FemaleModels =
{
	-- Cuba's Common Infected
	{ "models/infected/c_nb/common_female01.mdl", 40 },
	{ "models/infected/c_nb/common_female_rural01.mdl", 30 },
	{ "models/infected/c_nb/common_female_nurse01.mdl", 20 },
	{ "models/infected/c_nb/common_female_suit01.mdl", 30 },
	-- TRS Revision
	{ "models/infected/c_nb/trs_common_female01.mdl", 35 },
	{ "models/infected/c_nb/trs_common_female_rural01.mdl", 25 },
	{ "models/infected/c_nb/trs_common_female_nurse01.mdl", 15 },
	{ "models/infected/c_nb/trs_common_female_suit01.mdl", 20 },
	-- L4D2
	{ "models/infected/l4d2_nb/common_female_tanktop_jeans.mdl", 35 },
	{ "models/infected/l4d2_nb/common_female_tshirt_skirt.mdl", 35 },
}

function InitJSONData()
	file.CreateDir( "l4d_nb" )

	-- Read the existing model data from the JSON file
	local readJSONData = file.Read( "l4d_nb/population.json", "DATA" )
	allModels = readJSONData and util.JSONToTable( readJSONData ) or {}

	-- Function to check if a model already exists in the data
	local function modelExists( modelName )
		for _, data in ipairs( allModels ) do
			if data.model == modelName then
				return true
			end
		end

		return false
	end

	-- Only add the models to the data if they don't already exist
	for _, model in ipairs( Z_MaleModels ) do
		if  !modelExists( model[ 1 ] ) then
			table_insert( allModels, { model = model[ 1 ], chance = model[ 2 ] } )
		end
	end

	for _, model in ipairs( Z_FemaleModels ) do
		if !modelExists( model[ 1 ] ) then
			table.insert( allModels, { model = model[ 1 ], chance = model[ 2 ] } )
		end
	end

	local JSONData = util.TableToJSON( allModels, true)
	file.Write( "l4d_nb/population.json", JSONData )
end

concommand.Add("l4d_dev_jsonrefresh", function(ply, cmd, args)
    if ply:IsAdmin() then -- Only allow admins to refresh the JSON data
        InitJSONData()
        print("JSON data refreshed!")
    else
        print("You must be an admin to use this command.")
    end
end)

InitJSONData()  ]]
---------------------------------------------------------------------------------------------------------------------------------------------
-- Spawnable props that get parented to the zombie model
Z_itemModels =
{
	nightstick = "models/weapons/melee/w_tonfa.mdl",
	bileJar = "models/w_models/weapons/w_eq_bile_flask.mdl",
	pocketPipe = "models/infected/l4d2_nb/cim_fallen_survivor_pocket01.mdl",
	pocketMol = "models/infected/l4d2_nb/cim_fallen_survivor_pocket02.mdl",
	pocketPills = "models/infected/l4d2_nb/cim_fallen_survivor_pocket03.mdl",

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
hook.Add( "Initialize"," Precache", function()
	timer.Simple( 3, function()
		PrecacheZombies()
	end)
end)