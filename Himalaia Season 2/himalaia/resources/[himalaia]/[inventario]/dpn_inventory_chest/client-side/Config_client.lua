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
	disableIncludedChest = true, -- Desativar bau nas aspas
	separatedShop = true, -- Desabilita as lojinhas no aspas
	percentual = 2,

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
            webhook = "",
        },

        ['Bau Hospital'] = {
            loc = {307.05, -601.48, 43.29},
            weight = 5000, 
            perm = "policia.permissao",
            slots = 100, 
            webhook = "",
        },

        ['Bau Mecanica'] = {
            loc = {803.62, -908.6, 25.26},
            weight = 5000, 
            perm = "policia.permissao",
            slots = 100, 
            webhook = "",
        },

        ['Bau Ballas'] = {
            loc = {106.24, -1981.47, 20.97},
            weight = 5000, 
            perm = "ballas.permissao",
            slots = 100, 
            webhook = "",
        },
    } 

}
