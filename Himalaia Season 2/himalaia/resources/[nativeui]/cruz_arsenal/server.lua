local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("cruz_arsenal",src)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkPermissao()
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"policia.permissao") then
        return true
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('vrp_arsenal:Radio')
AddEventHandler('vrp_arsenal:Radio', function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"policia.permissao") then
			vRP.giveInventoryItem(user_id,"radio",1)
			TriggerClientEvent("Notify",source,"sucesso","Você pegou radio 1x.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARSENAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('vrp_arsenal:KIT')
AddEventHandler('vrp_arsenal:KIT', function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"policia.permissao") then
			vRPclient.giveWeapons(source,{["WEAPON_STUNGUN"] = { ammo = 0 }})
			vRPclient.giveWeapons(source,{["WEAPON_FLASHLIGHT"] = { ammo = 0 }})
			vRPclient.giveWeapons(source,{["WEAPON_NIGHTSTICK"] = { ammo = 0 }})
			vRPclient.giveWeapons(source,{["WEAPON_FIREEXTINGUISHER"] = { ammo = 0 }})
			TriggerClientEvent("Notify",source,"sucesso","Você pegou Kit Basico.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARMAS -- Cruz Communnity
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('vrp_arsenal:GLOCK')
AddEventHandler('vrp_arsenal:GLOCK', function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"policia.permissao") then
			vRPclient.giveWeapons(source,{["WEAPON_COMBATPISTOL"] = { ammo = 250 }})
		end
	end
end)

RegisterServerEvent('vrp_arsenal:five')
AddEventHandler('vrp_arsenal:five', function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"policia.permissao") then
			vRPclient.giveWeapons(source,{["WEAPON_PISTOL_MK2"] = { ammo = 250 }})
		end
	end
end)

RegisterServerEvent('vrp_arsenal:SIG')
AddEventHandler('vrp_arsenal:SIG', function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"policia.permissao") then
			vRPclient.giveWeapons(source,{["WEAPON_COMBATPDW"] = { ammo = 250 }})
		end
	end
end)

RegisterServerEvent('vrp_arsenal:MP5')
AddEventHandler('vrp_arsenal:MP5', function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"policia.permissao") then
			vRPclient.giveWeapons(source,{["WEAPON_SMG"] = { ammo = 250 }})
		end
	end
end)

RegisterServerEvent('vrp_arsenal:M4A1')
AddEventHandler('vrp_arsenal:M4A1', function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"policia.permissao") then
			vRPclient.giveWeapons(source,{["WEAPON_CARBINERIFLE"] = { ammo = 250 }})
		end
	end
end)

RegisterServerEvent('vrp_arsenal:DOZE')
AddEventHandler('vrp_arsenal:DOZE', function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"policia.permissao") then
			vRPclient.giveWeapons(source,{["WEAPON_PUMPSHOTGUN"] = { ammo = 250 }})
		end
	end
end)

