-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("vrp_chest",src)
vSERVER = Tunnel.getInterface("vrp_chest")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local chestTimer = 0
local chestOpen = ""
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTFOCUS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("chestClose",function(data)
	SetNuiFocus(false,false)
	SendNUIMessage({ action = "hideMenu" })
	vSERVER.chestClose(tostring(chestOpen))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("takeItem",function(data)
	if chestTimer <= 0 then
		chestTimer = 5
		TriggerEvent('cancelando', true)
		vRP.playAnim(false, {{"amb@world_human_security_shine_torch@male@exit", "exit"}}, false)
		vSERVER.takeItem(tostring(chestOpen),data.item,data.amount)
		Wait(1000)
		TriggerEvent('cancelando', false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("storeItem",function(data)
	if chestTimer <= 0 then
		chestTimer = 5
		TriggerEvent('cancelando', true)
		vRP.playAnim(false,{{"mp_common","givetake1_a"}},false)
		vSERVER.storeItem(tostring(chestOpen),data.item,data.amount)
		Wait(1000)
		TriggerEvent('cancelando', false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- AUTO-UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Creative:UpdateChest")
AddEventHandler("Creative:UpdateChest",function(action)
	SendNUIMessage({ action = action })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestChest",function(data,cb)
	local inventario,inventario2,peso,maxpeso,peso2,maxpeso2 = vSERVER.openChest(tostring(chestOpen))
	if inventario then
		cb({ inventario = inventario, inventario2 = inventario2, peso = peso, maxpeso = maxpeso, peso2 = peso2, maxpeso2 = maxpeso2 })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCALIDADE DOS BAÚS
-----------------------------------------------------------------------------------------------------------------------------------------
local chest = {
	{ "Policia",626.91, -26.41,82.78 },

	{ "Crips",1268.69,-1710.81,54.78 },
	{ "Bloods",-1081.28,-1677.85,4.58 },

	{ "Ballas",124.42,-1949.67,20.72 },
	{ "Vagos",371.45,-2040.63,22.2 },
	{ "Groove",-150.49,-1625.45,36.84 },

	{ "Native",1552.97, 3514.54, 36.05 },
	{ "Driftking",-445.03, -2184.25, 10.52 },

	{ "LifeInvader",-1051.5,-232.77,44.03 },
	{ "Bahamas",-1381.59,-615.39,31.5 },

	{ "Triade",563.43,-3126.93,18.77 },
	{ "siciliana",1074.21,-2010.37,32.09 },

}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)
		if chestTimer > 0 then
			chestTimer = chestTimer - 3
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("chest",function(source,args)
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped))
	for k,v in pairs(chest) do
		local distance = Vdist(x,y,z,v[2],v[3],v[4])
		if distance <= 2.0 and chestTimer <= 0 then
			chestTimer = 3
			if vSERVER.checkIntPermissions(v[1]) then
				TriggerEvent('Notify','sucesso','Abrindo baú...')
				SetNuiFocus(true,true)
				SendNUIMessage({ action = "showMenu" })
				chestOpen = v[1]
			end
		end
	end
end)
