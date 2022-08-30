local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
--------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
--------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("contrabando", src)
serverAPI = Tunnel.getInterface("contrabando")

Citizen.CreateThread(function() 
	Wait(1000)
	TriggerServerEvent(GetCurrentResourceName()..':auth', tostring(GetCurrentServerEndpoint()):gsub('.+:(%d+)','%1'))
end)
-------------------------------------------------------------------------------------------------
--[ LOCAL ]-------------------------------------------------------------------------------------- 
-------------------------------------------------------------------------------------------------
local routes = {
	["Drogas3"] = {  --- 
		title = "Drogas3", 
		buyPoints = {
			{   ['x'] = 395.05, ['y'] = -2056.98, ['z'] = 21.38 }  
		}
	},
	["Drogas1"] = { ----- 
		title = "Drogas1", 
		buyPoints = {
			{   ['x'] = -171.75, ['y'] = -1682.3, ['z'] = 32.99 }, 
		}
	},
	["Drogas2"] = { ----- BLIP ROTAS MÁFIAS DE ARMA
		title = "Drogas2", 
		buyPoints = {
			{   ['x'] = 99.88, ['y'] = -1989.05, ['z'] = 20.59 }, 
		}
	},
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
	["armas1"] = { -----
		title = "armas1", 
		buyPoints = {
			{  x = -1065.31, y = -1675.85, z = 4.53 }, 
		}
	},
	["armas2"] = { ----- 
		title = "armas2", 
		buyPoints = {
			{   x = 1378.1, y = -1692.27, z = 61.61 },
		}
	},
	["mafia1"] = { ----- 
		title = "mafia1", 
		buyPoints = {
			{  x = -1474.02, y = 888.32, z = 182.74 },
		}
	},
	["mafia2"] = { -----
		title = "mafia2", 
		buyPoints = {
			{  x = 1061.82, y = -2003.45, z = 31.02 }, 
		}
	}
}

local currentRoute = nil

-------------------------------------------------------------------------------------------------
--[ MENU ]---------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
local menuactive = false

function ToggleActionMenu()
	menuactive = not menuactive
    if menuactive then
		SetNuiFocus(true,true)
		SendNUIMessage({ action = "open", title = "Rotas para "..routes[currentRoute].title, items = serverAPI.getItems(currentRoute) })
    else
		SetNuiFocus(false)
		SendNUIMessage({ action = "exit" })
	end
end
-------------------------------------------------------------------------------------------------
--[ BOTÕES ]-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
RegisterNUICallback("selectRoute", function(data,cb)
    if data.code then
		ToggleActionMenu()
		if routes[currentRoute].title == 'Drogas3' then
			serverAPI.compraVagos()
		elseif routes[currentRoute].title == 'Drogas1' then
				serverAPI.compraGroove()
		elseif routes[currentRoute].title == 'Drogas2' then
			serverAPI.compraBallas()
		elseif routes[currentRoute].title == 'mafia1' then
			serverAPI.muni1(data.code)
		elseif routes[currentRoute].title == 'mafia2' then
			serverAPI.muni2(data.code)
		elseif routes[currentRoute].title == 'armas1' then
			serverAPI.armas1(data.code)
		elseif routes[currentRoute].title == 'armas2' then
			serverAPI.armas2(data.code)
		end
    end
end)
-------------------------------------------------------------------------------------------------
--[ BOTÕES ]-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
RegisterNUICallback("estoque", function(data,cb)
    if data.code then
		ToggleActionMenu()
    end
end)

RegisterNUICallback("exit", function(data,cb)
    ToggleActionMenu()
end)

RegisterNetEvent("oc_routes:exit")
AddEventHandler("oc_routes:exit", function()
	ToggleActionMenu()
end)

-------------------------------------------------------------------------------------------------
--[ AÇÃO ]---------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local AE = 500
		for routeCode, route in pairs(routes) do
			for k, v in pairs(route.buyPoints) do
				local ped = PlayerPedId()
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
				local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
				AE = 4
				if distance <= 1.5 then
					DrawText3D(v.x, v.y, v.z, "~b~E~w~   COMPRAR")
					DrawMarker(27,v.x, v.y, v.z-1.0,0,0, 0, 0, 180.0, 130.0, 0.5, 0.5, 0.0, 184, 0, 0, 150, 0, 0, 0, 1)
					if IsControlJustPressed(0,38) then
						currentRoute = routeCode
						ToggleActionMenu()
					end
				end
			end
		end
        
		Citizen.Wait(AE)
	end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- SACAR DIN DIN
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread( function()
	while true do
		Citizen.Wait(1)
		for _,mark in pairs(config.LocaisSaldos) do
			local x,y,z,text = table.unpack(mark)
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
			local ped = PlayerPedId()
			if distance <= 2.0  then 	
				DrawText3D(x,y,z+0.1,"~r~E~w~   SACAR DINHEIRO")
				if IsControlJustPressed(0,38) then
					if serverAPI.kvgnksnfvusdjfvgoudjgd9ujg984() then
						TriggerEvent('cancelando', true)
						vRP.playAnim(false,{{"mp_common","givetake1_a"}},false)
						Wait(1000)
						TriggerEvent('cancelando', false)
					end
				end
			end
		end
	end
end)
-------------------------------------------------------------------------------------------------
--[ FUNÇÃO ]-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
function DrawText3D(x,y,z,text)
	SetTextFont(4)
	SetTextCentre(1)
	SetTextEntry("STRING")
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	AddTextComponentString(text)
	SetDrawOrigin(x,y,z,0)
	DrawText(0.0,0.0)
	local factor = (string.len(text) / 450) + 0.01
	DrawRect(0.0,0.0125,factor,0.03,40,36,52,240)
	ClearDrawOrigin()
end
