-- Should the population convars be clientsided?

-- ServerSide Convars
CreateConVar( "left4dead_nb_sv_population_enable_police", 1, FCVAR_ARCHIVE, "Should Police models be picked?", 0, 1 )
CreateConVar( "left4dead_nb_sv_difficulty", 1, FCVAR_ARCHIVE, "Difficulty for Common Infected? 0 - Easy, 1 - Normal, 2 - Advanced, 3 - Expert", 0, 3 )
CreateConVar( "left4dead_nb_sv_voiceset", 0, FCVAR_ARCHIVE, "What voiceset should Common Infected use? 0 - Default, 1 - Left 4 Dead 1, 2 - Left 4 Dead 2", 0, 2 )
CreateConVar( "left4dead_nb_sv_deathanims", 1, FCVAR_ARCHIVE, "Should Common Infected do Death Animations?", 0, 1 )
CreateConVar( "left4dead_nb_sv_climb", 1, FCVAR_ARCHIVE, "Should Common Infected climb up obstacles?", 0, 1 )
CreateConVar( "left4dead_nb_sv_itemdrops", 1, FCVAR_ARCHIVE, "Should Common Infected spawn with props/items?", 0, 1 )

-- ClientSide Convars
CreateClientConVar( "left4dead_nb_cl_particles", 1, true, "Should Common Infected have particle effects? (Puking, blood)" )