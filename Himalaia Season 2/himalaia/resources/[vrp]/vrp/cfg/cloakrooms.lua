local cfg = {}

local surgery_male = { model = "mp_m_freemode_01" }
local surgery_female = { model = "mp_f_freemode_01" }
local travesti1 = { model = "a_m_m_tranvest_01" }
local travesti2 = { model = "a_m_m_tranvest_02" }
local gogoboy = { model = "u_m_y_staggrm_01" }
local deus = { model = "u_m_m_jesus_01" }
local padre = { model = "cs_priest" }
local pegrande = { model = "cs_orleans" }
local gato = { model = "a_c_cat_01" }
local pug = { model = "a_c_pug" }
local lessie = { model = "a_c_shepherd" }
local poodle = { model = "a_c_westy" }
local onca = { model = "a_c_mtlion" }
local chop = { model = "a_c_chop" }
local macaco = { model = "a_c_chimp" }

for i=0,19 do
	surgery_female[i] = { 1,0 }
	surgery_male[i] = { 1,0 }
end

cfg.cloakroom_types = {
	["Personagem"] = {
		_config = {permissions={"admin.permissao"}},
		["Travesti 1"] = travesti1,
		["Travesti 2"] = travesti2,
		["Gogoboy"] = gogoboy,
		["Deus"] = deus,
		["Padre"] = padre,
		["Pé Grande"] = pegrande,
		["Gato"] = gato,
		["Pug"] = pug,
		["Lessie"] = lessie,
		["Poodle"] = poodle,
		["Onça"] = onca,
		["Chop"] = chop,
		["Macaco"] = macaco
	},
	["Policia"] = {
		_config = { permissions = {"policia.permissao"} },
		["Policia c/ Jaqueta M"] = {  
			[1] = {0,0,2},
			[2] = {4,0,0},
			[3] = {31,0,2},
			[4] = {87,0,2},
			[5] = {-1,0,2},
			[6] = {25,0,2},
			[7] = {-1,0,2},
			[8] = {15,0,2},
			[9] = {-1,0,2},
			[10] = {-1,0,2},
			[11] = {220,0,2},
			["p0"] = { -1,0 },
			["p1"] = { -1,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }		
		},	

		["Policia c/ Jaqueta F"] = {  
			[1] = {0,0,0},
			[2] = {4,0,0},
			[3] = {14,0,2},
			[4] = {90,0,2},
			[5] = {0,0,0},
			[6] = {25,0,2},
			[7] = {0,0,0},
			[8] = {14,0,2},
			[9] = {0,0,0},
			[10] = {0,0,0},	
			[11] = {230,0,2},
			["p0"] = { -1,0 },
			["p1"] = { -1,0 },
			["p2"] = { -1,0 },
			["p6"] = { 0,0 },
			["p7"] = { -1,0 }
		},	

		["Policia c/ Camiseta M"] = {  
			[1] = {0,0,2},
			[2] = {4,0,0},
			[3] = {30,0,2},
			[4] = {87,0,2},
			[5] = {-1,0,2},
			[6] = {25,0,2},
			[7] = {-1,0,2},
			[8] = {15,0,2},
			[9] = {-1,0,2},
			[10] = {-1,0,2},
			[11] = {271,0,2},
			["p0"] = { -1,0 },
			["p1"] = { -1,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }		
		},

		["Policia c/ Camiseta F"] = {  
			[1] = {0,0,0},
			[2] = {4,0,0},
			[3] = {14,0,2},
			[4] = {90,0,2},
			[5] = {0,0,0},
			[6] = {25,0,2},
			[7] = {0,0,0},
			[8] = {14,0,2},
			[9] = {0,0,0},
			[10] = {0,0,0},	
			[11] = {266,0,2},
			["p0"] = { -1,0 },
			["p1"] = { -1,0 },
			["p2"] = { -1,0 },
			["p6"] = { 0,0 },
			["p7"] = { -1,0 }
		},	
	},

	["Hospital"] = {
		_config = { permissions = {"paramedico.permissao"} },   
		["Paramédico"] = {
			[2] = {70,0},
			[3] = {85,0},
			[4] = {96,0},
			[5] = {0,0},
			[6] = {9,2},
			[7] = {127,0}, 
			[8] = {15,0},
			[9] = {0,1},
			[10] = {0,0},
			[11] = {250,0},
			[12] = {0,0},
			["p0"] = {-1,0},
			["p1"] = {-1,0}    
		},
		["Paramédica"] = { 
			[2] = {38,0},
			[3] = {109,0},
			[4] = {99,0},
			[5] = {-1,0},    
			[6] = {27,0},
			[7] = {97,0},    
			[8] = {-1,0},
			[9] = {1,0},
			[10] = {0,0},      
			[11] = {258,0},
			["p0"] = {-1,0}
		},
		["Médico"] = {
			[1] = { -1,0 },
			[5] = { -1,0 },
			[7] = { 126,0 },
			[3] = { 4,0 },
			[4] = { 25,5 },
			[8] = { 31,4 },
			[6] = { 21,9 },
			[11] = { 31,7 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			["p0"] = { -1,0 },
			["p1"] = { -1,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		},
		["Médica"] = {    
			[1] = { -1,0 },
			[5] = { -1,0 },
			[7] = { 96,0 },
			[3] = { 0,0 },
			[4] = { 23,0 },
			[8] = { 38,4 },
			[6] = { 0,2 },
			[11] = { 57,7 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			["p0"] = { -1,0 },
			["p1"] = { -1,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		},
	},  

}

cfg.cloakrooms = {
	{ "Personagem",206.82,-1002.02,29.29 },
	{ "Policia",619.28,13.22,82.78 },
	{ "Hospital",298.95,-598.38,43.29 },

}

return cfg