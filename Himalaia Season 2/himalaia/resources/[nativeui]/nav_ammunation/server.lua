-----------------------------------------------------------------------------------------------------------------------------------------
--[ VRP ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
--[ ARRAY ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local valores = {
	{ item = "wbody|WEAPON_BATTLEAXE", quantidade = 1, compra = 3000 },
	{ item = "wbody|WEAPON_SWITCHBLADE", quantidade = 1, compra = 3000 }, 
	{ item = "wbody|GADGET_PARACHUTE", quantidade = 1, compra = 3000 },
	{ item = "wbody|WEAPON_KNIFE", quantidade = 1, compra = 3000 },
	{ item = "wbody|WEAPON_FLASHLIGHT", quantidade = 1, compra = 3000 }, 
	{ item = "wbody|WEAPON_DAGGER", quantidade = 1, compra = 3000 },
	{ item = "wbody|WEAPON_KNUCKLE", quantidade = 1, compra = 3000 },
	{ item = "wbody|WEAPON_MACHETE", quantidade = 1, compra = 3000 },
	{ item = "wbody|WEAPON_WRENCH", quantidade = 1, compra = 3000 },
	{ item = "wbody|WEAPON_HAMMER", quantidade = 1, compra = 3000 },
	{ item = "wbody|WEAPON_GOLFCLUB", quantidade = 1, compra = 3000 },
	{ item = "wbody|WEAPON_CROWBAR", quantidade = 1, compra = 3000 },
	{ item = "wbody|WEAPON_HATCHET", quantidade = 1, compra = 3000 },
	{ item = "wbody|WEAPON_BAT", quantidade = 1, compra = 3000 },
	{ item = "wbody|WEAPON_BOTTLE", quantidade = 1, compra = 3000 },
	{ item = "wbody|WEAPON_POOLCUE", quantidade = 1, compra = 3000 },
	{ item = "wbody|WEAPON_STONE_HATCHET", quantidade = 1, compra = 3000 },
	{ item = "compattach", quantidade = 1, compra = 21000 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
--[ COMPRAR ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("ammunation-comprar")
AddEventHandler("ammunation-comprar",function(item)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		for k,v in pairs(valores) do
			if item == v.item then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(v.item)*v.quantidade <= vRP.getInventoryMaxWeight(user_id) then
					if vRP.tryFullPayment(user_id,parseInt(v.compra)) then
						vRP.giveInventoryItem(user_id,v.item,parseInt(v.quantidade))
						TriggerClientEvent("Notify",source,"sucesso","Sucesso","Comprou <b>"..parseInt(v.quantidade).."x "..vRP.itemNameList(v.item).."</b> por <b>$"..vRP.format(parseInt(v.compra)).." dólares</b>.")
					else
						TriggerClientEvent("Notify",source,"negado","Negado","Dinheiro insuficiente.")
					end
				else
					TriggerClientEvent("Notify",source,"negado","Negado","Espaço insuficiente.")
				end
			end
		end
	end
end)