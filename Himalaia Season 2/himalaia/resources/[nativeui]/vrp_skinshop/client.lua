
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRPrp = {}
vRP = Proxy.getInterface("vRP")
vRPserver = Tunnel.getInterface("vRP")
Tunnel.bindInterface("vrp_skinshop", vRPrp)
Proxy.addInterface("vrp_skinshop", vRPrp)

local lojaderoupa = {
    { name = "Loja de Roupas", id = 73, color = 13, x = 75.43, y = -1392.83, z = 29.37, provador = {x = 75.43, y = -1392.83, z = 29.37, heading = 0.0}},
    { name = "Loja de Roupas", id = 73, color = 13, x = -710.018, y = -153.072, z = 37.415, provador = {x = -710.018, y = -153.072, z = 37.415, heading = 0.0}},
    { name = "Loja de Roupas", id = 73, color = 13, x = -163.261, y = -302.830, z = 39.733, provador = {x = -163.261, y = -302.830, z = 39.733, heading = 0.0}},
    { name = "Loja de Roupas", id = 73, color = 13, x = 425.51, y = -806.27, z = 29.49, provador = {x = 425.51, y = -806.27, z = 29.49, heading = 0.0}},
    { name = "Loja de Roupas", id = 73, color = 13, x = -829.413, y = -1073.710, z = 11.500, provador = {x = -829.413, y = -1073.710, z = 11.500, heading = 0.0}},
    { name = "Loja de Roupas", id = 73, color = 13, x = -1450.320, y = -237.514, z = 49.810, provador = {x = -1450.320, y = -237.514, z = 49.810, heading = 0.0}},
    { name = "Loja de Roupas", id = 73, color = 13, x = 12.138, y = 6514.402, z = 31.877, provador = {x = 12.138, y = 6514.402, z = 31.877, heading = 0.0}},
    { name = "Loja de Roupas", id = 73, color = 13, x = 125.112, y = -223.696, z = 54.557, provador = {x = 125.112, y = -223.696, z = 54.557, heading = 0.0}},
    { name = "Loja de Roupas", id = 73, color = 13, x  = 470.75, y = -988.75, z = 25.74, provador = {x = 470.75, y = -988.75, z = 25.74, heading = 0.0}},
    { name = "Loja de Roupas", id = 73, color = 13, x = -822.34, y = -1073.49, z = 11.32, provador = {x = -822.34, y = -1073.49, z = 11.32, heading = 0.0}},
    { name = "Loja de Roupas", id = 73, color = 13, x = -1193.81, y = -768.49, z = 17.31, provador = {x = -1193.81, y = -768.49, z = 17.31, heading = 0.0}},
    { name = "Loja de Roupas", id = 73, color = 13, x = 4.90, y = 6512.47, z = 31.87, provador = {x = 4.90, y = 6512.47, z = 31.87, heading = 0.0}},
    { name = "Loja de Roupas", id = 73, color = 13, x = 1693.95, y = 4822.67, z = 42.06, provador = {x = 1693.95, y = 4822.67, z = 42.06, heading = 0.0}},
    { name = "Loja de Roupas", id = 73, color = 13, x = 614.26, y = 2761.91, z = 42.08, provador = {x = 614.26, y = 2761.91, z = 42.08, heading = 0.0}},
    { name = "Loja de Roupas", id = 73, color = 13, x = 1196.74, y = 2710.21, z = 38.22, provador = {x = 1196.74, y = 2710.21, z = 38.22, heading = 0.0}},
    { name = "Loja de Roupas", id = 73, color = 13, x = -3170.18, y = 1044.54, z = 20.86, provador = {x = -3170.18, y = 1044.54, z = 20.86, heading = 0.0}},
    { name = "Loja de Roupas", id = 73, color = 13, x = -1101.46, y = 2710.57, z = 19.10, provador = {x = -1101.46, y = 2710.57, z = 19.10, heading = 0.0}},
    { name = "Loja de Roupas", id = 73, color = 13, x = -32.26, y = -1108.67, z = 26.43-0.8, provador = {x = -32.26, y = -1108.67, z = 26.43, heading = 177.23}},
    { name = "Loja de Roupas", id = 73, color = 13, x = 315.11, y = -603.75, z = 43.3, provador = {x = 315.11, y = -603.75, z = 43.3, heading = 71.82}},
    { name = "Loja de Roupas", id = 73, color = 13, x = 1849.78, y = 3695.61, z = 34.27, provador = {x = 1849.78, y = 3695.61, z = 34.27, heading = 210.36}},
    { name = "Loja de Roupas", id = 73, color = 13, x = -1094.06, y = -832.03, z = 14.28, provador = {x = -1094.06, y = -832.03, z = 14.28, heading = 0.0}}, -- -1094.0671386719,-832.03009033203,14.283084869385
    { name = "Loja de Roupas", id = 73, color = 13, x = 298.73, y = -597.77, z = 43.28, provador = {x = 298.73, y = -597.77, z = 43.28, heading = 0.0}}, -- 300.17321777344,-596.82531738281,43.284065246582
    --  x = 470.75, y = -988.75, z = 25.74

}

local parts = {
    mascara = 1,
    mao = 3,
    calca = 4,
    mochila = 5,
    sapato = 6,
    gravata = 7,
    camisa = 8,
    colete = 9,
    jaqueta = 11,
    bone = "p0",
    -- oculos = "p1",
    -- brinco = "p2",
    -- relogio = "p6",
    -- bracelete = "p7"
}

local carroCompras = {
    mascara = false,
    mao = false,
    calca = false,
    mochila = false,
    sapato = false,
    gravata = false,
    camisa = false,
    jaqueta = false,
    colete = false,
    bone = false,
    -- oculos = false,
    -- brinco = false,
    -- relogio = false,
    -- bracelete = false
}

local old_custom = {}

local valor = 0
local precoTotal = 0

local in_loja = false
local atLoja = false

-- Provador
local chegou = false
local noProvador = false

-- Cam controll
local pos = nil
local camPos = nil
local cam = -1
local dataPart = 1
local texturaSelected = 0
local handsup = false

function SetCameraCoords()
    local ped = PlayerPedId()
	RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    
	if not DoesCamExist(cam) then
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
		SetCamActive(cam, true)
        RenderScriptCams(true, true, 500, true, true)

        pos = GetEntityCoords(PlayerPedId())
        camPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
        SetCamCoord(cam, camPos.x, camPos.y, camPos.z+0.75)
        PointCamAtCoord(cam, pos.x, pos.y, pos.z+0.15)
    end

end

function DeleteCam()
	SetCamActive(cam, false)
	RenderScriptCams(false, true, 0, true, true)
	cam = nil
end

RegisterNUICallback("changePart", function(data, cb)
    dataPart = parts[data.part]
    local ped = PlayerPedId()
    if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
        SendNUIMessage({ 
            changeCategory = true, 
            sexo = "Male", prefix = "M", 
            drawa = vRP.getDrawables(dataPart), category = dataPart 
        })
    elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then 
        SendNUIMessage({ 
            changeCategory = true, 
            sexo = "Female", prefix = "F", 
            drawa = vRP.getDrawables(dataPart), category = dataPart 
        })
    end
end)

Citizen.CreateThread(function()
    while true do
        local kswait = 1000
        
        local ped = PlayerPedId()
        local playerCoords = GetEntityCoords(ped, true)
        
        for k, v in pairs(lojaderoupa) do
            local provador = lojaderoupa[k].provador

            if GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, lojaderoupa[k].x, lojaderoupa[k].y, lojaderoupa[k].z, true ) <= 1.8 and not in_loja then
                kswait = 4
                DrawMarker(21,lojaderoupa[k].x, lojaderoupa[k].y, lojaderoupa[k].z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,153,0,153,50,0,0,0,1)
                --DrawMarker Dos Cloakrooms
                DrawMarker(21,383.04,-1609.92,29.46-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,153,0,153,50,0,0,0,1)
                DrawMarker(21,3561.7365722656,3674.1333007813,29.121891021729-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,153,0,153,50,0,0,0,1)
                DrawMarker(21,301.59063720703,-598.87524414063,44.284000396729-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,153,0,153,50,0,0,0,1)
                DrawMarker(21,-822.2626953125,-731.65386962891,29.054933547974-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,153,0,153,50,0,0,0,1)
                DrawMarker(21,-341.41320800781,-162.18084716797,44.587497711182-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,153,0,153,50,0,0,0,1)
                DrawMarker(21,-448.95,6015.55,31.72-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,153,0,153,50,0,0,0,1)
                DrawMarker(21,1833.81, 2584.63, 45.9-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,153,0,153,50,0,0,0,1)
                DrawMarker(21,470.97, -984.22, 25.74-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,153,0,153,50,0,0,0,1)
                --DrawMarkers Dos Cloakrooms
                drawTxt("PRESSIONE  ~r~E~w~  PARA ACESSAR A LOJA DE ROUPAS",4,0.5,0.93,0.50,255,255,255,180)
            end

            if GetDistanceBetweenCoords(GetEntityCoords(ped), lojaderoupa[k].x, lojaderoupa[k].y, lojaderoupa[k].z, true) < 1 then
                kswait = 4
                if IsControlJustPressed(0, 38) then
                    valor = 0
                    precoTotal = 0
                    noProvador = true
                    old_custom = vRP.getCustomization()
                    old = {}

                    cor = 0
		            -- dados, tipo = nil

                    TaskGoToCoordAnyMeans(ped, provador.x, provador.y, provador.z, 1.0, 0, 0, 786603, 0xbf800000)
                end
            end

            if noProvador then
                if GetDistanceBetweenCoords(GetEntityCoords(ped), provador.x, provador.y, provador.z, true) < 0.5 and not chegou then
                    kswait = 4
                    chegou = true

                    valor = 0
                    precoTotal = 0
                    SetEntityHeading(PlayerPedId(), provador.heading)
                    FreezeEntityPosition(ped, true)
                    SetEntityInvincible(ped, true)
                    openGuiLojaRoupa()
                end
            end
        end
        Citizen.Wait(kswait)
    end
end)

function openGuiLojaRoupa()
    local ped = PlayerPedId()
    SetNuiFocus(true, true)
    SetCameraCoords()
    if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
        SendNUIMessage({ 
            openLojaRoupa = true, 
            sexo = "Male", prefix = "M", 
            drawa = vRP.getDrawables(dataPart), category = dataPart 
        })
    elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then 
        SendNUIMessage({ 
            openLojaRoupa = true, 
            sexo = "Female", prefix = "F", 
            drawa = vRP.getDrawables(dataPart), category = dataPart 
        })
    end
    in_loja = true
end

RegisterNUICallback("leftHeading", function(data, cb)
    local currentHeading = GetEntityHeading(PlayerPedId())
    heading = currentHeading-tonumber(data.value)
    SetEntityHeading(PlayerPedId(), heading)
end)

RegisterNUICallback("handsUp", function(data, cb)
    local dict = "missminuteman_1ig_2"
    
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(100)
    end
    
    if not handsup then
        TaskPlayAnim(PlayerPedId(), dict, "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
        handsup = true
    else
        handsup = false
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNUICallback("rightHeading", function(data, cb)
    local currentHeading = GetEntityHeading(PlayerPedId())
    heading = currentHeading+tonumber(data.value)
    SetEntityHeading(PlayerPedId(), heading)
end)

function updateCarroCompras()
    valor = 0
    for k, v in pairs(carroCompras) do
        if carroCompras[k] == true then
            valor = valor + 75
        end
    end
    precoTotal = valor
    return valor
end

RegisterNUICallback("changeColor", function(data, cb)
    if type(dados) == "number" then
        max = GetNumberOfPedTextureVariations(PlayerPedId(), dados, tipo)
    elseif type(dados) == "string" then
        max = GetNumberOfPedPropTextureVariations(PlayerPedId(), parse_part(dados), tipo)
    end

    if data.action == "menos" then
        if cor > 0 then cor = cor - 1 else cor = max end
    elseif data.action == "mais" then
        if cor < max then cor = cor + 1 else cor = 0 end
    end
    if dados and tipo then setRoupa(dados, tipo, cor) end
end)

function changeClothe(type, id)
    dados = type
    tipo = tonumber(parseInt(id))
	cor = 0
    setRoupa(dados, tipo, cor)
end

function setRoupa(dados, tipo, cor)
    local ped = PlayerPedId()

	if type(dados) == "number" then
		SetPedComponentVariation(ped, dados, tipo, cor, 1)
    elseif type(dados) == "string" then
        SetPedPropIndex(ped, parse_part(dados), tipo, cor, 1)
        dados = "p" .. (parse_part(dados))
	end
	  
  	custom = vRP.getCustomization()
  	custom.modelhash = nil

	aux = old_custom[dados]
	v = custom[dados]

    if v[1] ~= aux[1] and old[dados] ~= "custom" then
        carroCompras[dados] = true
        price = updateCarroCompras()
        SendNUIMessage({ action = "setPrice", price = price, typeaction = "add" })
    	old[dados] = "custom"
    end
    if v[1] == aux[1] and old[dados] == "custom" then
        carroCompras[dados] = false
        price = updateCarroCompras()
        SendNUIMessage({ action = "setPrice", price = price, typeaction = "remove" })
    	old[dados] = "0"
	end

	SendNUIMessage({ value = price })
end

RegisterNUICallback("changeCustom", function(data, cb)
    changeClothe(data.type, data.id)
end)

RegisterNUICallback("payament", function(data, cb)
    carroCompras = {
        mascara = false,
        mao = false,
        calca = false,
        mochila = false,
        sapato = false,
        gravata = false,
        camisa = false,
        jaqueta = false,
        colete = false,
        bone = false,
        oculos = false,
        brinco = false,
        relogio = false,
        bracelete = false
    }
    TriggerServerEvent("LojaDeRoupas:Comprar", tonumber(data.price)) 
end)

RegisterNUICallback("reset", function(data, cb)
    vRP.setCustomization(old_custom)
    closeGuiLojaRoupa()
    ClearPedTasks(PlayerPedId())
end)

function closeGuiLojaRoupa()
    local ped = PlayerPedId()
    DeleteCam()
    SetNuiFocus(false, false)
    SendNUIMessage({ openLojaRoupa = false })
    FreezeEntityPosition(ped, false)
    SetEntityInvincible(ped, false)
    PlayerReturnInstancia()
    SendNUIMessage({ action = "setPrice", price = 0, typeaction = "remove" })
    
    in_loja = false
    noProvador = false
    chegou = false
    old_custom = {}
end

RegisterNetEvent('LojaDeRoupas:ReceberCompra')
AddEventHandler('LojaDeRoupas:ReceberCompra', function(comprar)
    if comprar then
        in_loja = false
        closeGuiLojaRoupa()
    else
        in_loja = false
        vRP.setCustomization(old_custom)
        closeGuiLojaRoupa()
    end
end)

function parse_part(key)
    if type(key) == "string" and string.sub(key, 1, 1) == "p" then
        return tonumber(string.sub(key, 2))
    else
        return false, tonumber(key)
    end
end

function PlayerInstancia()
    for _, player in ipairs(GetActivePlayers()) do
        local ped = PlayerPedId()
        local otherPlayer = GetPlayerPed(player)
        if ped ~= otherPlayer then
            SetEntityVisible(otherPlayer, false)
            SetEntityNoCollisionEntity(ped, otherPlayer, true)
        end
    end
end

function PlayerReturnInstancia()
    for _, player in ipairs(GetActivePlayers()) do
        local ped = PlayerPedId()
        local otherPlayer = GetPlayerPed(player)
        if ped ~= otherPlayer then
            SetEntityVisible(otherPlayer, true)
            SetEntityCollision(ped, true)
        end
    end
end

function criarBlip()
    for _, item in pairs(lojaderoupa) do
        item.blip = AddBlipForCoord(item.x, item.y, item.z)
        SetBlipSprite(item.blip, item.id)
        SetBlipColour(item.blip, item.color)
        SetBlipScale(item.blip, 0.4)
        SetBlipAsShortRange(item.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(item.name)
        EndTextCommandSetBlipName(item.blip)
    end
end

function drawTxt(text,font,x,y,scale,r,g,b,a)
    SetTextFont(font)
    SetTextScale(scale,scale)
    SetTextColour(r,g,b,a)
    SetTextOutline()
    SetTextCentre(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x,y)
end

Citizen.CreateThread(function()
    while true do
        if noProvador then
            PlayerInstancia()
            DisableControlAction(1, 1, true)
            DisableControlAction(1, 2, true)
            DisableControlAction(1, 24, true)
            DisablePlayerFiring(PlayerPedId(), true)
            DisableControlAction(1, 142, true)
            DisableControlAction(1, 106, true)
            DisableControlAction(1, 37, true)
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        N_0xf4f2c0d4ee209e20()
        Citizen.Wait(1000)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        closeGuiLojaRoupa()
    end
end)