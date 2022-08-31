
function formaDeTirarDinheiro(user_id,amount)
    if vRP.tryFullPayment(user_id,amount) then
        return true
    else
        return false
    end
end -- sua função de tirar o dinheiro



function formDeDarDinheiro(user_id,amount)
	if amount >= 0 then
		vRP.giveInventoryItem(user_id,"dinheiro",amount)
	end
end


function getMoney(user_id)
    return vRP.getMoney(user_id)
end -- sua função de pegar o dinheiro

function hasPermission(user_id,perm)
    return vRP.hasPermission(user_id,perm)
end -- sua função de pegar a permissao


ConfigServer = {
    slots = 100, -- Maximo de slots que as pessoas poderão ter comprando slots, esse valor menos 15 slot, caso queria que não seja possivel comprar slots bote 0 
    priceSlot = 50000, -- Preço dos slots
    bahamas = false, -- Coloque true caso sua base seja a do bahamas
    typeJob = "primario", -- Nome do type dos grupos padrões
    typeVip = "vip", -- Nome do type dos grupos dos vips
    multasType = "vRP:multas", -- Nome do banco de dados das multa
    currency = "R$", -- Tipo da sua moeda
    adminPermissao = "admin.permissao", -- Permissão que todos adm tem
    policiaPermissao = "policia.permissao", -- Permissão que todos policiais tem
    garageName = "nation_garages", -- Nome da sua resource de garagem
    skilBar = "taskbar", -- Nome da sua resource de skilbar se tiver claro
    groups = "cfg/groups", -- Caso use a base zirix deixe assim: zirix/groups, caso use a evolution deixe assim: evolution/groups
    itemVrp = "modules/inventory", -- Caso use a base zirix deixe assim: zirix, caso use a base evolution deixe assim: evolution
	statusWeapon = true,
    typeItens = {
        usar = "usar", -- Type dos itens normais
        recarregar = "recarregar", -- Type das munições
        equipar = "equipar", -- Type das armas
    },
    carSlots = {
        exclusive = 50,
        carros = 10,
        motos = 3,
        work = 100,
        trunk = 10,
        vip = 50
    }, -- Cada carro tem um  tipo isso você pode ver em vrp<modules<inventory.lua, la vai ter uma lista com muitos carros e em cada carro tera tipo, os slots são
    -- separados pelo tipo do carro, ou seja se o tipo do carro for moto então ele pegará os slots da tabela a cima por ex:

    -- Vai estar mais ou menos assim:
    --	["urus"] = { ['name'] = "Lamborghini Urus", ['price'] = 1000000, ['tipo'] = "exclusive" },
    -- O tipo é exclusive então ele pegará 50 slots para esse carro.
    webhook = {
        send = "https://.com/api/webhooks//d65bC2HzoCfkGl3YiiPzi13Dt0iLO4cmn5ZyjyZzYH6iXpex6yz_pMIFYlTsc0yPHnXZ",
        dropar = "https://.com/api/webhooks//4LvKxlL4fBNj3wgDDUQkEMWYTKbOwo7W5wXOVsg3co4bRCCfTEzf9Zj0MyuKNTC73DGp",
        equip = "https://.com/api/webhooks//L0WXVwWMDBNiRPjAoQRRM56e9SZRGOyKlOYwg5DlnP7z-x7wtFebQ1B1UAwLNWsLyhDu",
        casa = "https://discord./api/webhooks//",
        carro = "https://discord./api///rALuGOkn6PMRUap1AcUWEAUU6OYbiPaLf3MvBDwX4p87QsFtt2Mv1vOzmalyQ1Q6Bs6n",
        antidupe = "https://discord./api///k1qVVyqzl_I9qhTLNleOgNiv6vM4XQUm7efsN4ti0wl-jSXJ6KsCJJqFFo74dwGe6wnk",
    }, -- Webhook de enviar, dropar e equipar, bau de casa, bau de carro, anti-dump respectivamente

    listaDeItens = {
        --------------------------------------------------------
        ["dinheiro"] = { index = "dinheiro", nome = "Dinheiro", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
        ["dima"] = { index = "dima", nome = "Diamantes", filtro = "box", type = "usar", funcao = false, descricao = "Diamantes para comprar premium ou negociar!" },
		["dinheiro-sujo"] = { index = "dinheirosujo", nome = "Dinheiro Sujo", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
        ["ficha"] = { index = "ficha", nome = "ficha", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
        ["encomenda"] = { index = "encomenda", nome = "Encomenda", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
        ["cordas"] = { index = "cordas", nome = "Cordas", filtro = "box", type = "usar", funcao = false, descricao = "Cordas para muitas opções de serviços" },
        ["roupas"] = { index = "roupas", nome = "Roupas", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
        ["radio"] = { index = "radio", nome = "Radio", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
        ["celular"] = { index = "celular", nome = "Celular", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
        ["mochila"] = { index = "mochila", nome = "Mochila", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
        ["tabletpolicial"] = { index = "tabletpolicial", nome = "Tablet Policial", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
		["repairkit"] = { index = "repairkit", nome = "Kit de reparo", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
		["pneu"] = { index = "pneu", nome = "pneu", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
		["skate"] = { index = "skate", nome = "Skate", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
        ["raspadinha"] = { index = "raspadinha", nome = "raspadinha", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
		--------------------------------------------------------  
        ["bandagem"] = { index = "bandagem", nome = "Bandagem", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
        ["analgetico"] = { index = "analgetico", nome = "Analgetico", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
        ["adrenalina"] = { index = "adrenalina", nome = "Adrenalina", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
        ["ibuprofeno"] = { index = "ibuprofeno", nome = "Ibuprofeno", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
        ["paracetamol"] = { index = "paracetamol", nome = "Paracetamol", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
		--------------------------------------------------------  
		["vara"] = { index = "vara", nome = "Vara Pesca", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
		["isca"] = { index = "isca", nome = "Isca Pesca", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
		["bacalhau"] = { index = "bacalhau", nome = "Bacalhau", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
		["carpa"] = { index = "carpa", nome = "Carpa-Comum", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
		["catfish"] = { index = "catfish", nome = "Catfish", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
		["pacu"] = { index = "pacu", nome = "Pacu", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
		["tilapia"] = { index = "tilapia", nome = "Tilapia", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira lícita" },
        ["chips_casino"] = { index = "chips_casino", nome = "Fichas do Cassino", filtro = "box", type = "usar", funcao = false, descricao = "Fichas para apostar no cassino" },
		---------- [ RELAÇÃO CNH ]  ----------- 
        ["licensacnh"] = { index = "cnh", nome = "Licensa CNH", filtro = "box", type = "usar", funcao = false, descricao = "Lincensa para tirar CNH" },
        ["testepass"] = { index = "testepass", nome = "testepass", filtro = "box", type = "usar", funcao = false, descricao = "Pass Prova CNH" },
        --------- [ MAPAS ] -----------
        ["mapacorridas"] = { index = "mapa", nome = "mapacorridas", filtro = "box", type = "usar", funcao = false, descricao = "Mapa com a localização das corridas" },
        --------- [ VIPS ] --------
        ["vipgold"] = { index = "vipgold", nome = "Pusseira Gold", filtro = "box", type = "usar", funcao = false, descricao = "Um beneficio Premium de Porte GOLD" },

		["agua"] = { index = "agua", nome = "Agua",filtro = "soda", type = "usar", funcao = false, descricao = "Bebida refrescante" },
		["garrafa-vazia"] = { index = "garrafa-vazia", nome = "Garrafa Vazia",filtro = "soda", type = "usar", funcao = false, descricao = "Bebida refrescante" },
		["cafe"] = { index = "cafe", nome = "Cafe",filtro = "soda", type = "usar", funcao = false, descricao = "Bebida refrescante" },
		["cola"] = { index = "cola", nome = "Cola",filtro = "soda", type = "usar", funcao = false, descricao = "Bebida refrescante" },
		["sprunk"] = { index = "sprunk", nome = "Sprunk",filtro = "soda", type = "usar", funcao = false, descricao = "Bebida refrescante" },
		["cerveja"] = { index = "cerveja", nome = "Cerveja",filtro = "soda", type = "usar", funcao = false, descricao = "Bebida refrescante" },
		["tequila"] = { index = "tequila", nome = "Tequila",filtro = "soda", type = "usar", funcao = false, descricao = "Bebida refrescante" },
		["vodka"] = { index = "vodka", nome = "Vodka",filtro = "soda", type = "usar", funcao = false, descricao = "Bebida refrescante" },
		["whisky"] = { index = "whisky", nome = "Whisky",filtro = "soda", type = "usar", funcao = false, descricao = "Bebida refrescante" },
		["absinto"] = { index = "absinto", nome = "Absinto",filtro = "soda", type = "usar", funcao = false, descricao = "Bebida refrescante" },
		--------------------------------------------------------  
		["batatinha"] = { index = "batatinha", nome = "Batatinha", filtro = "food", type = "usar", funcao = false, descricao = "Deliciosa laranja, colhida em um pé maduro" },
        ["bchocolate"] = { index = "bchocolate", nome = "Chocolate",filtro = "food", type = "usar", funcao = false, descricao = "Chocolate gostoso bom para matar a fome" },
        ["frango"] = { index = "frango", nome = "Frago",filtro = "food", type = "usar", funcao = false, descricao = "Chocolate gostoso bom para matar a fome" },
        ["hotdog"] = { index = "hotdog", nome = "HotDog",filtro = "food", type = "usar", funcao = false, descricao = "Chocolate gostoso bom para matar a fome" },
	    ["pizza"] = { index = "pizza", nome = "Pizza",filtro = "food", type = "usar", funcao = false, descricao = "Pizza gostosa boa para matar a fome mama mia" },
	    ["taco"] = { index = "taco", nome = "Taco",filtro = "food", type = "usar", funcao = false, descricao = "Pizza gostosa boa para matar a fome mama mia" },
	    ["xburguer"] = { index = "xburguer", nome = "Xburguer",filtro = "food", type = "usar", funcao = false, descricao = "Pizza gostosa boa para matar a fome mama mia" },
		--------------------------------------------------------
	    ["prata"] = { index = "prata", nome = "Prata",filtro = "box", type = "usar", funcao = false, descricao = "Pizza gostosa boa para matar a fome mama mia" },
	    ["ouro"] = { index = "ouro", nome = "Ouro",filtro = "box", type = "usar", funcao = false, descricao = "Pizza gostosa boa para matar a fome mama mia" },
	    ["diamante"] = { index = "diamante", nome = "Diamante",filtro = "box", type = "usar", funcao = false, descricao = "Pizza gostosa boa para matar a fome mama mia" },
	    ["esmeralda"] = { index = "esmeralda", nome = "Esmeralda",filtro = "box", type = "usar", funcao = false, descricao = "Pizza gostosa boa para matar a fome mama mia" },  
		--------------------------------------------------------
        ["colete"] = { index = "colete", nome = "Colete Balistico", filtro = "box", type = "usar", funcao = "Dar colete", descricao = "Utilize colete para maior segurança na troca de tiro" },
        ["ticketrol"] = { index = "ticket", nome = "Ticket de Roleta", filtro = "box", type = "usar", funcao = false, descricao = "Ticket para ganhar itens na Roleta" },
		["lockpick"] = { index = "lockpick", nome = "LockPick", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["ticket"] = { index = "ticket", nome = "Ticket Race", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["algemas"] = { index = "algemas", nome = "Algemas", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["capuz"] = { index = "capuz", nome = "Capuz", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["c4"] = { index = "c4", nome = "c4", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["notebook"] = { index = "notebook", nome = "Notebook", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["serra"] = { index = "serra", nome = "Serra", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["furadeira"] = { index = "furadeira", nome = "Furadeira", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["energetico"] = { index = "energetico", nome = "Energetico", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		--------------------------------------------------------
		["relogioroubado"] = { index = "relogioroubado", nome = "Relogio Roubado", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["pulseiraroubada"] = { index = "pulseiraroubada", nome = "Pulseira Roubada", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["anelroubado"] = { index = "anelroubado", nome = "Anel Roubado", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["colarroubado"] = { index = "colarroubado", nome = "Colar Roubado", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["brincoroubado"] = { index = "brincoroubado", nome = "Brinco Roubado", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["carteiraroubada"] = { index = "carteiraroubada", nome = "Carteira Roubada", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["vibradorroubado"] = { index = "vibradorroubado", nome = "Vibrador Roubado", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["maquiagemroubada"] = { index = "maquiagemroubada", nome = "Maquiagem Roubada", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["sapatosroubado"] = { index = "sapatosroubado", nome = "Sapatos Roubado", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["xboxroubado"] = { index = "xboxroubado", nome = "Xbox Roubado", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["playstationroubado"] = { index = "playstationroubado", nome = "Playstation Roubado", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		--------------------------------------------------------
		["acidobateria"] = { index = "acidobateria", nome = "Acido Bateria", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["anfetamina"] = { index = "anfetamina", nome = "Anfetamina", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["metanfetamina"] = { index = "metanfetamina", nome = "Metanfetamina", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		--------------------------------------------------------
		["adubo"] = { index = "adubo", nome = "Adubo", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["cannabis"] = { index = "cannabis", nome = "Cannabis", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["maconha"] = { index = "maconha", nome = "Maconha", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		--------------------------------------------------------
		["folhadecoca"] = { index = "folhadecoca", nome = "Folha Coca", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["pastadecoca"] = { index = "pastadecoca", nome = "Pasta Coca", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["cocaina"] = { index = "cocaina", nome = "Cocaina", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		--------------------------------------------------------
		["acidosulfurico"] = { index = "acidosulfurico", nome = "Acido Sulfurico", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["dietilamina"] = { index = "dietilamina", nome = "Dietilamina", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["ecstasy"] = { index = "ecstasy", nome = "Ecstasy", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		--------------------------------------------------------
		["capsula"] = { index = "capsula", nome = "Capsula", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["polvora"] = { index = "polvora", nome = "Polvora", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["mola"] = { index = "molas", nome = "Mola", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },	
        ["placa-metal"] = { index = "placa-metal", nome = "Placa de Metal", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
        ["gatilho"] = { index = "gatilho", nome = "Gatilhos", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },				
		["corpo-arma"] = { index = "corpo-arma", nome = "Corpo-arma", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["aco"] = { index = "aco", nome = "Aco", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["placa"] = { index = "placa", nome = "Placa", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["tinta"] = { index = "tinta", nome = "Tinta", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["papel"] = { index = "papel", nome = "Papel", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["linha"] = { index = "linha", nome = "Linha", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["alvejante"] = { index = "alvejante", nome = "Alvejante", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
		["caixa"] = { index = "caixa", nome = "Caixa", filtro = "box", type = "usar", funcao = false, descricao = "Dinheiro obtido de maneira ilícita" },		
        --------- [ ARMAS DE MÃO ] ------------
        ["wbody|WEAPON_DAGGER"] = { index = "adaga", nome = "Adaga", type = "equipar" },
        ["wbody|WEAPON_BAT"] = { index = "beisebol", nome = "Taco de Beisebol", type = "equipar" },
        ["wbody|WEAPON_BOTTLE"] = { index = "garrafa", nome = "Garrafa", type = "equipar" },
        ["wbody|WEAPON_CROWBAR"] = { index = "cabra", nome = "Pé de Cabra", type = "equipar" },
        ["wbody|WEAPON_FLASHLIGHT"] = { index = "lanterna", nome = "Lanterna", type = "equipar" },
        ["wbody|WEAPON_GOLFCLUB"] = { index = "golf", nome = "Taco de Golf", type = "equipar" },
        ["wbody|WEAPON_HAMMER"] = { index = "martelo", nome = "Martelo", type = "equipar" },
        ["wbody|WEAPON_HATCHET"] = { index = "machado", nome = "Machado", type = "equipar" },
        ["wbody|WEAPON_KNUCKLE"] = { index = "ingles", nome = "Soco-Inglês", type = "equipar" },
        ["wbody|WEAPON_KNIFE"] = { index = "faca", nome = "Faca", type = "equipar" },
        ["wbody|WEAPON_MACHETE"] = { index = "machete", nome = "Machete", type = "equipar" },
        ["wbody|WEAPON_SWITCHBLADE"] = { index = "canivete", nome = "Canivete", type = "equipar" },
        ["wbody|WEAPON_NIGHTSTICK"] = { index = "cassetete", nome = "Cassetete", type = "equipar" },
        ["wbody|WEAPON_WRENCH"] = { index = "grifo", nome = "Chave de Grifo", type = "equipar"},
        ["wbody|WEAPON_BATTLEAXE"] = { index = "batalha", nome = "Machado de Batalha", type = "equipar"},
        ["wbody|WEAPON_POOLCUE"] = { index = "sinuca", nome = "Taco de Sinuca", type = "equipar" },
        ["wbody|WEAPON_STONE_HATCHET"] = { index = "pedra", nome = "Machado de Pedra", type = "equipar"},
		----------- [ ARMAS ] -------------	
        ["wbody|WEAPON_APPISTOL"] = { index = "appistol", nome = "Koch VP9", type = "equipar" },
        ["wbody|WEAPON_PISTOL"] = { index = "m1911", nome = "M1911", type = "equipar" },
        ["wbody|WEAPON_PISTOL_MK2"] = { index = "fiveseven", nome = "FN Five Seven", type = "equipar"},
        ["wbody|WEAPON_PISTOL50"] = { index = "desert", nome = "Desert Eagle", type = "equipar"},
        ["wbody|WEAPON_COMBATPISTOL"] = { index = "glock", nome = "Glock 19", type = "equipar"  },
        ["wbody|WEAPON_STUNGUN"] = { index = "stungun", nome = "Taser", type = "equipar" },
        ["wbody|WEAPON_SNSPISTOL"] = { index = "amt380", nome = "AMT 380", type = "equipar"  },
        ["wbody|WEAPON_VINTAGEPISTOL"] = { index = "m1922", nome = "M1922", type = "equipar" },
        ["wbody|WEAPON_REVOLVER"] = { index = "magnum", nome = "Magnum 44", type = "equipar" },
        ["wbody|WEAPON_MUSKET"] = { index = "winchester22", nome = "Winchester 22", type = "equipar" },
        ["wbody|GADGET_PARACHUTE"] = { index = "parachute", nome = "Paraquedas", type = "equipar" },
        ["wbody|WEAPON_FIREEXTINGUISHER"] = { index = "extintor", nome = "Extintor", type = "equipar" },
        ["wbody|WEAPON_MICROSMG"] = { index = "uzi", nome = "Uzi", type = "equipar" },
        ["wbody|WEAPON_SMG"] = { index = "mp5", nome = "MP5", type = "equipar"},
        ["wbody|WEAPON_ASSAULTSMG"] = { index = "mtar21", nome = "MTAR-21", type = "equipar" },
        ["wbody|WEAPON_PUMPSHOTGUN"] = { index = "remington", nome = "Remington 870", type = "equipar"},
        ["wbody|WEAPON_CARBINERIFLE"] = { index = "m4a1", nome = "M4a1", type = "equipar"},
        ["wbody|WEAPON_ASSAULTRIFLE"] = { index = "ak103", nome = "AK-103", type = "equipar" },
        ["wbody|WEAPON_GUSENBERG"] = { index = "thompson", nome = "Thompson", type = "equipar"},		
        ["wbody|WEAPON_MACHINEPISTOL"] = { index = "tec9", nome = "Tec-9", type = "equipar"},
        ["wbody|WEAPON_PETROLCAN"] = { index = "combustivel", nome = "Combustivel", type = "equipar"},
        ["wbody|WEAPON_RAYPISTOL"] = { index = "raypistol", nome = "Ray pISTOL", type = "equipar"},
        ["wbody|WEAPON_SPECIALCARBINE_MK2"] = { index = "g36c", nome = "G36", type = "equipar"},
        ["wbody|WEAPON_HEAVYSNIPER_MK2"] = { index = "Sniper", nome = "Sniper", type = "equipar"},


        ----- [ ITENS ROUPAS DA POLICIA ] -----
        ["farda-recruta"] = { index = "fardamentopm", nome = "Fardamento Recruta",filtro = "box", type = "usar", funcao = false, descricao = "Uniforme policial da patente Recruta" },
        ["farda-soldado"] = { index = "fardamentopm", nome = "Fardamento Soldado",filtro = "box", type = "usar", funcao = false, descricao = "Uniforme policial da patente Soldado" },
        ["farda-cabo"] = { index = "fardamentopm", nome = "Fardamento Cabo",filtro = "box", type = "usar", funcao = false, descricao = "Uniforme policial da patente Cabo" },
        ["farda-sargento"] = { index = "fardamentopm", nome = "Fardamento Sargento",filtro = "box", type = "usar", funcao = false, descricao = "Uniforme policial da patente Sargento" },
        ["farda-tenente"] = { index = "fardamentopm", nome = "Fardamento Tenente",filtro = "box", type = "usar", funcao = false, descricao = "Uniforme policial da patente Tenente" },
        ["farda-speed"] = { index = "fardamentopm", nome = "Fardamento Speed",filtro = "box", type = "usar", funcao = false, descricao = "Uniforme policial da patente Speed" },
        ["farda-gtm"] = { index = "fardamentopm", nome = "Fardamento G.T.M",filtro = "box", type = "usar", funcao = false, descricao = "Uniforme policial da patente G.T.M" },
        ["farda-graer"] = { index = "fardamentopm", nome = "Fardamento Graer",filtro = "box", type = "usar", funcao = false, descricao = "Uniforme policial da patente Graer" },
        ["farda-got"] = { index = "fardamentopm", nome = "Fardamento G.O.T",filtro = "box", type = "usar", funcao = false, descricao = "Uniforme policial da patente G.O.T" },
        -------  [ ITENS ROUPAS DO HP ]  -----
        ["farda-medico"] = { index = "fardamentohp", nome = "Fardamento Medico",filtro = "box", type = "usar", funcao = false, descricao = "Uniforme Hospital Medico" },
        ["farda-enfermeiro"] = { index = "fardamentohp", nome = "Fardamento Enfermeiro",filtro = "box", type = "usar", funcao = false, descricao = "Uniforme Hospital Enfermaria" },

         ----- [ ITENS SEM ROUPAS  ] -----
        ["fardaoff1"] = { index = "roupasdocorpo", nome = "Roupa do Corpo",filtro = "box", type = "usar", funcao = false, descricao = "Roupas do Corpo" },
        ["fardaoff2"] = { index = "roupasdocorpo", nome = "Roupa do Corpo",filtro = "box", type = "usar", funcao = false, descricao = "Roupas do Corpo" },
        ["fardaoff3"] = { index = "roupasdocorpo", nome = "Roupa do Corpo",filtro = "box", type = "usar", funcao = false, descricao = "Roupas do Corpo" },
        ["fardaoff4"] = { index = "roupasdocorpo", nome = "Roupa do Corpo",filtro = "box", type = "usar", funcao = false, descricao = "Roupas do Corpo" },
        ["fardaoff5"] = { index = "roupasdocorpo", nome = "Roupa do Corpo",filtro = "box", type = "usar", funcao = false, descricao = "Roupas do Corpo" },
        ["fardaoff6"] = { index = "roupasdocorpo", nome = "Roupa do Corpo",filtro = "box", type = "usar", funcao = false, descricao = "Roupas do Corpo" },
        ["fardaoff7"] = { index = "roupasdocorpo", nome = "Roupa do Corpo",filtro = "box", type = "usar", funcao = false, descricao = "Roupas do Corpo" },
        ["fardaoff8"] = { index = "roupasdocorpo", nome = "Roupa do Corpo",filtro = "box", type = "usar", funcao = false, descricao = "Roupas do Corpo" },
        ["fardaoff9"] = { index = "roupasdocorpo", nome = "Roupa do Corpo",filtro = "box", type = "usar", funcao = false, descricao = "Roupas do Corpo" },
        ["fardaoff10"] = { index = "roupasdocorpo", nome = "Roupa do Corpo",filtro = "box", type = "usar", funcao = false, descricao = "Roupas do Corpo" }, 
        ["fardaoff11"] = { index = "roupasdocorpo", nome = "Roupa do Corpo",filtro = "box", type = "usar", funcao = false, descricao = "Roupas do Corpo" },         
      
		----------- [ MUNIÇÃO DAS ARMAS ] ---------
        ["wammo|WEAPON_APPISTOL"] = { index = "appistolammo", nome = "M.Koch VP9", type = "recarregar", filtro = "arma", funcao = false, descricao = "Recarregue as munições da sua arma"  },
        ["wammo|WEAPON_PISTOL"] = { index = "m1911ammo", nome = "M.M1911", type = "recarregar", filtro = "arma", funcao = false, descricao = "Recarregue as munições da sua arma"  },
        ["wammo|WEAPON_PISTOL_MK2"] = { index = "fivesevenammo", nome = "M.FN Five Seven", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
        ["wammo|WEAPON_PISTOL50"] = { index = "desertammo", nome = "M.Desert Eagle", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
        ["wammo|WEAPON_COMBATPISTOL"] = { index = "glockammo", nome = "M.Glock 19", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
        ["wammo|WEAPON_STUNGUN"] = { index = "m-taser", nome = "M.Taser", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
        ["wammo|WEAPON_SNSPISTOL"] = { index = "amt380ammo", nome = "M.AMT 380", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
        ["wammo|WEAPON_VINTAGEPISTOL"] = { index = "m1922ammo", nome = "M.M1922", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
        ["wammo|WEAPON_REVOLVER"] = { index = "magnumammo", nome = "M.Magnum 44", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
        ["wammo|WEAPON_MUSKET"] = { index = "winchester22ammo", nome = "M.Winchester 22", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
        ["wammo|WEAPON_MICROSMG"] = { index = "uziammo", nome = "M.Uzi", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
        ["wammo|WEAPON_SMG"] = { index = "mp5ammo", nome = "M.MP5", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
        ["wammo|WEAPON_ASSAULTSMG"] = { index = "mtar21ammo", nome = "M.MTAR-21", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
        ["wammo|WEAPON_PUMPSHOTGUN"] = { index = "remingtonammo", nome = "M.Remington", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
        ["wammo|WEAPON_CARBINERIFLE"] = { index = "m4a1ammo", nome = "M.M4A1", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
        ["wammo|WEAPON_ASSAULTRIFLE"] = { index = "ak103ammo", nome = "M.AK-103", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
        ["wammo|WEAPON_GUSENBERG"] = { index = "thompsonammo", nome = "M.Thompson", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
        ["wammo|WEAPON_MACHINEPISTOL"] = { index = "m-tec9", nome = "M.Tec-9", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
        ["wammo|WEAPON_COMPACTRIFLE"] = { index = "akcompact", nome = "M.Ak Compact", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
        ["wammo|WEAPON_PETROLCAN"] = { index = "combustivel", nome = "Combustível", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
        ["wammo|WEAPON_HEAVYSNIPER_MK2"] = { index = "Sniper", nome = "Sniper", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" },
        ["wammo|WEAPON_SPECIALCARBINE_MK2"] = { index = "g36cammo", nome = "M.G36", filtro = "arma", type = "recarregar", funcao = false, descricao = "Recarregue as munições da sua arma" }
    }
}