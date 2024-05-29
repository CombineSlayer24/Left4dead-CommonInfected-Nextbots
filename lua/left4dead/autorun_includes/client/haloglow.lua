local hook_Run					= hook.Run
local hook_Add 					= hook.Add
local hook_Remove 				= hook.Remove
local timer_Exists 				= timer.Exists
local timer_Adjust 				= timer.Adjust
local timer_Create 				= timer.Create
local IsValid 					= IsValid
local CurTime 					= CurTime
local Color 					= Color

local net_Receive 				= net.Receive
local net_ReadEntity 			= net.ReadEntity
local net_ReadString 			= net.ReadString

local glow_Item 				= Color( 178, 178, 255 )
local glow_enable 				= GetConVar( "l4d_cl_glow" )
local glow_performance_mode 	= GetConVar( "l4d_cl_glow_performance_mode" )
local glow_infected_vomit_r 	= GetConVar( "l4d_cl_glow_infected_vomit_r" )
local glow_infected_vomit_g 	= GetConVar( "l4d_cl_glow_infected_vomit_g" )
local glow_infected_vomit_b 	= GetConVar( "l4d_cl_glow_infected_vomit_b" )

local glow_npc_vomit_r 			= GetConVar( "l4d_cl_glow_npc_vomit_r" )
local glow_npc_vomit_g 			= GetConVar( "l4d_cl_glow_npc_vomit_g" )
local glow_npc_vomit_b 			= GetConVar( "l4d_cl_glow_npc_vomit_b" )

local glow_npc_r 				= GetConVar( "l4d_cl_glow_npc_r" )
local glow_npc_g 				= GetConVar( "l4d_cl_glow_npc_g" )
local glow_npc_b 				= GetConVar( "l4d_cl_glow_npc_b" )

local glow_item_r 				= GetConVar( "l4d_cl_glow_item_r" )
local glow_item_g 				= GetConVar( "l4d_cl_glow_item_g" )
local glow_item_b 				= GetConVar( "l4d_cl_glow_item_b" )
---------------------------------------------------------------------------------------------------------------------------------------------
concommand.Add( "l4d_cl_reset_glowcolors", function()
	local oldValues = {
		["l4d_cl_glow_infected_vomit_r"] 	= glow_infected_vomit_r:GetInt(),
		["l4d_cl_glow_infected_vomit_g"] 	= glow_infected_vomit_g:GetInt(),
		["l4d_cl_glow_infected_vomit_b"] 	= glow_infected_vomit_b:GetInt(),
		["l4d_cl_glow_npc_vomit_r"] 		= glow_npc_vomit_r:GetInt(),
		["l4d_cl_glow_npc_vomit_g"] 		= glow_npc_vomit_g:GetInt(),
		["l4d_cl_glow_npc_vomit_b"] 		= glow_npc_vomit_b:GetInt(),
		["l4d_cl_glow_npc_r"] 				= glow_npc_r:GetInt(),
		["l4d_cl_glow_npc_g"] 				= glow_npc_g:GetInt(),
		["l4d_cl_glow_npc_b"] 				= glow_npc_b:GetInt(),
		["l4d_cl_glow_item_r"] 				= glow_item_r:GetInt(),
		["l4d_cl_glow_item_g"] 				= glow_item_g:GetInt(),
		["l4d_cl_glow_item_b"] 				= glow_item_b:GetInt()
	}

	for convar, oldValue in pairs( oldValues ) do
		MsgC( Color( 255, 0, 0 ), "- " .. convar .. " has changed, old value " .. oldValue .. "\n" )
	end

	RunConsoleCommand( "l4d_cl_glow_infected_vomit_r", "201" )
	RunConsoleCommand( "l4d_cl_glow_infected_vomit_g", "17" )
	RunConsoleCommand( "l4d_cl_glow_infected_vomit_b", "183" )

	RunConsoleCommand( "l4d_cl_glow_npc_vomit_r", "255" )
	RunConsoleCommand( "l4d_cl_glow_npc_vomit_g", "102" )
	RunConsoleCommand( "l4d_cl_glow_npc_vomit_b", "0" )

	RunConsoleCommand( "l4d_cl_glow_npc_r", "76" )
	RunConsoleCommand( "l4d_cl_glow_npc_g", "102" )
	RunConsoleCommand( "l4d_cl_glow_npc_b", "255" )

	MsgC( Color( 255, 255, 255 ), "Glow colors have been reset!\n" )
end)
---------------------------------------------------------------------------------------------------------------------------------------------
-- Set up our custom glow outline for entities.
local function DrawHalo( ent, color )
	local ScrW, ScrH = ScrW(), ScrH()
	local CopyMat							= Material( "pp/copy" )
	--local mat_Sub							= Material( "pp/add" )
	local OutlineMat						= CreateMaterial( "OutlineMat", "UnlitGeneric",{ [ "$ignorez" ] = 1,[ "$alphatest" ] = 1 } )
	local StoreTexture						= render.GetScreenEffectTexture( 0 )
	local DrawTexture						= render.GetScreenEffectTexture( 1 )
	local render 							= render
	local render_GetRenderTarget 			= render.GetRenderTarget
	local render_CopyRenderTargetToTexture 	= render.CopyRenderTargetToTexture
	local render_Clear 						= render.Clear
	local render_SetStencilEnable 			= render.SetStencilEnable
	local render_SetStencilWriteMask		= render.SetStencilWriteMask
	local render_SetStencilTestMask 		= render.SetStencilTestMask
	local render_SetStencilCompareFunction 	= render.SetStencilCompareFunction
	local render_SetStencilFailOperation 	= render.SetStencilFailOperation
	local render_SetStencilZFailOperation 	= render.SetStencilZFailOperation
	local render_SetStencilPassOperation 	= render.SetStencilPassOperation
	local render_SetStencilReferenceValue 	= render.SetStencilReferenceValue
	local render_SetMaterial 				= render.SetMaterial
	local render_DrawScreenQuad 			= render.DrawScreenQuad
	local render_DrawScreenQuadEx 			= render.DrawScreenQuadEx
	local render_SetRenderTarget 			= render.SetRenderTarget
	local render_SuppressEngineLighting 	= render.SuppressEngineLighting
	local render_BlurRenderTarget 			= render.BlurRenderTarget
	local render_ClearStencil 				= render.ClearStencil
	local surface_SetDrawColor 				= surface.SetDrawColor
	local surface_DrawRect 					= surface.DrawRect
	local cam 								= cam
	local cam_Start3D 						= cam.Start3D
	local cam_End3D 						= cam.End3D
	local cam_Start2D 						= cam.Start2D
	local cam_End2D 						= cam.End2D
	local cam_IgnoreZ 						= cam.IgnoreZ
	local STENCIL_ALWAYS 					= STENCIL_ALWAYS
	local STENCIL_REPLACE 					= STENCIL_REPLACE
	local STENCIL_KEEP 						= STENCIL_KEEP

	if !IsValid( ent ) then return end

	local scene = render_GetRenderTarget()
	render_CopyRenderTargetToTexture( StoreTexture )
	render_Clear( 0, 0, 0, 0, true, true )

	render_SetStencilEnable( true )
		cam_IgnoreZ( true )
		render_SuppressEngineLighting( true )
		render_SetStencilWriteMask( 255 )
		render_SetStencilTestMask( 255 )
		render_SetStencilCompareFunction( STENCIL_ALWAYS )
		render_SetStencilFailOperation( STENCIL_KEEP )
		render_SetStencilZFailOperation( STENCIL_REPLACE )
		render_SetStencilPassOperation( STENCIL_REPLACE )
		
		cam_Start3D()
			render_SetStencilReferenceValue( 1 )
			ent:DrawModel()
		cam_End3D()
		
		render_SetStencilCompareFunction( STENCIL_EQUAL )
		
		cam_Start2D()
			render_SetStencilReferenceValue( 1 )
			surface_SetDrawColor( color )
			surface_DrawRect( 0, 0, ScrW, ScrH )
		cam_End2D()
		
		render_SuppressEngineLighting( false )
		cam_IgnoreZ( false )
	render_SetStencilEnable( false )
	
	render_CopyRenderTargetToTexture( DrawTexture )

	-- While this will look like the glow in L4D2, it will hamper performance
--	if !glow_performance_mode:GetBool() then 
--		render_BlurRenderTarget( DrawTexture, 2, 2, 0 )
--	end

	render_SetRenderTarget( scene )
	CopyMat:SetTexture( "$basetexture", StoreTexture )
	OutlineMat:SetTexture( "$basetexture", DrawTexture )
	render_SetMaterial( CopyMat )
	render_DrawScreenQuad()
	
	render_SetStencilEnable( true )
		render_SetStencilReferenceValue( 0 )
		render_SetStencilCompareFunction( STENCIL_EQUAL )

		-- While this will look like the glow in L4D2, it will hamper performance
--		if !glow_performance_mode:GetBool() then
--			render_SetMaterial( mat_Sub )
--		else
--			render_SetMaterial( OutlineMat )
--		end

		render_SetMaterial( OutlineMat )
		
		for x = -1, 1 do
			for y = -1, 1 do
				if x == 0 and x == 0 then continue end
				render_DrawScreenQuadEx( x, y, ScrW, ScrH )
			end
		end

	render_SetStencilEnable( false )

	-- Set defualt values
	render_SetStencilTestMask( 0 )
	render_SetStencilWriteMask( 0 )
	render_SetStencilReferenceValue( 0 )
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- Apply our halo glow effect.
-- ent: the entity to apply
-- color: the color to apply halo
-- time: optional for vomit (TODO, if it's not set, them make it to where it never gets removed.)
function AddHalo( ent, color, time )
	if !glow_enable:GetBool() then return end

	local timerName = "victimHalo" .. ent:EntIndex()

	local function RemoveHooks()
		hook_Remove( "PostDrawEffects", timerName )
		hook_Remove( "PreDrawHalos", timerName )
		ent.Is_Vomited = false
	end

	hook_Add( "PostDrawEffects", timerName, function()
		hook_Run( "PreDrawHalos" )
		if IsValid( ent ) then
			DrawHalo( ent, color )
		else
			RemoveHooks()
		end
	end)

	if timer_Exists( timerName ) then
		timer_Adjust( timerName, time, 1, function()
			if IsValid( ent ) then
				RemoveHooks()
			end
		end)
	else
		timer_Create( timerName, time, 1, function()
			if IsValid( ent ) then
				RemoveHooks()
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
net_Receive( "Event_Vomited", function()
	local victim = net_ReadEntity()
	local entType = net_ReadString()

	local r_it_inf = glow_infected_vomit_r:GetInt()
	local g_it_inf = glow_infected_vomit_g:GetInt()
	local b_it_inf = glow_infected_vomit_b:GetInt()

	local r_it_npc = glow_npc_vomit_r:GetInt()
	local g_it_npc = glow_npc_vomit_g:GetInt()
	local b_it_npc = glow_npc_vomit_b:GetInt()

	if IsValid( victim ) then
		-- If it's an infected, use infected specific color
		if entType == "Infected" then
			AddHalo( victim, Color( r_it_inf, g_it_inf, b_it_inf ), 20 )
		-- If not infected, use "NPC" specific color
		elseif entType == "LambdaPlayer" or entType == "GenericNextBot" or entType == "HumanPlayer" or type == "NPC" then
			AddHalo( victim, Color( r_it_npc, g_it_npc, b_it_npc ), 8 )
		end
	end
end)

net_Receive( "Event_Highlight_Entity", function()
	local entity 		= net_ReadEntity()
	local type 			= net_ReadString()

	local r_close 		= glow_item_r:GetInt()
	local g_close 		= glow_item_g:GetInt()
	local b_close 		= glow_item_b:GetInt()

	local r_far 		= glow_npc_r:GetInt()
	local g_far 		= glow_npc_g:GetInt()
	local b_far 		= glow_npc_b:GetInt()

	if IsValid( entity ) then
		local playerPos = LocalPlayer():GetPos()
		local entityPos = entity:GetPos()
		local distance 	= playerPos:Distance( entityPos )

		-- Check if the player is looking at the entity
		local trace = LocalPlayer():GetEyeTrace()
		local isLookingAtEntity = trace.Entity == entity

		if isLookingAtEntity or distance <= 300 then
			AddHalo( entity, Color( r_close, g_close, b_close ), 999 )
		else
			AddHalo( entity, Color( r_far, g_far, b_far ), 999 )
		end
	end
end)
---------------------------------------------------------------------------------------------------------------------------------------------