default
{
	state_entry()
	{
		vector white = <1, 1, 1>;
		vector black = ZERO_VECTOR;

		llSetObjectName("Tic-Tac-Toe 2.1 [Copy]");
		llSetObjectDesc("(No Description)");
		llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_PRISM, PRIM_HOLE_SQUARE, <0.199, 0.8, 0>, 0.29799, ZERO_VECTOR, <1, 1, 0>, ZERO_VECTOR]);
		
		llSetPrimitiveParams([PRIM_BUMP_SHINY, ALL_SIDES, PRIM_SHINY_NONE, PRIM_BUMP_NONE]);

		llSetPrimitiveParams([PRIM_FLEXIBLE, FALSE, 0, 0.0, 0.0, 0.0, 0.0, ZERO_VECTOR]);

		llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);

		llSetPrimitiveParams([PRIM_MATERIAL, PRIM_MATERIAL_WOOD]);

		llSetPrimitiveParams([PRIM_PHANTOM, FALSE]);
		llSetPrimitiveParams([PRIM_PHYSICS, FALSE]);

		llSetPrimitiveParams([PRIM_POINT_LIGHT, FALSE, black, 0.0, 0.0, 0.0]);
		//llSetPrimitiveParams([PRIM_POSITION, <182.2966, 97.0784, 58.24536>]);
		llSetPrimitiveParams([PRIM_ROTATION, <-0.5, -0.5, 0.5, 0.5>]);
		llSetPrimitiveParams([PRIM_SIZE, <0.04807, 1.628121, 0.97844>]);
		llSetPrimitiveParams([PRIM_TEMP_ON_REZ, FALSE]);
		llSetPrimitiveParams([PRIM_TEXGEN, ALL_SIDES, PRIM_TEXGEN_DEFAULT]);

		llSetPrimitiveParams([
			PRIM_COLOR, 0, black, 1.0, 
			PRIM_COLOR, 1, white, 1.0, 
			PRIM_COLOR, 2, white, 1.0, 
			PRIM_COLOR, 3, white, 1.0, 
			PRIM_COLOR, 4, white, 1.0, 
			PRIM_COLOR, 5, black, 1.0, 
			PRIM_COLOR, 6, white, 1.0,
			PRIM_COLOR, 7, white, 1.0
		]);

		string image = "f399855a-4cbe-f1fe-038d-d42da9be9893";
		// Tic-Tac-Toe Image Map 2.0 512x128y.png

		llSetPrimitiveParams([
			PRIM_TEXTURE, 0, image, <0.111111, 1, 0>, <0.125004, 0, 0>, PI,
			PRIM_TEXTURE, 1, image, <0.25, 0.5, 0>, <0.125, -0.45, 0>, PI_BY_TWO,
			PRIM_TEXTURE, 2, image, <0.5, 0.75, 0>, <-0.250008, 0.125004, 0>, -PI_BY_TWO,
			PRIM_TEXTURE, 3, image, <0.5, 1.9, 0>, <-0.250008, 0.55501, 0>, PI_BY_TWO,
			PRIM_TEXTURE, 4, image, <-0.111111, 4, 0>, <0.037037, -0.675, 0>, -PI_BY_TWO,
			PRIM_TEXTURE, 5, image, <1, 1, 0>, <0.125004, 0, 0>, 0.0,
			PRIM_TEXTURE, 6, image, <0.111111, 0.25, 0>, <0.037037, -0.375, 0>, PI_BY_TWO,
			PRIM_TEXTURE, 7, image, <0.111111, 0.25, 0>, <0.037037, -0.375, 0>, PI_BY_TWO
		]);
		//while(llGetPos() != <182.2966, 97.0784, 58.24536>) llSetPos(<182.2966, 97.0784, 58.24536>);
	}
}