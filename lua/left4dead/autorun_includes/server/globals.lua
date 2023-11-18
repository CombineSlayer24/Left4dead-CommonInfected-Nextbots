---------------------------------------------------------------------------------------------------------------------------------------------
local ipairs = ipairs
local string_StartWith = string.StartWith
local file_Find = file.Find
local table_Empty = table.Empty
local table_insert = table.insert
---------------------------------------------------------------------------------------------------------------------------------------------
_Z_Walking_Footsteps = 
{
	[MAT_ANTLION] = {"left4dead/player/footsteps/infected/walk/flesh1.mp3","left4dead/player/footsteps/infected/walk/flesh2.mp3","left4dead/player/footsteps/infected/walk/flesh3.mp3","left4dead/player/footsteps/infected/walk/flesh4.mp3"},
	[MAT_BLOODYFLESH] = {"left4dead/player/footsteps/infected/walk/flesh1.mp3","left4dead/player/footsteps/infected/walk/flesh2.mp3","left4dead/player/footsteps/infected/walk/flesh3.mp3","left4dead/player/footsteps/infected/walk/flesh4.mp3"},
	[MAT_CONCRETE] = {"left4dead/player/footsteps/infected/walk/concrete1.mp3","left4dead/player/footsteps/infected/walk/concrete2.mp3","left4dead/player/footsteps/infected/walk/concrete3.mp3","left4dead/player/footsteps/infected/walk/concrete4.mp3"},
	[MAT_DIRT] = {"left4dead/player/footsteps/infected/walk/concrete1.mp3","left4dead/player/footsteps/infected/walk/concrete2.mp3","left4dead/player/footsteps/infected/walk/concrete3.mp3","left4dead/player/footsteps/infected/walk/concrete4.mp3"},
	[MAT_FLESH] = {"left4dead/player/footsteps/infected/walk/flesh1.mp3","left4dead/player/footsteps/infected/walk/flesh2.mp3","left4dead/player/footsteps/infected/walk/flesh3.mp3","left4dead/player/footsteps/infected/walk/flesh4.mp3"},
	[MAT_GRATE] = {"left4dead/player/footsteps/infected/walk/metalgrate1.mp3","left4dead/player/footsteps/infected/walk/metalgrate2.mp3","left4dead/player/footsteps/infected/walk/metalgrate3.mp3","left4dead/player/footsteps/infected/walk/metalgrate3.mp3","left4dead/player/footsteps/infected/walk/metal1.mp3","left4dead/player/footsteps/infected/walk/metal2.mp3","left4dead/player/footsteps/infected/walk/metal3.mp3","left4dead/player/footsteps/infected/walk/metal4.mp3"},
	[MAT_ALIENFLESH] = {"left4dead/player/footsteps/infected/walk/flesh1.mp3","left4dead/player/footsteps/infected/walk/flesh2.mp3","left4dead/player/footsteps/infected/walk/flesh3.mp3","left4dead/player/footsteps/infected/walk/flesh4.mp3"},
	[MAT_SNOW] = {"left4dead/player/footsteps/infected/walk/sand1.mp3","left4dead/player/footsteps/infected/walk/sand2.mp3","left4dead/player/footsteps/infected/walk/sand3.mp3","left4dead/player/footsteps/infected/walk/sand4.mp3","left4dead/player/footsteps/infected/walk/grass1.mp3","left4dead/player/footsteps/infected/walk/grass2.mp3","left4dead/player/footsteps/infected/walk/grass3.mp3","left4dead/player/footsteps/infected/walk/grass4.mp3"},
	[MAT_PLASTIC] = {"left4dead/player/footsteps/infected/walk/concrete1.mp3","left4dead/player/footsteps/infected/walk/concrete2.mp3","left4dead/player/footsteps/infected/walk/concrete3.mp3","left4dead/player/footsteps/infected/walk/concrete4.mp3"},
	[MAT_METAL] = {"left4dead/player/footsteps/infected/walk/metal1.mp3","left4dead/player/footsteps/infected/walk/metal2.mp3","left4dead/player/footsteps/infected/walk/metal3.mp3","left4dead/player/footsteps/infected/walk/metal4.mp3"},
	[MAT_SAND] = {"left4dead/player/footsteps/infected/walk/sand1.mp3","left4dead/player/footsteps/infected/walk/sand2.mp3","left4dead/player/footsteps/infected/walk/sand3.mp3","left4dead/player/footsteps/infected/walk/sand4.mp3"},
	[MAT_FOLIAGE] = {"left4dead/player/footsteps/infected/walk/grass1.mp3","left4dead/player/footsteps/infected/walk/grass2.mp3","left4dead/player/footsteps/infected/walk/grass3.mp3","left4dead/player/footsteps/infected/walk/grass4.mp3","left4dead/player/footsteps/infected/walk/gravel1.mp3","left4dead/player/footsteps/infected/walk/gravel2.mp3","left4dead/player/footsteps/infected/walk/gravel3.mp3","left4dead/player/footsteps/infected/walk/gravel4.mp3"},
	[MAT_COMPUTER] = {"left4dead/player/footsteps/infected/walk/concrete1.mp3","left4dead/player/footsteps/infected/walk/concrete2.mp3","left4dead/player/footsteps/infected/walk/concrete3.mp3","left4dead/player/footsteps/infected/walk/concrete4.mp3"},
	[MAT_SLOSH] = {"left4dead/player/footsteps/infected/walk/mud1.mp3","left4dead/player/footsteps/infected/walk/mud2.mp3","left4dead/player/footsteps/infected/walk/mud3.mp3","left4dead/player/footsteps/infected/walk/mud4.mp3"},
	[MAT_TILE] = {"left4dead/player/footsteps/infected/walk/tile1.mp3","left4dead/player/footsteps/infected/walk/tile2.mp3","left4dead/player/footsteps/infected/walk/tile3.mp3","left4dead/player/footsteps/infected/walk/tile4.mp3"},
	[MAT_GRASS] = {"left4dead/player/footsteps/infected/walk/grass1.mp3","left4dead/player/footsteps/infected/walk/grass2.mp3","left4dead/player/footsteps/infected/walk/grass3.mp3","left4dead/player/footsteps/infected/walk/grass4.mp3"},
	[MAT_VENT] = {"left4dead/player/footsteps/infected/walk/metal1.mp3","left4dead/player/footsteps/infected/walk/metal2.mp3","left4dead/player/footsteps/infected/walk/metal3.mp3","left4dead/player/footsteps/infected/walk/metal4.mp3"},
	[MAT_WOOD] = {"left4dead/player/footsteps/infected/walk/wood1.mp3","left4dead/player/footsteps/infected/walk/wood2.mp3","left4dead/player/footsteps/infected/walk/wood3.mp3","left4dead/player/footsteps/infected/walk/wood4.mp3"},
	[MAT_GLASS] = {"left4dead/player/footsteps/infected/walk/glass1.mp3","left4dead/player/footsteps/infected/walk/glass2.mp3","left4dead/player/footsteps/infected/walk/glass3.mp3","left4dead/player/footsteps/infected/walk/glass4.mp3"}
}
---------------------------------------------------------------------------------------------------------------------------------------------
_Z_Running_Footsteps = 
{
	[MAT_ANTLION] = {"left4dead/player/footsteps/infected/run/flesh1.mp3","left4dead/player/footsteps/infected/run/flesh2.mp3","left4dead/player/footsteps/infected/run/flesh3.mp3","left4dead/player/footsteps/infected/run/flesh4.mp3"},
	[MAT_BLOODYFLESH] = {"left4dead/player/footsteps/infected/run/flesh1.mp3","left4dead/player/footsteps/infected/run/flesh2.mp3","left4dead/player/footsteps/infected/run/flesh3.mp3","left4dead/player/footsteps/infected/run/flesh4.mp3"},
	[MAT_CONCRETE] = {"left4dead/player/footsteps/infected/run/concrete1.mp3","left4dead/player/footsteps/infected/run/concrete2.mp3","left4dead/player/footsteps/infected/run/concrete3.mp3","left4dead/player/footsteps/infected/run/concrete4.mp3"},
	[MAT_DIRT] = {"left4dead/player/footsteps/infected/run/concrete1.mp3","left4dead/player/footsteps/infected/run/concrete2.mp3","left4dead/player/footsteps/infected/run/concrete3.mp3","left4dead/player/footsteps/infected/run/concrete4.mp3"},
	[MAT_FLESH] = {"left4dead/player/footsteps/infected/run/flesh1.mp3","left4dead/player/footsteps/infected/run/flesh2.mp3","left4dead/player/footsteps/infected/run/flesh3.mp3","left4dead/player/footsteps/infected/run/flesh4.mp3"},
	[MAT_GRATE] = {"left4dead/player/footsteps/infected/run/metalgrate1.mp3","left4dead/player/footsteps/infected/run/metalgrate2.mp3","left4dead/player/footsteps/infected/run/metalgrate3.mp3","left4dead/player/footsteps/infected/run/metalgrate3.mp3","left4dead/player/footsteps/infected/run/metal1.mp3","left4dead/player/footsteps/infected/run/metal2.mp3","left4dead/player/footsteps/infected/run/metal3.mp3","left4dead/player/footsteps/infected/run/metal4.mp3"},
	[MAT_ALIENFLESH] = {"left4dead/player/footsteps/infected/run/flesh1.mp3","left4dead/player/footsteps/infected/run/flesh2.mp3","left4dead/player/footsteps/infected/run/flesh3.mp3","left4dead/player/footsteps/infected/run/flesh4.mp3"},
	[MAT_SNOW] = {"left4dead/player/footsteps/infected/run/sand1.mp3","left4dead/player/footsteps/infected/run/sand2.mp3","left4dead/player/footsteps/infected/run/sand3.mp3","left4dead/player/footsteps/infected/run/sand4.mp3","left4dead/player/footsteps/infected/run/grass1.mp3","left4dead/player/footsteps/infected/run/grass2.mp3","left4dead/player/footsteps/infected/run/grass3.mp3","left4dead/player/footsteps/infected/run/grass4.mp3"},
	[MAT_PLASTIC] = {"left4dead/player/footsteps/infected/run/concrete1.mp3","left4dead/player/footsteps/infected/run/concrete2.mp3","left4dead/player/footsteps/infected/run/concrete3.mp3","left4dead/player/footsteps/infected/run/concrete4.mp3"},
	[MAT_METAL] = {"left4dead/player/footsteps/infected/run/metal1.mp3","left4dead/player/footsteps/infected/run/metal2.mp3","left4dead/player/footsteps/infected/run/metal3.mp3","left4dead/player/footsteps/infected/run/metal4.mp3"},
	[MAT_SAND] = {"left4dead/player/footsteps/infected/run/sand1.mp3","left4dead/player/footsteps/infected/run/sand2.mp3","left4dead/player/footsteps/infected/run/sand3.mp3","left4dead/player/footsteps/infected/run/sand4.mp3"},
	[MAT_FOLIAGE] = {"left4dead/player/footsteps/infected/run/grass1.mp3","left4dead/player/footsteps/infected/run/grass2.mp3","left4dead/player/footsteps/infected/run/grass3.mp3","left4dead/player/footsteps/infected/run/grass4.mp3","left4dead/player/footsteps/infected/run/gravel1.mp3","left4dead/player/footsteps/infected/run/gravel2.mp3","left4dead/player/footsteps/infected/run/gravel3.mp3","left4dead/player/footsteps/infected/run/gravel4.mp3"},
	[MAT_COMPUTER] = {"left4dead/player/footsteps/infected/run/concrete1.mp3","left4dead/player/footsteps/infected/run/concrete2.mp3","left4dead/player/footsteps/infected/run/concrete3.mp3","left4dead/player/footsteps/infected/run/concrete4.mp3"},
	[MAT_SLOSH] = {"left4dead/player/footsteps/infected/run/mud1.mp3","left4dead/player/footsteps/infected/run/mud2.mp3","left4dead/player/footsteps/infected/run/mud3.mp3","left4dead/player/footsteps/infected/run/mud4.mp3"},
	[MAT_TILE] = {"left4dead/player/footsteps/infected/run/tile1.mp3","left4dead/player/footsteps/infected/run/tile2.mp3","left4dead/player/footsteps/infected/run/tile3.mp3","left4dead/player/footsteps/infected/run/tile4.mp3"},
	[MAT_GRASS] = {"left4dead/player/footsteps/infected/run/grass1.mp3","left4dead/player/footsteps/infected/run/grass2.mp3","left4dead/player/footsteps/infected/run/grass3.mp3","left4dead/player/footsteps/infected/run/grass4.mp3"},
	[MAT_VENT] = {"left4dead/player/footsteps/infected/run/metal1.mp3","left4dead/player/footsteps/infected/run/metal2.mp3","left4dead/player/footsteps/infected/run/metal3.mp3","left4dead/player/footsteps/infected/run/metal4.mp3"},
	[MAT_WOOD] = {"left4dead/player/footsteps/infected/run/wood1.mp3","left4dead/player/footsteps/infected/run/wood2.mp3","left4dead/player/footsteps/infected/run/wood3.mp3","left4dead/player/footsteps/infected/run/wood4.mp3"},
	[MAT_GLASS] = {"left4dead/player/footsteps/infected/run/glass1.mp3","left4dead/player/footsteps/infected/run/glass2.mp3","left4dead/player/footsteps/infected/run/glass3.mp3","left4dead/player/footsteps/infected/run/glass4.mp3"}
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