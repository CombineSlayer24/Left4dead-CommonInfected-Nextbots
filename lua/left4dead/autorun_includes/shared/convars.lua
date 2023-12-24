-- Should the population convars be clientsided?

-- ServerSide Convars
--CreateConVar( "l4d_sv_pop_police01_chance", 30, FCVAR_ARCHIVE, "% for Police models being spawned?", 0, 100 )
CreateConVar( "l4d_sv_difficulty", 1, FCVAR_ARCHIVE, "Difficulty for Infected? 0 - Easy, 1 - Normal, 2 - Advanced, 3 - Expert", 0, 3 )
CreateConVar( "l4d_sv_voiceset", 0, FCVAR_ARCHIVE, "What voiceset should Common Infected use? 0 - Default, 1 - Left 4 Dead 1, 2 - Left 4 Dead 2", 0, 2 )
CreateConVar( "l4d_sv_deathanims", 1, FCVAR_ARCHIVE, "Should Infected do Death Animations?", 0, 1 )
CreateConVar( "l4d_sv_climb", 1, FCVAR_ARCHIVE, "Should Infected climb up obstacles?", 0, 1 )
CreateConVar( "l4d_sv_createitems", 1, FCVAR_ARCHIVE, "Should Infected spawn with props/items?", 0, 1 )

-- Car Alarm
CreateConVar( "l4d_car_alarm_chirp_distance", 350, FCVAR_ARCHIVE, "The distance between the car and players for the car alarm to start emitting random chirping." )
CreateConVar( "l4d_car_alarm_distance", 750, FCVAR_ARCHIVE, "The distance at which players can trigger the car alarm. Players beyond the distance will not trigger the alarm" )

-- Combat Related
CreateConVar( "l4d_sv_z_health", 50, FCVAR_ARCHIVE, "Infected max health" )
CreateConVar( "l4d_sv_z_brawl_chance", 2, FCVAR_ARCHIVE, "Chance for when Common Infected fight eachother when bumped into", 0, 100 )
CreateConVar( "l4d_sv_z_fallen_health_multiplier", 20.0, FCVAR_ARCHIVE, "Health multipled. 1000 Default, 20.0." )
CreateConVar( "l4d_sv_z_jimmy_health_multiplier", 20.0, FCVAR_ARCHIVE, "Health multipled. 3000 deafult, 20.0" )
CreateConVar( "l4d_sv_z_riot_armor_protection", 1, FCVAR_ARCHIVE, "Should Riot Infected have full immunity from attacks?" )
CreateConVar( "l4d_sv_z_hit_interval_easy", 0.5, FCVAR_ARCHIVE, "Minimum time between damaging a target from an Infected", 0, 1.5 )
CreateConVar( "l4d_sv_z_hit_interval_normal", 0.33, FCVAR_ARCHIVE, "Minimum time between damaging a target from an Infected", 0, 1.5 )
CreateConVar( "l4d_sv_z_hit_interval_advanced", 0.5, FCVAR_ARCHIVE, "Minimum time between damaging a target from an Infected", 0, 1.5 )
CreateConVar( "l4d_sv_z_hit_interval_expert", 1.0, FCVAR_ARCHIVE, "Minimum time between damaging a target from an Infected", 0, 1.5 )

-- Preformance
CreateConVar( "l4d_sv_cull", 0, FCVAR_ARCHIVE, "If 1, Infected will be removed if they're far from players", 0, 1 )
CreateConVar( "l4d_sv_cull_timeout", 5, FCVAR_ARCHIVE, "Grace period before Infected is culled for being far away", 0, 10 )

-- ClientSide Convars --
CreateClientConVar( "l4d_cl_particles", 1, true, false, "Should Common Infected have particle effects? (Puking, blood)" )


-- Glow
CreateClientConVar( "l4d_cl_glow", 1, true, false, "Enable the glow system" )
CreateClientConVar( "l4d_cl_glow_performance_mode", 1, true, false, "If enabled, will reduce the glow effects. Saves performance. " )

-- Infected that's has been vomited on
CreateClientConVar( "l4d_cl_glow_infected_vomit_r", 201, true, false, "Red color for Vomited Infected" )
CreateClientConVar( "l4d_cl_glow_infected_vomit_g", 17, true, false, "green color for Vomited Infected" )
CreateClientConVar( "l4d_cl_glow_infected_vomit_b", 183, true, false, "blue color for Vomited Infected" )

-- NPC/NextBot/Players that's been vomited
CreateClientConVar( "l4d_cl_glow_npc_vomit_r", 255, true, false, "Red color for Vomited npcs/players" )
CreateClientConVar( "l4d_cl_glow_npc_vomit_g", 102, true, false, "green color for Vomited npcs/players" )
CreateClientConVar( "l4d_cl_glow_npc_vomit_b", 0, true, false, "blue color for Vomited npcs/players" )

-- NPC/NextBot/Players glow
CreateClientConVar( "l4d_cl_glow_npc_r", 76, true, false, "Red color for npcs/players" )
CreateClientConVar( "l4d_cl_glow_npc_g", 102, true, false, "green color for npcs/players" )
CreateClientConVar( "l4d_cl_glow_npc_b", 255, true, false, "blue color for npcs/players" )