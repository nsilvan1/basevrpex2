local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP") 
dPN = {}
Tunnel.bindInterface("dpn_inventory_chest",dPN)
Proxy.addInterface("dpn_inventory_chest",dPN)
dPNserver = Tunnel.getInterface("dpn_inventory_chest")
ConfigClient = {
    unidades = 10,
    distance = 1, -- Distancia que poderá abrir as lojas
    chestDistance = 2, -- Distancia que poderá abrir os baús das casas
    chestFacDistance = 2, -- Distancia que poderá abrir baú das facções
	craftDistance = 2,

    keyBind = true, -- Se o inventário terá key bind ou seja os 5 primeiros itens ele poderá usar com as teclas 1,2,3,4,5 respectivamente
    keyBindWeapon = false, -- Se o inventário terá a opção e pegar a arma na mão e desativar o tab ao usar a keybind
    ip = "http://189.127.164.126/itens/", -- caso use ip por xammp bote o caminho assim http://ip/caminho e tire as iamgens do fx_manifest
	transform = true,
    blackItemList = {
        trunckchest = {
            "identidade",
            "dinheirosujo",
			"dinheiro"
        }, -- Itens que não poderá colocar no chest das dos carros
        chest = {
            "identidade",
            "cartao"
        },-- Itens que não poderá colocar no chest das facções
        homes = {
            "identidade",
            "cartao"
        }, -- Itens que não poderá colocar no chest das casas
      
    }, -- Itens que não poderá colocar nos trunckchests, chests, homes

	separatedTrunk = true, -- Desativa bau de carro no aspas
	disableIncludedTrunk = true, -- Ativa bau de carro em outra tecla
	keybindTrunk = "PAGEUP", -- Tecla a ser usada acima
	separatedChest = true, -- Abrir bau no E
	disableIncludedChest = false, -- Desativar bau nas aspas
	separatedShop = true, -- Desabilita as lojinhas no aspas
	percentual = 1,

    lojas = {
        -- caso queira fazer mais uma loja copie daqui:
        ammunation = {
            onlyType = "buy",
            locs = {
                { -1081.55, -819.5, 11.04 },
                { 252.89,-49.25,69.94 },
                { 843.28,-1034.02,28.19 },
                { -331.35,6083.45,31.45 },
                { -663.15,-934.92,21.82 },
                { -1305.18,-393.48,36.69 },
                { -1118.80,2698.22,18.55 },
                { 2568.83,293.89,108.73 },
                { -3172.68,1087.10,20.83 },
                { 21.32,-1106.44,29.79 },
                { 811.19,-2157.67,29.61 }
            }, -- Localizção das ammunations
            itens = {
               --[[REQUEST PORTE DE ARMAS SEGUE EXEMPLO A BAIXO]]
               --['wbody|WEAPON_KNIFE'] = {price = 10000, requireItem = {["porte-arma"] = 1 --[[ quantidade ]] }},
               --['wbody|WEAPON_MACHETE'] = {price = 12000, requireItem = {["porte-arma"] = 1 --[[ quantidade ]] }},
               --['wbody|WEAPON_SWITCHBLADE'] = {price = 10000, requireItem = {["porte-arma"] = 1 --[[ quantidade ]] }},
               --['wbody|WEAPON_HATCHET'] = {price = 10000, requireItem = {["porte-arma"] = 1 --[[ quantidade ]] }},
               --['wbody|WEAPON_BAT'] = {price = 10000, requireItem = {["porte-arma"] = 1 --[[ quantidade ]] }},
               --['wbody|WEAPON_KNUCKLE'] = {price = 12000, requireItem = {["porte-arma"] = 1 --[[ quantidade ]] }},
               --['wbody|WEAPON_FLASHLIGHT'] = {price = 10000, requireItem = {["porte-arma"] = 1 --[[ quantidade ]] }},
               --['wbody|WEAPON_BATTLEAXE'] = {price = 8000, requireItem = {["porte-arma"] = 1 --[[ quantidade ]] }},
               --['wbody|WEAPON_POOLCUE'] = {price = 9000, requireItem = {["porte-arma"] = 1 --[[ quantidade ]] }},
               --['wbody|GADGET_PARACHUTE'] = {price = 5000,  requireItem = {["porte"] = 1 --[[ quantidade ]]}},
               --['wbody|WEAPON_PISTOL'] = {price = 5000, requireItem = {["porte-arma"] = 1 --[[ quantidade ]] }},
               --['corda'] = {price = 20000},

               ['wbody|WEAPON_KNIFE'] = {price = 10000},
               ['wbody|WEAPON_DAGGER'] = {price = 10000},
               ['wbody|WEAPON_KNUCKLE'] = {price = 10000},
               ['wbody|WEAPON_MACHETE'] = {price = 10000},
               ['wbody|WEAPON_SWITCHBLADE'] = {price = 10000},
               ['wbody|WEAPON_WRENCH'] = {price = 10000},
               ['wbody|WEAPON_HAMMER'] = {price = 10000},
               ['wbody|WEAPON_GOLFCLUB'] = {price = 10000},
               ['wbody|WEAPON_CROWBAR'] = {price = 10000},
               ['wbody|WEAPON_HATCHET'] = {price = 10000},
               ['wbody|WEAPON_BAT'] = {price = 10000},
               ['wbody|WEAPON_BATTLEAXE'] = {price = 10000},
               ['wbody|WEAPON_POOLCUE'] = {price = 10000},
               ['wbody|WEAPON_STONE_HATCHET'] = {price = 10000},



            },
        }, -- até aqui e troque o nome ammunation

        bar = {
            onlyType = "buy",
            perm = nil,
            locs = {
                { -3226.57,800.72,8.93 },
                { -1391.27,-608.23,30.32 },
                { -562.13,288.87,82.18 },
                { -2649.26,1695.06,138.65 },
                { -805.9,329.62,243.23 },
                { -289.73,-725.57,125.24 },
                { -5867.8,1150.77,13.18 },
                { 131.2,-1284.2,29.28 },
                { 130.11,-1285.2,29.27 }
            }, -- Localizção das bares
            itens = {
               ['cerveja'] = {price = 70},
               ['tequila'] = {price = 120},
               ['vodka'] = {price = 200},
               ['conhaque'] = {price = 150},
               ['absinto'] = {price = 190},
            },
        }, -- até aqui e troque o nome bar

        pescaria = {
            onlyType = "sell",
            locs = {
                { -1814.71,-1212.71,13.02 }
            }, -- Localizção das bares
            itens = {
                ['dourado'] = {price = 400},
                ['corvina'] = {price = 340},
                ['salmao'] = {price = 310},
                ['pacu'] = {price = 200},
                ['pintado'] = {price = 220},
                ['pirarucu'] = {price = 230},
                ['tilapia'] = {price = 190},
                ['tucunare'] = {price = 280},
                ['lambari'] = {price = 280},
            },
        }, -- até aqui e troque o nome bar

        departamento = {
            onlyType = "buy",
            locs = {
                { 25.65,-1346.58,29.49 },
                { 2556.75,382.01,108.62 },
                { 1163.54,-323.04,69.20 },
                { -707.37,-913.68,19.21 },
                { -47.73,-1757.25,29.42 },
                { 373.90,326.91,103.56 },
                { -3243.10,1001.23,12.83 },
                { 1729.38,6415.54,35.03 },
                { 547.90,2670.36,42.15 },
                { 1960.75,3741.33,32.34 },
                { 2677.90,3280.88,55.24 },
                { 1698.45,4924.15,42.06 },
                { -1820.93,793.18,138.11 },
                { 1392.46,3604.95,34.98 },
                { -2967.82,390.93,15.04 },
                { -3040.10,585.44,7.90 },
                { 1135.56,-982.20,46.41 },
                { 1165.91,2709.41,38.15 },
                { -1487.18,-379.02,40.16 },
                { -1222.78,-907.22,12.32 },
                { -1095.55,-2594.57,13.92 },
                { -455.77,1603.53,361.12 },
                { -3205.8,792.05,8.93 },
            }, -- Localizção das lojas de departamentos
    
            itens = {
                ['celular'] = {price = 3000},
                ['radio'] = {price = 2000},
                ['roupas'] = {price = 2000},
                ['mochila'] = {price = 7000},
                ['militec'] = {price = 7000},
                ['tequila'] = {price = 100},
                ['isca'] = {price = 100},
                ['vodka'] = {price = 100},
                ['whisky'] = {price = 100}, 
            },
        },
    },

    chestFac = {
        ['Bau Policia'] = {
            loc = {-1087.66, -821.68, 11.04},
            weight = 5000, 
            perm = "policia.permissao",
            slots = 100, 
            webhook = "https://discord.com/api/webhooks/971539013011910666/6F8qPWo6bGj5YTMxO9TxKM6AgiG3bUdewxfsSh3CHt5nJ8Mb25_4KIVJ1l76YB4Pqy3X",
        },

        ['TCPBau'] = {
            loc = {116.02, 3603.53, 39.76},
            weight = 5000, 
            perm = "tcp.permissao",
            slots = 100, 
            webhook = "https://discord.com/api/webhooks//6F8qPWo6bGj5YTMxO9TxKM6AgiG3bUdewxfsSh3CHt5nJ8Mb25_4KIVJ1l76YB4Pqy3X",
        },

        ['ADABau'] = {
            loc = {3685.8, 4504.35, 26.22},
            weight = 5000, 
            perm = "ada.permissao",
            slots = 100, 
            webhook = "s70046093050138704/MMxlzx5nSlg5AmRwkbVwfYUED3cZruipk96FWrfQIeAeozdl2lejCBemikzPkGzVk97X",
        },       
		
        ['PCCBau'] = {
            loc = {2095.0, 3785.71, 36.51},
            weight = 5000, 
            perm = "pcc.permissao",
            slots = 100, 
            webhook = "s70046495652970596/StadJE6z4-rCXqaLahbHYy0eV4U1o3YtT9fxK4725cSBMZbdUx7-LlEtdIFM9tFK5w54",
        },

        ['BDMBau'] = {
            loc = {258.38, 6930.58, 19.7},
            weight = 5000, 
            perm = "bdm.permissao",
            slots = 100, 
            webhook = "s70046398802300928/YvPEJBN_ah81uR9s_58vW_jC9TMoYgsY_o38C1MFwojWlT5sFR0fLWMegq2Lx7IdpMn3",
        },

        ['MiliciaBau'] = {
            loc = {5544.96, -5387.3, 28.63},
            weight = 5000, 
            perm = "milicia.permissao",
            slots = 100, 
            webhook = "s70046577035055155/Yui6iGA8lF6o_hLySU8uJGsVzE2GT3NNQ9o_dNieFvRjHWNn5J1KjUZy7kz7EwXK3i3A",
        },

        ['MotoclubBau'] = {
            loc = {992.25,-135.29,74.07},
            weight = 5000, 
            perm = "motoclub.permissao",
            slots = 100, 
            webhook = "",
        },

        ['SonsofAnarchyBau'] = {
            loc = {882.58,-2107.34,30.77},
            weight = 5000, 
            perm = "sonsofanarchy.permissao",
            slots = 100, 
            webhook = "",
        },	

        ['VanillaBau'] = {
            loc = {106.58, -1299.46, 28.77},
            weight = 5000, 
            perm = "vanilla.permissao",
            slots = 100, 
            webhook = "",
        },	

        ['Motoblube'] = {
            loc = {977.16, -104.19, 74.85},
            weight = 5000, 
            perm = "motoclube.permissao",
            slots = 100, 
            webhook = "",
        },
        ['Mafia'] = {
            loc = {-1881.79, 2060.82, 140.99},
            weight = 5000, 
            perm = "mafia.permissao",
            slots = 100, 
            webhook = "",
        },
        ['MeduzaBau'] = {
            loc = {750.96, -581.96, 33.65},
            weight = 5000, 
            perm = "medyza.permissao",
            slots = 100, 
            webhook = "s68518101186531358/JkW0bYyGZW3fFrpuj_jSPljIFo3onbjOAJ01GBfJ7YEutAcCGW0Ov2Vp0ZXSGafduNEv",
        },

        ['FuriusBau'] = {
            loc = {146.38,-3007.71,7.05},
            weight = 5000, 
            perm = "furius.permissao",
            slots = 100, 
            webhook = "",
        },

        ['PoliciaCivilBau'] = {
            loc = {-938.92, -2099.81, 9.3},
            weight = 5000, 
            perm = "policia.permissao",
            slots = 100, 
            webhook = "",
        },

        ['PoliciaMilitarBau'] = {
            loc = {2527.32, -341.29, 101.9},
            weight = 5000, 
            perm = "policia.permissao",
            slots = 100, 
            webhook = "s60200557077885020/bCWjvZrOZL4F2jr7aikeKlJJ_GIPxQt7H0Woagzrfwl0mmtr5eQcaFFPBoKJO7knBI0n",
        },
		
        ['PoliciaBopeBau'] = {
            loc = {276.16, -347.36, 49.54},
            weight = 5000, 
            perm = "policia.permissao",
            slots = 100, 
            webhook = "",
        },

        ['PoliciaRotaBau'] = {
            loc = {-2010.9,-505.6,12.23},
            weight = 5000, 
            perm = "policia.permissao",
            slots = 100, 
            webhook = "",
        },

        ['cassinoaBau'] = {
            loc = {959.44, 34.21, 71.84},
            weight = 5000, 
            perm = "cassino.permissao",
            slots = 100, 
            webhook = "s67501790897668177/MGpPxR1obBy4peugwSdOJC0SiLL-j4usXrQVhCn6T4qnYsjR4zSVj-bjer0WjK66HUlx",
        },				
		
        ['PoliciaRodoviarioBau'] = {
            loc = {1535.82,797.34,77.62},
            weight = 5000, 
            perm = "policia.permissao",
            slots = 100, 
            webhook = "",
        },	

        ['HospitalBau'] = {
            loc = {301.81,-599.46,43.28},
            weight = 5000, 
            perm = "paramedico.permissao",
            slots = 100, 
            webhook = "",
        },	

        ['Yakuza'] = {
            loc = {-872.75, -1456.98, 7.53},
            weight = 5000, 
            perm = "yakuza.permissao",
            slots = 100, 
            webhook = "s70046654893940787/pl5H3lthNDIUzUzHkvz5g82fx4lbTRCt1QNV3SKdMCrxsyDIp8MHAfJpbriiipGVXBIF",
        },	

        ['MecanicaBau'] = {
            loc = {-793.89, -2592.38, 13.79},
            weight = 5000, 
            perm = "mecanico.permissao",
            slots = 100, 
            webhook = "",
        },	
        ['casavip1'] = {
            loc = {-2675.33, 1304.26, 152.02},
            weight = 100000, 
            perm = "casavip.permissao",
            slots = 500, 
            webhook = "",
        },
        ['casavip3'] = {
            loc = {-887.76, 53.2, 53.3},
            weight = 100000, 
            perm = "casavip.permissao",
            slots = 500, 
            webhook = "",
        },
        ['casavip4'] = {
            loc = {2555.38, 6184.51, 168.4},
            weight = 100000, 
            perm = "casavip.permissao",
            slots = 500, 
            webhook = "",
        },
        ['casavip2'] = {
            loc = {9.36, 529.43, 170.62},
            weight = 100000, 
            perm = "casavip2.permissao",
            slots = 500, 
            webhook = "",
        },		
    } 

}
