-----------------------------------------------------------------------------------------------------------------------------------------
-- DENSITY NPCS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
			
    	SetVehicleDensityMultiplierThisFrame(0.0)
		SetPedDensityMultiplierThisFrame(0.0)
		SetRandomVehicleDensityMultiplierThisFrame(0.0)
		SetParkedVehicleDensityMultiplierThisFrame(0.0)
		SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
		
		local playerPed = GetPlayerPed(-1)
		local pos = GetEntityCoords(playerPed) 
		RemoveVehiclesFromGeneratorsInArea(pos['x'] - 500.0, pos['y'] - 500.0, pos['z'] - 500.0, pos['x'] + 500.0, pos['y'] + 500.0, pos['z'] + 500.0);
    	
		Citizen.Wait(1)
	end

end)

Citizen.CreateThread(function()
	while true do
		SetDiscordAppId(886013439913373698)--Colocar o ID do Dispatch aq
		SetDiscordRichPresenceAsset('cruz')--a logo tem que ser colocada no Dispatch criada no site do discord 
        SetDiscordRichPresenceAssetText('Cruz Commmunity')
        SetDiscordRichPresenceAssetSmall('--')
        SetDiscordRichPresenceAssetSmallText('--')
        SetDiscordRichPresenceAction(1, "Discord", "https://discord.gg/BmN9dWb9Nj")
		Citizen.Wait(60000)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DISPATCH
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	for i = 1,120 do
		EnableDispatchService(i,false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TANK HS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Wait(4)

        SetPedSuffersCriticalHits(PlayerPedId(-1), true)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STAMINA INFINITA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread( function()
    while true do
        Citizen.Wait(0)
        RestorePlayerStamina(PlayerId(), 1.0)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRIFT
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local RusherSleep = 1000
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(PlayerPedId())
		if IsPedInAnyVehicle(ped) then
			local speed = GetEntitySpeed(vehicle)*3.6
			if GetPedInVehicleSeat(vehicle,-1) == ped 
				and (GetEntityModel(vehicle) ~= GetHashKey("coach") 
					and GetEntityModel(vehicle) ~= GetHashKey("bus") 
					and GetEntityModel(vehicle) ~= GetHashKey("taxi") 
					and GetEntityModel(vehicle) ~= GetHashKey("boxville4") 
					and GetEntityModel(vehicle) ~= GetHashKey("trash2") 
					and GetEntityModel(vehicle) ~= GetHashKey("rebel")    
					and GetEntityModel(vehicle) ~= GetHashKey("paramedicoambu")) then
					RusherSleep = 100
					if speed <= 100.0 then
					if IsControlPressed(1,21) then
						SetVehicleReduceGrip(vehicle,true)
					else
						SetVehicleReduceGrip(vehicle,false)
					end
				end    
			end
		end
		Citizen.Wait(RusherSleep)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DESABILITAR X NA MOTO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local timeDistance = 500
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped) then
            local vehicle = GetVehiclePedIsIn(ped)
            if (GetPedInVehicleSeat(vehicle, -1) == ped or GetPedInVehicleSeat(vehicle, 0) == ped) and GetVehicleClass(vehicle) == 8 then
                timeDistance = 4
                DisableControlAction(0, 345, true)
            end
        end
        Citizen.Wait(timeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DESABILITAR A CORONHADA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        if IsPedArmed(ped,6) then
            DisableControlAction(0,140,true)
            DisableControlAction(0,141,true)
            DisableControlAction(0,142,true)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DESABILITAR AUTO-CAPACETE NA MOTO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread( function()
	while true do
		Citizen.Wait(5)  
		local veh = GetVehiclePedIsUsing(PlayerPedId())
		if veh ~= 0 then 
			SetPedConfigFlag(PlayerPedId(),35,false) 
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DESABILITAR O Q
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        if health >= 101 then
        	DisableControlAction(0,44,true)
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = {
	{ -29.99,-1105.07,26.43,225,4,"Concessionária",0.5 },
	{ 597.3, -1.74, 117.24,60,3,"Departamento Policial",0.5 },
    { 1851.45,3686.71,34.26,60,3,"Departamento Policial",0.5 },
    { -448.18,6011.68,31.71,60,3,"Departamento Policial",0.5 },
	{ 317.25,2623.14,44.46,289,4,"Garagem",0.4 },
	{ -773.34,5598.15,33.60,289,4,"Garagem",0.4 },
	{ 596.40,90.65,93.12,289,4,"Garagem",0.4 },
	{ -340.76,265.97,85.67,289,4,"Garagem",0.4 },
	{ -2030.01,-465.97,11.60,289,4,"Garagem",0.4 },
	{ -1184.92,-1510.00,4.64,289,4,"Garagem",0.4 },
	{ -73.44,-2004.99,18.27,289,4,"Garagem",0.4 },
	{ -348.88,-874.02,31.31,289,4,"Garagem",0.4 },
	{ 67.74,12.27,69.21,289,4,"Garagem",0.4 },
	{ 361.90,297.81,103.88,289,4,"Garagem",0.4 },
	{ 1156.90,-453.73,66.98,289,4,"Garagem",0.4 },
	{ -102.21,6345.18,31.57,289,4,"Garagem",0.4 },
	{ -830.74,-420.58,36.77,289,4,"Garagem",0.4 },
	{ 1990.01,3052.29,47.22,385,5,"Yellow Jack",0.5 },
	{ 128.96,-1299.03,29.24,121,7,"Vanilla Unicorn",0.5 },
	{ 265.05,-1262.65,29.3,361,41,"Posto de Gasolina",0.4 },
	{ 819.02,-1027.96,26.41,361,41,"Posto de Gasolina",0.4 },
	{ 1208.61,-1402.43,35.23,361,41,"Posto de Gasolina",0.4 },
	{ 1181.48,-330.26,69.32,361,41,"Posto de Gasolina",0.4 },
	{ 621.01,268.68,103.09,361,41,"Posto de Gasolina",0.4 },
	{ 2581.09,361.79,108.47,361,41,"Posto de Gasolina",0.4 },
	{ 175.08,-1562.12,29.27,361,41,"Posto de Gasolina",0.4 },
	{ -319.76,-1471.63,30.55,361,41,"Posto de Gasolina",0.4 },
	{ 1782.33,3328.46,41.26,361,41,"Posto de Gasolina",0.4 },
	{ 49.42,2778.8,58.05,361,41,"Posto de Gasolina",0.4 },
	{ 264.09,2606.56,44.99,361,41,"Posto de Gasolina",0.4 },
	{ 1039.38,2671.28,39.56,361,41,"Posto de Gasolina",0.4 },
	{ 1207.4,2659.93,37.9,361,41,"Posto de Gasolina",0.4 },
	{ 2539.19,2594.47,37.95,361,41,"Posto de Gasolina",0.4 },
	{ 2679.95,3264.18,55.25,361,41,"Posto de Gasolina",0.4 },
	{ 2005.03,3774.43,32.41,361,41,"Posto de Gasolina",0.4 },
	{ 1687.07,4929.53,42.08,361,41,"Posto de Gasolina",0.4 },
	{ 1701.53,6415.99,32.77,361,41,"Posto de Gasolina",0.4 },
	{ 180.1,6602.88,31.87,361,41,"Posto de Gasolina",0.4 },
	{ -94.46,6419.59,31.48,361,41,"Posto de Gasolina",0.4 },
	{ -2555.17,2334.23,33.08,361,41,"Posto de Gasolina",0.4 },
	{ -1800.09,803.54,138.72,361,41,"Posto de Gasolina",0.4 },
	{ -1437.0,-276.8,46.21,361,41,"Posto de Gasolina",0.4 },
	{ -2096.3,-320.17,13.17,361,41,"Posto de Gasolina",0.4 },
	{ -724.56,-935.97,19.22,361,41,"Posto de Gasolina",0.4 },
	{ -525.26,-1211.19,18.19,361,41,"Posto de Gasolina",0.4 },
	{ -70.96,-1762.21,29.54,361,41,"Posto de Gasolina",0.4 },
	{ 46.73,-1749.55,29.64,78,30,"Mega Mall",0.4 },
	{ -576.24, 276.63, 94.73,267,2,"Emprego | Entregador",0.4 },
	{ -470.8,-1718.2,18.69,171,2,"Emprego | Lixeiro",0.5 },
	{ 455.15,-601.45,28.53,513,2,"Emprego | Motoristas",0.5 },
}

Citizen.CreateThread(function()
	for _,v in pairs(blips) do
		local blip = AddBlipForCoord(v[1],v[2],v[3])
		SetBlipSprite(blip,v[4])
		SetBlipAsShortRange(blip,true)
		SetBlipColour(blip,v[5])
		SetBlipScale(blip,v[7])
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v[6])
		EndTextCommandSetBlipName(blip)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVER ARMA ABAIXO DE 40MPH DENTRO DO CARRO 
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local ORTiming = 500
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped) then
            -- BLOQUEIA QUALQUER ARMA DE ATIRAR
            SetPlayerCanDoDriveBy(PlayerId(),false)

            local vehicle = GetVehiclePedIsIn(ped)
            local speed = GetEntitySpeed(vehicle)*3.6

            -- CONDIÇÃO P2
            if GetPedInVehicleSeat(vehicle,0) == ped then
                if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_STUNGUN") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_UNARMED") then
                    SetPlayerCanDoDriveBy(PlayerId(),true)
                end
            elseif GetPedInVehicleSeat(vehicle,-1) == ped then
                if speed <= 0 then
				ORTiming = 4
                    if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_STUNGUN") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_UNARMED") then
                        SetPlayerCanDoDriveBy(PlayerId(),true)
                    end
                end
            else
                if IsVehicleModel(GetVehiclePedIsUsing(ped),GetHashKey("polmav")) then
                    SetPlayerCanDoDriveBy(PlayerId(),true)
                end
            end
        end
		Citizen.Wait(ORTiming)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COOLDOWN BUNNYHOP
-----------------------------------------------------------------------------------------------------------------------------------------
local bunnyhop = 0
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        if bunnyhop > 0 then
            bunnyhop = bunnyhop - 5
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        if IsPedJumping(ped) and bunnyhop <= 0 then
            bunnyhop = 5
        end
        if bunnyhop > 0 then
            DisableControlAction(0,22,true)
        end
        Citizen.Wait(1000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DESATIVA O ROUBO DO VEÍCULO SEGURANDO F [ CAR JACKING ]
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
    local timeDistance = 500
    local ped = PlayerPedId()
	if IsPedJacking(ped) then
		timeDistance = 4
      local veh = GetVehiclePedIsIn(ped)
      SetPedIntoVehicle(ped, veh, 0)
      ClearPedTasks(ped)
		end
		Citizen.Wait(timeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DAMAGE WALK MODE
-----------------------------------------------------------------------------------------------------------------------------------------
local hurt = false
Citizen.CreateThread(function()
    while true do
        local delayThread = 500
        local ped = PlayerPedId()
        if not IsEntityInWater(ped) then
            if GetEntityHealth(ped) <= 199 then
                delayThread = 5
                setHurt()
            elseif hurt and GetEntityHealth(ped) > 200 then
                setNotHurt()
            end
        end
        Citizen.Wait(delayThread)
    end
end)

function setHurt()
    hurt = true
    RequestAnimSet("move_m@injured")
    SetPedMovementClipset(PlayerPedId(),"move_m@injured",true)
    SetPlayerHealthRechargeMultiplier(PlayerId(),0.0)
    DisableControlAction(0,21) 
    DisableControlAction(0,22)
end

function setNotHurt()
    hurt = false
    SetPlayerHealthRechargeMultiplier(PlayerId(),0.0)
    ResetPedMovementClipset(PlayerPedId())
    ResetPedWeaponMovementClipset(PlayerPedId())
    ResetPedStrafeClipset(PlayerPedId())
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DWTEXT
-----------------------------------------------------------------------------------------------------------------------------------------
function dwText(text,height)
	SetTextFont(4)
	SetTextScale(0.50,0.50)
	SetTextColour(255,255,255,180)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.5,height)
end