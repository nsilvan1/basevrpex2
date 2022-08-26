----------------------------------------------------------------------------------------------------------------------------------------
-- /NPC CONTROL
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
    Citizen.Wait(0)
    SetVehicleDensityMultiplierThisFrame(0.2) --Seleciona densidade do trafico
    SetPedDensityMultiplierThisFrame(0.1) --seleciona a densidade de Npc
    SetRandomVehicleDensityMultiplierThisFrame(0.2) --seleciona a densidade de viaturas estacionadas a andar etc
    SetParkedVehicleDensityMultiplierThisFrame(0.5) --seleciona a densidade de viaturas estacionadas
    SetScenarioPedDensityMultiplierThisFrame(0.2, 0.2) --seleciona a densidade de Npc a andar pela cidade
    SetGarbageTrucks(true) --Desactiva os Camioes do Lixo de dar Spawn Aleatoriamente
    SetRandomBoats(false) --Desactiva os Barcos de dar Spawn na agua
    SetCreateRandomCops(false) --Desactiva a Policia a andar pela cidade
    SetCreateRandomCopsNotOnScenarios(false) --Para o Spanw Aleatorio de Policias Fora do Cenario
    SetCreateRandomCopsOnScenarios(false) --Para o Spanw Aleatorio de Policias no Cenario
    DisablePlayerVehicleRewards(PlayerId()) --Nao mexer --> Impossibilita que os players possam ganhar armas nas viaturas da policia e ems
    RemoveAllPickupsOfType(0xDF711959) --Carbine rifle
    RemoveAllPickupsOfType(0xF9AFB48F) --Pistol
    RemoveAllPickupsOfType(0xA9355DCD) --Pumpshotgun
    local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
    ClearAreaOfVehicles(x, y, z, 1000, false, false, false, false, false)
    RemoveVehiclesFromGeneratorsInArea(x - 500.0, y - 500.0, z - 500.0, x + 500.0, y + 500.0, z + 500.0);
    --HideHudComponentThisFrame(14)-- Remover Mira
    RemoveMultiplayerHudCash(0x968F270E39141ECA) -- Remove o Dinheiro Original do Gta
    RemoveMultiplayerBankCash(0xC7C6789AA1CFEDD0) --Remove o Dinheiro Original do Gta Que esta no Banco
    for i = 1, 15 do
    EnableDispatchService(i, false)-- Disabel Dispatch
      end
    end

end)
-------------------
-- Discord rich
-------------------
Citizen.CreateThread(function()
	while true do
		SetDiscordAppId(936250353450627102)--Colocar o ID do Dispatch aq
		SetDiscordRichPresenceAsset('logo')--a logo tem que ser colocada no Dispatch criada no site do discord 
        SetDiscordRichPresenceAssetText('WIPE HIMALAIA')
        SetDiscordRichPresenceAssetSmall('--')
        SetDiscordRichPresenceAssetSmallText('--')
        SetDiscordRichPresenceAction(1, "Discord", "https://discord.gg/BRhMcVGRWT")
		Citizen.Wait(60000)
	end
end)
-------------------
-- Tirar som ambiente do gta
-------------------
CreateThread(function()
	while true do
		StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE");
		SetAudioFlag("PoliceScannerDisabled",true);
		Wait(0)
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
	{ ['x'] = 265.64, ['y'] = -1261.30, ['z'] = 29.29, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 819.65, ['y'] = -1028.84, ['z'] = 26.40, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 1208.95, ['y'] = -1402.56, ['z'] = 35.22, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 1181.38, ['y'] = -330.84, ['z'] = 69.31, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 620.84, ['y'] = 269.10, ['z'] = 103.08, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 2581.32, ['y'] = 362.03, ['z'] = 108.46, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 176.63, ['y'] = -1562.02, ['z'] = 29.26, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 176.63, ['y'] = -1562.02, ['z'] = 29.26, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = -319.29, ['y'] = -1471.71, ['z'] = 30.54, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 1784.32, ['y'] = 3330.55, ['z'] = 41.25, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 49.418, ['y'] = 2778.79, ['z'] = 58.04, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 263.89, ['y'] = 2606.46, ['z'] = 44.98, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 1039.95, ['y'] = 2671.13, ['z'] = 39.55, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 1207.26, ['y'] = 2660.17, ['z'] = 37.89, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 2539.68, ['y'] = 2594.19, ['z'] = 37.94, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 2679.85, ['y'] = 3263.94, ['z'] = 55.24, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 2005.05, ['y'] = 3773.88, ['z'] = 32.40, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 1687.15, ['y'] = 4929.39, ['z'] = 42.07, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 1701.31, ['y'] = 6416.02, ['z'] = 32.76, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = 179.85, ['y'] = 6602.83, ['z'] = 31.86, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = -94.46, ['y'] = 6419.59, ['z'] = 31.48, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = -2554.99, ['y'] = 2334.40, ['z'] = 33.07, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = -1800.37, ['y'] = 803.66, ['z'] = 138.65, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = -1437.62, ['y'] = -276.74, ['z'] = 46.20, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = -2096.24, ['y'] = -320.28, ['z'] = 13.16, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = -724.61, ['y'] = -935.16, ['z'] = 19.21, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = -526.01, ['y'] = -1211.00, ['z'] = 18.18, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	{ ['x'] = -70.21, ['y'] = -1761.79, ['z'] = 29.53, ['sprite'] = 361, ['color'] = 41, ['nome'] = "Posto de Gasolina", ['scale'] = 0.3 },
	----

	{ ['x'] = -633.99, ['y'] = -238.98, ['z'] = 38.53, ['sprite'] = 617, ['color'] = 0, ['nome'] = "Joalheria", ['scale'] = 0.4 },
	{ ['x'] = 161.01, ['y'] = -1110.98, ['z'] = 29.89, ['sprite'] = 102, ['color'] = 13, ['nome'] = "Advogados / Tribunal", ['scale'] = 0.6 },

	{ ['x'] = 1308.01, ['y'] = 4261.0, ['z'] = 33.92, ['sprite'] = 68, ['color'] = 13, ['nome'] = "Central | Pescadores", ['scale'] = 0.4 },
	{ ['x'] = -1816.96, ['y'] = -1193.92, ['z'] = 14.32, ['sprite'] = 68, ['color'] = 13, ['nome'] = "Venda | Pescados", ['scale'] = 0.3 },

	{ ['x'] = 740.2, ['y'] = 6454.31, ['z'] = 31.93, ['sprite'] = 67, ['color'] = 45, ['nome'] = "Colher-Graos", ['scale'] = 0.6 },
	{ ['x'] = 1706.62, ['y'] = 4727.93, ['z'] = 42.18, ['sprite'] = 67, ['color'] = 45, ['nome'] = "Processar-Graos", ['scale'] = 0.6 },
	{ ['x'] = 2888.16, ['y'] = 4383.27, ['z'] = 50.31, ['sprite'] = 67, ['color'] = 45, ['nome'] = "Vender-Graos", ['scale'] = 0.6 },

	{ ['x'] = 460.249, ['y'] = -604.30,   ['z'] = 28.499, ['sprite'] = 513, ['color'] = 45, ['nome'] = "Central de Motorista", ['scale'] = 0.5 },
	{ ['x'] = 2832.0, ['y'] = 2797.02, ['z'] = 57.5, ['sprite'] = 513, ['color'] = 45, ['nome'] = "Minerador", ['scale'] = 0.5 },
	{ ['x'] = 1218.01, ['y'] = -1266.98, ['z'] = 36.43, ['sprite'] = 513, ['color'] = 45, ['nome'] = "Lenhadores", ['scale'] = 0.5 },
	{ ['x'] = -1576.99, ['y'] = 4504.0, ['z'] = 20.87, ['sprite'] = 285, ['color'] = 45, ['nome'] = "Floresta", ['scale'] = 0.5 },


	{ ['x'] = 902.98, ['y'] = -182.11, ['z'] = 73.97, ['sprite'] = 56, ['color'] = 38, ['nome'] = "Taxi", ['scale'] = 0.8 }, 
	{ ['x'] = -1135.23, ['y'] = -2860.82, ['z'] = 13.95, ['sprite'] = 43, ['color'] = 0, ['nome'] = "Helicoptero", ['scale'] = 0.4 }, 

	{ ['x'] = 55.34, ['y'] = -876.67, ['z'] = 30.66, ['sprite'] = 357, ['color'] = 3, ['nome'] = "Garagem", ['scale'] = 0.4 }, 
	{ ['x'] = 214.09, ['y'] = -809.02, ['z'] = 31.02, ['sprite'] = 357, ['color'] = 3, ['nome'] = "Garagem", ['scale'] = 0.4 }, 
	{ ['x'] = 55.34, ['y'] = -876.67, ['z'] = 30.66, ['sprite'] = 357, ['color'] = 3, ['nome'] = "Garagem", ['scale'] = 0.4 }, 
	{ ['x'] = 55.34, ['y'] = -876.67, ['z'] = 30.66, ['sprite'] = 357, ['color'] = 3, ['nome'] = "Garagem", ['scale'] = 0.4 }, 




	{ ['x'] = -1085.32, ['y'] = -802.17, ['z'] = 19.25, ['sprite'] = 60, ['color'] = 38, ['nome'] = "Departamento de Policia", ['scale'] = 0.5 },
	{ ['x'] = 287.06, ['y'] = -581.14, ['z'] = 49.72, ['sprite'] = 489, ['color'] = 59, ['nome'] = "Hospital", ['scale'] = 0.5 },
	{ ['x'] = 839.0, ['y'] = -917.0, ['z'] = 25.6, ['sprite'] = 402, ['color'] = 51, ['nome'] = "Mecânica", ['scale'] = 0.7 },
	{ ['x'] = -1200.77, ['y'] = -880.1, ['z'] = 13.35, ['sprite'] = 106, ['color'] = 51, ['nome'] = "Burger-shot", ['scale'] = 0.5 },
	{ ['x'] = -3405.51, ['y'] = 967.8, ['z'] = 8.3, ['sprite'] = 606, ['color'] = 56, ['nome'] = "Café", ['scale'] = 0.5 },
	{ ['x'] = -358.17, ['y'] = -1562.58, ['z'] = 26.21, ['sprite'] = 318, ['color'] = 0, ['nome'] = "Lixeiro", ['scale'] = 0.5 },
	{ ['x'] = -52.11, ['y'] = -1111.07, ['z'] = 26.82, ['sprite'] = 225, ['color'] = 3, ['nome'] = "Concessionária", ['scale'] = 0.5 }
	
}

Citizen.CreateThread(function()
	for _,v in pairs(blips) do
		local blip = AddBlipForCoord(v.x,v.y,v.z)
		SetBlipSprite(blip,v.sprite)
		SetBlipAsShortRange(blip,true)
		SetBlipColour(blip,v.color)
		SetBlipScale(blip,v.scale)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v.nome)
		EndTextCommandSetBlipName(blip)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVER ARMA ABAIXO DE 40MPH DENTRO DO CARRO - atirar de dentro do carro
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local ORTiming = 500
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped) then
            -- BLOQUEIA QUALQUER ARMA DE ATIRAR
            SetPlayerCanDoDriveBy(PlayerId(),true) -- se true pode ATIRAR, se false NAO PODE ATIRAR

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

-----------------------------------------------------------------------------------------------------------------------------------------
-- BLACKOUT
-----------------------------------------------------------------------------------------------------------------------------------------
local blackOut = false
local oldSpeed = 0

local function blackout()
	if not blackOut then
		blackOut = true
		Citizen.CreateThread(function()
			DoScreenFadeOut(1000)
			SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId())-40)
			while not IsScreenFadedOut() do
				Citizen.Wait(10)
			end
			Citizen.Wait(5000)
			DoScreenFadeIn(1000)
			blackOut = false
		end)
	end
end

Citizen.CreateThread(function()
	while true do
		local ORTiming = 500
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			ORTiming = 4
			local veh = GetVehiclePedIsIn(ped)
			if IsEntityAVehicle(veh) and GetPedInVehicleSeat(veh,-1) == ped and not IsPedOnAnyBike(ped) then
				local speed = GetEntitySpeed(veh) * 3.6
				if speed ~= oldSpeed then
					if not blackOut and ((oldSpeed - speed) >= 500000000000) then
						blackout()
					end
					oldSpeed = speed
				end
			end

			if blackOut then
				DisableControlAction(0,71,true)
				DisableControlAction(0,72,true)
				DisableControlAction(0,63,true)
				DisableControlAction(0,64,true)
				DisableControlAction(0,75,true)
			end
		else
			blackOut = false
			oldSpeed = 0
			speed = 0
		end

		Citizen.Wait(ORTiming)
	end
end)