---------------------------------------------------------------------------------------------------------------------------------------------
local ipairs = ipairs
local string_StartWith = string.StartWith
local file_Find = file.Find
local table_Empty = table.Empty
local table_insert = table.insert
---------------------------------------------------------------------------------------------------------------------------------------------
_Z_Walking_Footsteps = 
{
	[MAT_ANTLION] = {"left4dead/footsteps/walk/flesh1.wav","left4dead/footsteps/walk/flesh2.wav","left4dead/footsteps/walk/flesh3.wav","left4dead/footsteps/walk/flesh4.wav"},
	[MAT_BLOODYFLESH] = {"left4dead/footsteps/walk/flesh1.wav","left4dead/footsteps/walk/flesh2.wav","left4dead/footsteps/walk/flesh3.wav","left4dead/footsteps/walk/flesh4.wav"},
	[MAT_CONCRETE] = {"left4dead/footsteps/walk/concrete1.wav","left4dead/footsteps/walk/concrete2.wav","left4dead/footsteps/walk/concrete3.wav","left4dead/footsteps/walk/concrete4.wav"},
	[MAT_DIRT] = {"left4dead/footsteps/walk/concrete1.wav","left4dead/footsteps/walk/concrete2.wav","left4dead/footsteps/walk/concrete3.wav","left4dead/footsteps/walk/concrete4.wav"},
	[MAT_FLESH] = {"left4dead/footsteps/walk/flesh1.wav","left4dead/footsteps/walk/flesh2.wav","left4dead/footsteps/walk/flesh3.wav","left4dead/footsteps/walk/flesh4.wav"},
	[MAT_GRATE] = {"left4dead/footsteps/walk/metalgrate1.wav","left4dead/footsteps/walk/metalgrate2.wav","left4dead/footsteps/walk/metalgrate3.wav","left4dead/footsteps/walk/metalgrate3.wav","left4dead/footsteps/walk/metal1.wav","left4dead/footsteps/walk/metal2.wav","left4dead/footsteps/walk/metal3.wav","left4dead/footsteps/walk/metal4.wav"},
	[MAT_ALIENFLESH] = {"left4dead/footsteps/walk/flesh1.wav","left4dead/footsteps/walk/flesh2.wav","left4dead/footsteps/walk/flesh3.wav","left4dead/footsteps/walk/flesh4.wav"},
	[MAT_SNOW] = {"left4dead/footsteps/walk/sand1.wav","left4dead/footsteps/walk/sand2.wav","left4dead/footsteps/walk/sand3.wav","left4dead/footsteps/walk/sand4.wav","left4dead/footsteps/walk/grass1.wav","left4dead/footsteps/walk/grass2.wav","left4dead/footsteps/walk/grass3.wav","left4dead/footsteps/walk/grass4.wav"},
	[MAT_PLASTIC] = {"left4dead/footsteps/walk/concrete1.wav","left4dead/footsteps/walk/concrete2.wav","left4dead/footsteps/walk/concrete3.wav","left4dead/footsteps/walk/concrete4.wav"},
	[MAT_METAL] = {"left4dead/footsteps/walk/metal1.wav","left4dead/footsteps/walk/metal2.wav","left4dead/footsteps/walk/metal3.wav","left4dead/footsteps/walk/metal4.wav"},
	[MAT_SAND] = {"left4dead/footsteps/walk/sand1.wav","left4dead/footsteps/walk/sand2.wav","left4dead/footsteps/walk/sand3.wav","left4dead/footsteps/walk/sand4.wav"},
	[MAT_FOLIAGE] = {"left4dead/footsteps/walk/grass1.wav","left4dead/footsteps/walk/grass2.wav","left4dead/footsteps/walk/grass3.wav","left4dead/footsteps/walk/grass4.wav","left4dead/footsteps/walk/gravel1.wav","left4dead/footsteps/walk/gravel2.wav","left4dead/footsteps/walk/gravel3.wav","left4dead/footsteps/walk/gravel4.wav"},
	[MAT_COMPUTER] = {"left4dead/footsteps/walk/concrete1.wav","left4dead/footsteps/walk/concrete2.wav","left4dead/footsteps/walk/concrete3.wav","left4dead/footsteps/walk/concrete4.wav"},
	[MAT_SLOSH] = {"left4dead/footsteps/walk/mud1.wav","left4dead/footsteps/walk/mud2.wav","left4dead/footsteps/walk/mud3.wav","left4dead/footsteps/walk/mud4.wav"},
	[MAT_TILE] = {"left4dead/footsteps/walk/tile1.wav","left4dead/footsteps/walk/tile2.wav","left4dead/footsteps/walk/tile3.wav","left4dead/footsteps/walk/tile4.wav"},
	[MAT_GRASS] = {"left4dead/footsteps/walk/grass1.wav","left4dead/footsteps/walk/grass2.wav","left4dead/footsteps/walk/grass3.wav","left4dead/footsteps/walk/grass4.wav"},
	[MAT_VENT] = {"left4dead/footsteps/walk/metal1.wav","left4dead/footsteps/walk/metal2.wav","left4dead/footsteps/walk/metal3.wav","left4dead/footsteps/walk/metal4.wav"},
	[MAT_WOOD] = {"left4dead/footsteps/walk/wood1.wav","left4dead/footsteps/walk/wood2.wav","left4dead/footsteps/walk/wood3.wav","left4dead/footsteps/walk/wood4.wav"},
	[MAT_GLASS] = {"left4dead/footsteps/walk/glass1.wav","left4dead/footsteps/walk/glass2.wav","left4dead/footsteps/walk/glass3.wav","left4dead/footsteps/walk/glass4.wav"}
}
---------------------------------------------------------------------------------------------------------------------------------------------
_Z_Running_Footsteps = 
{
	[MAT_ANTLION] = {"left4dead/footsteps/run/flesh1.wav","left4dead/footsteps/run/flesh2.wav","left4dead/footsteps/run/flesh3.wav","left4dead/footsteps/run/flesh4.wav"},
	[MAT_BLOODYFLESH] = {"left4dead/footsteps/run/flesh1.wav","left4dead/footsteps/run/flesh2.wav","left4dead/footsteps/run/flesh3.wav","left4dead/footsteps/run/flesh4.wav"},
	[MAT_CONCRETE] = {"left4dead/footsteps/run/concrete1.wav","left4dead/footsteps/run/concrete2.wav","left4dead/footsteps/run/concrete3.wav","left4dead/footsteps/run/concrete4.wav"},
	[MAT_DIRT] = {"left4dead/footsteps/run/concrete1.wav","left4dead/footsteps/run/concrete2.wav","left4dead/footsteps/run/concrete3.wav","left4dead/footsteps/run/concrete4.wav"},
	[MAT_FLESH] = {"left4dead/footsteps/run/flesh1.wav","left4dead/footsteps/run/flesh2.wav","left4dead/footsteps/run/flesh3.wav","left4dead/footsteps/run/flesh4.wav"},
	[MAT_GRATE] = {"left4dead/footsteps/run/metalgrate1.wav","left4dead/footsteps/run/metalgrate2.wav","left4dead/footsteps/run/metalgrate3.wav","left4dead/footsteps/run/metalgrate3.wav","left4dead/footsteps/run/metal1.wav","left4dead/footsteps/run/metal2.wav","left4dead/footsteps/run/metal3.wav","left4dead/footsteps/run/metal4.wav"},
	[MAT_ALIENFLESH] = {"left4dead/footsteps/run/flesh1.wav","left4dead/footsteps/run/flesh2.wav","left4dead/footsteps/run/flesh3.wav","left4dead/footsteps/run/flesh4.wav"},
	[MAT_SNOW] = {"left4dead/footsteps/run/sand1.wav","left4dead/footsteps/run/sand2.wav","left4dead/footsteps/run/sand3.wav","left4dead/footsteps/run/sand4.wav","left4dead/footsteps/run/grass1.wav","left4dead/footsteps/run/grass2.wav","left4dead/footsteps/run/grass3.wav","left4dead/footsteps/run/grass4.wav"},
	[MAT_PLASTIC] = {"left4dead/footsteps/run/concrete1.wav","left4dead/footsteps/run/concrete2.wav","left4dead/footsteps/run/concrete3.wav","left4dead/footsteps/run/concrete4.wav"},
	[MAT_METAL] = {"left4dead/footsteps/run/metal1.wav","left4dead/footsteps/run/metal2.wav","left4dead/footsteps/run/metal3.wav","left4dead/footsteps/run/metal4.wav"},
	[MAT_SAND] = {"left4dead/footsteps/run/sand1.wav","left4dead/footsteps/run/sand2.wav","left4dead/footsteps/run/sand3.wav","left4dead/footsteps/run/sand4.wav"},
	[MAT_FOLIAGE] = {"left4dead/footsteps/run/grass1.wav","left4dead/footsteps/run/grass2.wav","left4dead/footsteps/run/grass3.wav","left4dead/footsteps/run/grass4.wav","left4dead/footsteps/run/gravel1.wav","left4dead/footsteps/run/gravel2.wav","left4dead/footsteps/run/gravel3.wav","left4dead/footsteps/run/gravel4.wav"},
	[MAT_COMPUTER] = {"left4dead/footsteps/run/concrete1.wav","left4dead/footsteps/run/concrete2.wav","left4dead/footsteps/run/concrete3.wav","left4dead/footsteps/run/concrete4.wav"},
	[MAT_SLOSH] = {"left4dead/footsteps/run/mud1.wav","left4dead/footsteps/run/mud2.wav","left4dead/footsteps/run/mud3.wav","left4dead/footsteps/run/mud4.wav"},
	[MAT_TILE] = {"left4dead/footsteps/run/tile1.wav","left4dead/footsteps/run/tile2.wav","left4dead/footsteps/run/tile3.wav","left4dead/footsteps/run/tile4.wav"},
	[MAT_GRASS] = {"left4dead/footsteps/run/grass1.wav","left4dead/footsteps/run/grass2.wav","left4dead/footsteps/run/grass3.wav","left4dead/footsteps/run/grass4.wav"},
	[MAT_VENT] = {"left4dead/footsteps/run/metal1.wav","left4dead/footsteps/run/metal2.wav","left4dead/footsteps/run/metal3.wav","left4dead/footsteps/run/metal4.wav"},
	[MAT_WOOD] = {"left4dead/footsteps/run/wood1.wav","left4dead/footsteps/run/wood2.wav","left4dead/footsteps/run/wood3.wav","left4dead/footsteps/run/wood4.wav"},
	[MAT_GLASS] = {"left4dead/footsteps/run/glass1.wav","left4dead/footsteps/run/glass2.wav","left4dead/footsteps/run/glass3.wav","left4dead/footsteps/run/glass4.wav"}
}
---------------------------------------------------------------------------------------------------------------------------------------------
local unusedAngle = Angle( 0, 0, 0 )
local b_EyebrowC = "ValveBiped.Exp_EyebrowsCorner"
local b_Eyebrows = "ValveBiped.Exp_Eyebrows"
local b_LipsUpper = "ValveBiped.Exp_LipsUpper"
local b_EyelidUpper = "ValveBiped.Exp_Eyelids_Upper"
local b_EyelidLower = "ValveBiped.Exp_Eyelids_Lower"
local b_Jaw = "ValveBiped.Exp_Jaw"
---------------------------------------------------------------------------------------------------------------------------------------------
_DeathExpressions = 
{
	Death01 =
	{
		{ boneName = b_EyebrowC, positionOffset = Vector( -0.8, 0, 0 ), angleOffset = unusedAngle },
		{ boneName = b_Eyebrows, positionOffset = Vector( 1.2, 0, 0 ), angleOffset = unusedAngle },
		{ boneName = b_LipsUpper, positionOffset = Vector( -0.2, 0, 0 ), angleOffset = unusedAngle },
	},
	Death02 =
	{
		{ boneName = b_EyelidUpper, positionOffset = Vector( -0.65, 0, 0 ), angleOffset = unusedAngle },
		{ boneName = b_Eyebrows, positionOffset = Vector( 0.7, 0, 0 ), angleOffset = unusedAngle },
	},
	Death03 =
	{
		{ boneName = b_EyelidUpper, positionOffset = Vector( -0.3, 0, 0 ), angleOffset = unusedAngle },
		{ boneName = b_Eyebrows, positionOffset = Vector( 1.2, 0, 0 ), angleOffset = unusedAngle },
		{ boneName = b_Jaw, positionOffset = Vector( -0.3, 0, 0 ), angleOffset = unusedAngle },
	},
	Death04 =
	{
		{ boneName = b_EyelidUpper, positionOffset = Vector( -0.8, 0, 0 ), angleOffset = unusedAngle },
		{ boneName = b_Eyebrows, positionOffset = Vector( -0.6, 0, 0 ), angleOffset = unusedAngle },
		{ boneName = b_Jaw, positionOffset = Vector( 0.05, 0, 0 ), angleOffset = unusedAngle },
	},
	Death05 =
	{
		{ boneName = b_EyelidUpper, positionOffset = Vector( -0.3, 0, 0 ), angleOffset = unusedAngle },
		{ boneName = b_Eyebrows, positionOffset = Vector( 1.5, 0, 0 ), angleOffset = unusedAngle },
		{ boneName = b_Jaw, positionOffset = Vector( -0.01, 0, 0 ), angleOffset = unusedAngle },
		{ boneName = b_LipsUpper, positionOffset = Vector( 0.1, 0, 0 ), angleOffset = unusedAngle },
	},
	Death06 =
	{
		{ boneName = b_EyebrowC, positionOffset = Vector( -0.8, 0, 0 ), angleOffset = unusedAngle },
		{ boneName = b_Eyebrows, positionOffset = Vector( 1.2, 0, 0 ), angleOffset = unusedAngle },
		{ boneName = b_EyelidUpper, positionOffset = Vector( -0.2, 0, 0 ), angleOffset = unusedAngle },
		{ boneName = b_EyelidLower, positionOffset = Vector( 0.2, 0, 0 ), angleOffset = unusedAngle },
		{ boneName = b_LipsUpper, positionOffset = Vector( -0.12, 0, 0 ), angleOffset = unusedAngle },
		{ boneName = b_Jaw, positionOffset = Vector( -0.36, 0, 0 ), angleOffset = unusedAngle },
	},
}
---------------------------------------------------------------------------------------------------------------------------------------------