local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
func = Tunnel.getInterface("vrp_notifypush")

src = {}
Tunnel.bindInterface("vrp_hud",src)
local cachehud = {}
local sBuffer = {}
local vBuffer = {}
local CintoSeguranca = false
local ExNoCarro = false
local hour = nil
local minute = nil
local street = ""
local vehicleSignalIndicator = 'off'
local farol = "off"
local rua = ""
local carroLigado = true
local running = false
local engine = 0
local marcha = 0
local fuel = 0
inCar = false

Citizen.CreateThread(function()
	while true do
		local sleep = 500
		local ped = PlayerPedId()
		inCar = IsPedInAnyVehicle(ped, false)
		if inCar then 
				running = GetIsVehicleEngineRunning(vehicle)
				if running then
					carroLigado = true;				
				else 
					carroLigado = false;
				end
				if running ~= cachehud.running then
				SendNUIMessage({ action = 'setMotor', id = 'motor', value = carroLigado})
				cachehud.running = running	
				end
			sleep = 5
			vehicle = GetVehiclePedIsIn(ped, false)
			
			local speed = math.ceil(GetEntitySpeed(vehicle) * 3.605936)
			local _,lights,highlights = GetVehicleLightsState(vehicle)
			marcha = GetVehicleCurrentGear(vehicle)
			fuel = GetVehicleFuelLevel(vehicle)
			engine = GetVehicleEngineHealth(vehicle)
			
			if lights == 1 and highlights == 0 then 
				farol = "normal"
			elseif (lights == 1 and highlights == 1) or (lights == 0 and highlights == 1) then 
				farol = "alto"
			elseif lights == 0 then
				farol = "off"
			end
			
			if marcha == 0 and speed > 0 then 
				marcha = "R" 
			elseif marcha == 0 and speed < 2 then 
				marcha = "N" 
			end

			rpm = GetVehicleCurrentRpm(vehicle)
			rpm = math.ceil(rpm * 10000, 2)
			vehicleNailRpm = 280 - math.ceil( math.ceil((rpm-2000) * 140) / 10000)

			if carroLigado ~= cachehud.carroLigado then
				cachehud.carroLigado = carroLigado	
			SendNUIMessage({ action = 'setMotor', id = 'motor', value = carroLigado})
			end
			if marcha ~= cachehud.marcha then
				cachehud.marcha = marcha	
			SendNUIMessage({ action = 'setMarcha', id = 'marcha', value = marcha})	
			end
			if speed ~= cachehud.speed then
				cachehud.speed = speed	
			SendNUIMessage({ action = 'setSpeed', id = 'speed', value = speed})	
			end
			if engine ~= cachehud.engine then
				cachehud.engine = engine	
			SendNUIMessage({ action = 'setDurability', id = 'durability', value = engine})
			end
			if fuel ~= cachehud.fuel then
				cachehud.fuel = fuel
			SendNUIMessage({ action = 'setFuel', id = 'fuel', value = fuel})	
			end
			if farol ~= cachehud.farol then
				cachehud.farol = farol
			SendNUIMessage({ action = 'setLight', id = 'lights', value = farol})
			end
			
			local car = GetVehiclePedIsIn(ped)

			if car ~= 0  then
				if CintoSeguranca then
					SetPedConfigFlag(PlayerPedId(), 32, false)
					DisableControlAction(0,75)
				else
					SetPedConfigFlag(PlayerPedId(), 32, true)
				end
			end
		end
		Citizen.Wait(sleep)	
	end
end)

RegisterKeyMapping("porcinto","Cinto","keyboard","g")
RegisterCommand("porcinto",function()
	if inCar then
		if CintoSeguranca then
			TriggerEvent("vrp_sound:source","unbelt",0.5)
			CintoSeguranca = false
		else
			TriggerEvent("vrp_sound:source","belt",0.5)
			CintoSeguranca = true
		end
		SendNUIMessage({ action = 'setCinto', id = 'cinto', value = CintoSeguranca})
	end
end)

RegisterKeyMapping("desligarMotor","Desligar Carro","keyboard","z")
RegisterCommand("desligarMotor",function()
	running = Citizen.InvokeNative(0xAE31E7DF9B5B132E,vehicle)
	if running then
		carroLigado = false;				
	else 
		carroLigado = true;
	end
	SendNUIMessage({ action = 'setMotor', id = 'motor', value = carroLigado})
end)


AddEventHandler("hud:channel", function(_channel) 
	SendNUIMessage({action = 'hudChannel',value = _channel}) 
end)

RegisterNetEvent("pma-voice:setTalkingMode")
AddEventHandler("pma-voice:setTalkingMode", function(_mode) 
	SendNUIMessage({ action = 'hudMode',value = _mode })
 end)

local shownui = true
RegisterCommand("hud",function(source,args)
	shownui = not shownui
end)

RegisterNetEvent("status:celular")
AddEventHandler("status:celular",function(status)
	shownui = not status
end)

RegisterNetEvent("hudActived")
AddEventHandler("hudActived",function(status)
	shownui = status
end)

Citizen.CreateThread(function()
	Wait(1000)
	SendNUIMessage({ action = 'hudMode',value = 2 })
	while true do
			local ped = PlayerPedId()
			local vida = math.ceil((100 * ((GetEntityHealth(ped) - 100) / (GetEntityMaxHealth(ped) - 100))))
			local armour = GetPedArmour(ped)
			local coords = GetEntityCoords(ped)
			local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
			hours = GetClockHours()
			minutes = GetClockMinutes()

			if hours <= 9 then
				hours = "0"..hours
			end

			if minutes <= 9 then
				minutes = "0"..minutes
			end
			
			if streetName ~= cachehud.streetName then
				cachehud.streetName = streetName
			SendNUIMessage({ action = 'setLocation', id = 'location', value = streetName})
			end
			if vida ~= cachehud.vida then
				cachehud.vida = vida
			SendNUIMessage({ action = 'setHealth', id = 'health', value = vida})
			end
			if armour ~= cachehud.armour then
				cachehud.armour = armour
			SendNUIMessage({ action = 'setArmour', id = 'armour', value = armour})
			end
			if hours ~= cachehud.hours or minutes ~= cachehud.minutes then
				cachehud.hours = hours
				cachehud.minutes = hours
			SendNUIMessage({ action = 'setTime', id = 'time', value = hours..":"..minutes })
			end
			
			if not IsPedInAnyVehicle(PlayerPedId(), false) then 
				DisplayRadar(false)
				CintoSeguranca = false
				SendNUIMessage({
					action = "update"
				})
			else
				DisplayRadar(true)
				SendNUIMessage({
					action = "inCar"
				})
			end

			SendNUIMessage({ action = 'micColor',value = NetworkIsPlayerTalking(PlayerId()) })
			if IsPauseMenuActive() or  not shownui then
				SendNUIMessage({ action = 'setDisplay',value = false })
			else
				SendNUIMessage({ action = 'setDisplay', value = true })
			end
		Citizen.Wait(500)	
	end
end)

Citizen.CreateThread(function()
    SetFlyThroughWindscreenParams(25.0, 2.0, 15.0, 15.0) 
    SetPedConfigFlag(PlayerPedId(), 32, true)
end)

--[[RegisterNetEvent("progress")
AddEventHandler("progress",function(timer, name)
	SendNUIMessage({ action = 'setProgress', progress = true, value = parseInt(timer) })
end)]]


function Alert(title, message, time, type)
	title = type
	SendNUIMessage({
		action = 'open',
		title = title,
		type = type,
		message = message,
		time = time,
	})
end

RegisterNetEvent('nyo_notify')
AddEventHandler('nyo_notify', function(color, type, title, message, time)
	Alert(title, message, time, type)
end)

-- RegisterCommand("notify", function()
-- 	TriggerEvent("Notify", "sucesso", "oi" )
-- 	TriggerEvent("Notify", "importante", "oi" )
-- 	TriggerEvent("Notify", "negado", "oi" )
-- 	TriggerEvent("Notify", "aviso", "oi")
-- end)

RegisterNetEvent("Notify")
AddEventHandler("Notify",function(title,message,time)
	if time == nil then
		time = 5000
	end
	Alert(title, message, time, title)
end)


Citizen.CreateThread(function()
	SetNuiFocus(false)
	while true do
		DisableControlAction(0,157,false)
		if IsDisabledControlJustPressed(0,157) and func.checkPermission() then
			SendNUIMessage({ action = "showAll" })
		end
		Citizen.Wait(4)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFYPUSH
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterNetEvent("NotifyPush")
-- AddEventHandler("NotifyPush",function(data)
-- 	PlaySoundFrontend(-1,"Event_Message_Purple","GTAO_FM_Events_Soundset",false)
-- 	data.loc = GetStreetNameFromHashKey(GetStreetNameAtCoord(data.x,data.y,data.z))
-- 	SendNUIMessage({ action = "notify", data = data })
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FOCUSON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("focusOn",function()
    SetNuiFocus(true,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FOCUSOFF
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("focusOff",function()
    SetNuiFocus(false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("setWay",function(data)
    SetNewWaypoint(data.x+0.0001,data.y+0.0001)
end)

RegisterCommand("oi", function()
	TriggerEvent("NotifyPush",{ code = 20, title = "Tráfico", text = "Venda de drogas", x = x ,y = y , z = z , rgba = {140,35,35} })
end)
	



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA CLIMATICO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local hora = 12
local minuto = 0

function src.updateClima(h, m)
	hora = h
	minuto = m
end

Citizen.CreateThread(function()
	while true do
		--NetworkOverrideClockTime(tonumber(hora), tonumber(minuto), 0)
		SetWeatherTypeNowPersist("CLEAR")

		Citizen.Wait(1000)
	end
end)