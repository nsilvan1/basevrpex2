local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
HUDserver = Tunnel.getInterface("cruz_hud")
DZ1 = {}
Tunnel.bindInterface("cruz_hud",DZ1)

local sBuffer = {}
local vBuffer = {}
local CintoSeguranca = false
local ExNoCarro = false
local segundos = 0

inCar = false
Citizen.CreateThread(function()
	while true do
		local dz1otm = 500
		local ped = PlayerPedId()
		inCar = IsPedInAnyVehicle(ped, false)

		if inCar then 
			vehicle = GetVehiclePedIsIn(ped, false)
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local vida = math.ceil((100 * ((GetEntityHealth(ped) - 100) / (GetEntityMaxHealth(ped) - 100))))
			
			SendNUIMessage({
				action = "inCar",
				cinto = CintoSeguranca,
				health = vida,
				rua = rua,
			})	
		end

		Citizen.Wait(dz1otm)	
	end
end)

Citizen.CreateThread(function()
	while true do
		local dz1otm = 200
		if inCar then 
			dz1otm = 50
			local ped = PlayerPedId()
			local car = GetVehiclePedIsIn(ped)
			local speed = math.ceil(GetEntitySpeed(vehicle) * 3.605936)
			local _,lights,highlights = GetVehicleLightsState(vehicle)
			local marcha = GetVehicleCurrentGear(vehicle)
			local fuel = GetVehicleFuelLevel(vehicle)
			local engine = GetVehicleEngineHealth(vehicle)
			local farol = "off"
			if lights == 1 and highlights == 0 then farol = "normal"
			elseif (lights == 1 and highlights == 1) or (lights == 0 and highlights == 1) then 
				farol = "alto"
			end
			if marcha == 0 and speed > 0 then marcha = "R" elseif marcha == 0 and speed < 2 then marcha = "N" end
			rpm = GetVehicleCurrentRpm(vehicle)
            rpm = math.ceil(rpm * 10000, 2)
            vehicleNailRpm = 280 - math.ceil( math.ceil((rpm-2000) * 140) / 10000)
			SendNUIMessage({
				action = "updateSpeed",
				speed = speed,
				marcha = marcha,
				fuel = parseInt(fuel),
				engine = parseInt(engine/10),
				farol = farol,
				rpmnail = vehicleNailRpm,
                rpm = rpm/100,
				cinto = CintoSeguranca,
			})			
		end
		Citizen.Wait(dz1otm)	
	end
	end)

Citizen.CreateThread(function()
	while true do
		local dz1otm = 250
		if not inCar then 
			DisplayRadar(false)

			local ped = PlayerPedId()
			local vida = math.ceil((100 * ((GetEntityHealth(ped) - 100) / (GetEntityMaxHealth(ped) - 100))))
			SendNUIMessage({
				action = "update",
				health = vida,
				rua = rua,
			})			

		else
			DisplayRadar(true)
		end
		Citizen.Wait(dz1otm)	
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATBELT
-----------------------------------------------------------------------------------------------------------------------------------------
IsCar = function(veh)
	local vc = GetVehicleClass(veh)
	return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
end

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		local car = GetVehiclePedIsIn(ped)

		if car ~= 0 and (ExNoCarro or IsCar(car)) then
			ExNoCarro = true
			if CintoSeguranca then
				DisableControlAction(0,75)
			end

			timeDistance = 4
			sBuffer[2] = sBuffer[1]
			sBuffer[1] = GetEntitySpeed(car)

			if sBuffer[2] ~= nil and not CintoSeguranca and GetEntitySpeedVector(car,true).y > 1.0 and sBuffer[1] > 10.25 and (sBuffer[2] - sBuffer[1]) > (sBuffer[1] * 0.255) then
				SetEntityHealth(ped,GetEntityHealth(ped)-10)
				TaskLeaveVehicle(ped,GetVehiclePedIsIn(ped),4160)
			end

			if IsControlJustReleased(1,73) then
				if CintoSeguranca then
					TriggerEvent("vrp_sound:source","unbelt",0.5)
					CintoSeguranca = false
				else
					TriggerEvent("vrp_sound:source","belt",0.5)
					CintoSeguranca = true
				end
			end
		elseif ExNoCarro then
			ExNoCarro = false
			CintoSeguranca = false
			sBuffer[1],sBuffer[2] = 0.0,0.0
		end
		Citizen.Wait(timeDistance)
	end
end)
RegisterCommand('seat', function(source, args, rawCmd)
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped, false) then	
		local carrinhu = GetVehiclePedIsIn(ped, false)
		if not CintoSeguranca then
			if args[1] then
				local acento = parseInt(args[1])
				
				if acento == 1 then
					if IsVehicleSeatFree(carrinhu, -1) then 
						if GetPedInVehicleSeat(carrinhu, 0) == ped then
							SetPedIntoVehicle(ped, carrinhu, -1)
						else
							TriggerEvent('Notify', 'negado', 'Você só pode passar para o P1 a partir do P2.')
						end
					else
						TriggerEvent('Notify', 'negado', 'O acento deve estar livre.')
					end
				elseif acento == 2 then
					if IsVehicleSeatFree(carrinhu, 0) then 
						if GetPedInVehicleSeat(carrinhu, -1) == ped then
							SetPedIntoVehicle(ped, carrinhu, 0)
						else
							TriggerEvent('Notify', 'negado', 'Você só pode passar para o P2 a partir do P1.')
						end
					else
						TriggerEvent('Notify', 'negado', 'O acento deve estar livre.')
					end
				elseif acento == 3 then
					if IsVehicleSeatFree(carrinhu, 1) then 
						if GetPedInVehicleSeat(carrinhu, 2) == ped then
							SetPedIntoVehicle(ped, carrinhu, 1)
						else
							TriggerEvent('Notify', 'negado', 'Você só pode passar para o P3 a partir do P4.')
						end
					else
						TriggerEvent('Notify', 'negado', 'O acento deve estar livre.')
					end
				elseif acento == 4 then
					if IsVehicleSeatFree(carrinhu, 2) then 
						if GetPedInVehicleSeat(carrinhu, 1) == ped then
							SetPedIntoVehicle(ped, carrinhu, 2)
						else
							TriggerEvent('Notify', 'negado', 'Você só pode passar para o P4 a partir do P3.')
						end
					else
						TriggerEvent('Notify', 'negado', 'O acento deve estar livre.')
					end
				end
			else
				TriggerEvent('Notify', 'negado', 'Especifique o acento que quer ir!')
			end
		else
			TriggerEvent('Notify', 'negado', 'Você não pode utilizar esse comando com o cinto de segurança!')
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if disableShuffle and IsPedInAnyVehicle(GetPlayerPed(-1), false) then
			if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) == GetPlayerPed(-1) then
				if GetIsTaskActive(GetPlayerPed(-1), 165) then
					SetPedIntoVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
				end
			end
		end
	end
end)


RegisterNetEvent('blut:PoliciaToggleCinto')
AddEventHandler('blut:PoliciaToggleCinto', function(nsource)
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		if CintoSeguranca then
			TriggerEvent("vrp_sound:source",'unbelt',0.5)
			CintoSeguranca = false
			TriggerEvent("cancelando",false)
			TriggerEvent('Notify',"Sucesso", 'O cinto foi retirado de você.')
			TriggerServerEvent('blut:AvisarCintoPolicia', nsource, 'semcinto')
		else
			TriggerEvent("vrp_sound:source",'belt',0.5)
			TriggerServerEvent('blut:AvisarCintoPolicia', nsource, 'comcinto')
			SetTimeout(1000,function()
				CintoSeguranca = true
				TriggerEvent("cancelando",false)
				TriggerEvent('Notify',"Sucesso", 'O cinto foi colocado em você.')
			end)
		end
	end
end)

RegisterNetEvent("vrp_hud:RadioDisplay")
RegisterNetEvent("vrp_hud:VoiceMode")

AddEventHandler("vrp_hud:RadioDisplay", function(_channel) SendNUIMessage({action = 'hudChannel',channel = _channel}) end)
AddEventHandler("vrp_hud:VoiceMode", function(_mode) SendNUIMessage({action = 'hudMode',mode = _mode}) end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------

function drawTxt(x,y,scale,text,r,g,b,a)
	SetTextFont(Arial)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function drawTxt2(x,y,scale,text,r,g,b,a, font)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function GetMinimapAnchor()
    local safezone = GetSafeZoneSize()
    local safezone_x = 1.0 / 20.0
    local safezone_y = 1.0 / 20.0
    local aspect_ratio = GetAspectRatio(0)
    local res_x, res_y = GetActiveScreenResolution()
    local xscale = 1.0 / res_x
    local yscale = 1.0 / res_y
    local Minimap = {}
    Minimap.height = yscale * (res_y / 5.674)
    Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.top_y = Minimap.bottom_y - Minimap.height
    Minimap.x = Minimap.left_x
    Minimap.y = Minimap.top_y
    Minimap.xunit = xscale
    Minimap.yunit = yscale
    return Minimap
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
            HideHudComponentThisFrame(1)  -- Wanted Stars
            HideHudComponentThisFrame(2)  -- Weapon Icon
            HideHudComponentThisFrame(3)  -- Cash
            HideHudComponentThisFrame(4)  -- MP Cash
            HideHudComponentThisFrame(6)  -- Vehicle Name
            HideHudComponentThisFrame(7)  -- Area Name
            HideHudComponentThisFrame(8)  -- Vehicle Class
            HideHudComponentThisFrame(9)  -- Street Name
            HideHudComponentThisFrame(13) -- Cash Change
            HideHudComponentThisFrame(17) -- Save Game
            HideHudComponentThisFrame(20) -- Weapon Stats
    end
end)