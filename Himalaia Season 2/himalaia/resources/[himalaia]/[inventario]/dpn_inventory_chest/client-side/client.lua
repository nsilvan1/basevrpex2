vRP = module("vrp", "lib/Proxy").getInterface("vRP")
dPN = {}
module("vrp", "lib/Tunnel").bindInterface("dpn_inventory_chest", dPN)
module("vrp", "lib/Proxy").addInterface("dpn_inventory_chest", dPN)
dPNserver = module("vrp", "lib/Tunnel").getInterface("dpn_inventory_chest")

local printDebug = ConfigClient['debug'] or false
local cantOpen = false

local resultado = ''
local resultadoCraft = ''
secondInventory = ''
local tableCar = {}
local chestOpenReturn = nil
local animDict = nil
local animName = nil
local animActived = false
local nameCasa = nil
local bauCds = nil
local weaponInHand = nil

-- configs
local cfgDisableOldMappingShop = ConfigClient['disableIncludedShop'] or false
local cfgDisableOldMappingTrunk = ConfigClient['disableIncludedTrunk'] or false

local cfgSeparatedShop = ConfigClient['separatedShop'] or false
local cfgSeparatedTrunk = ConfigClient['separatedTrunk'] or false
local cfgPlacaClonada = ConfigClient['placaClonada'] or "CLONADA"

local cfgkeyBindWeapon = ConfigClient['keyBindWeapon'] or false

Citizen.CreateThread(function()
    SetNuiFocus(false, false)
    SetCursorLocation(0.5, 0.5)
    SetFrontendActive(false)

    Wait(1000)

    while cfgkeyBindWeapon do
        DisableControlAction(0, 192, true)
        DisableControlAction(0, 157, true)
        DisableControlAction(0, 158, true)
        DisableControlAction(0, 160, true)
        DisableControlAction(0, 164, true)
        DisableControlAction(0, 165, true)
        Wait(0)
    end
end)

RegisterNetEvent("dPN:inventario:Returnvault")
AddEventHandler("dPN:inventario:Returnvault", function(cds, nameHouse)
    bauCds = vector3(cds[1], cds[2], cds[3])
    nameCasa = nameHouse
end)

if ConfigClient['keyBind'] == true then
    RegisterKeyMapping("teclaAtalho1", "[Invent�rio] Keybind 1", "keyboard", "1")
    RegisterCommand("teclaAtalho1", function()
        if ConfigClient['keyBind'] == true then
            dPNserver.useKeyBindItem('0', ConfigClient['keyBindWeapon'])
        end
    end)

    RegisterKeyMapping("teclaAtalho2", "[Invent�rio] Keybind 2", "keyboard", "2")
    RegisterCommand("teclaAtalho2", function()
        if ConfigClient['keyBind'] == true then
            dPNserver.useKeyBindItem('1', ConfigClient['keyBindWeapon'])
        end
    end)

    RegisterKeyMapping("teclaAtalho3", "[Invent�rio] Keybind 3", "keyboard", "3")
    RegisterCommand("teclaAtalho3", function()
        if ConfigClient['keyBind'] == true then
            dPNserver.useKeyBindItem('2', ConfigClient['keyBindWeapon'])
        end
    end)

    RegisterKeyMapping("teclaAtalho4", "[Invent�rio] Keybind 4", "keyboard", "4")
    RegisterCommand("teclaAtalho4", function()
        if ConfigClient['keyBind'] == true then
            dPNserver.useKeyBindItem('3', ConfigClient['keyBindWeapon'])
        end
    end)

    RegisterKeyMapping("teclaAtalho5", "[Invent�rio] Keybind 5", "keyboard", "5")
    RegisterCommand("teclaAtalho5", function()
        if ConfigClient['keyBind'] == true then
            dPNserver.useKeyBindItem('4', ConfigClient['keyBindWeapon'])
        end
    end)
end

function dPN.puxWeapon(weapon, ammo)
    local ped = PlayerPedId()
    if weaponInHand == nil then -- Nenhuma arma na m�o
        local maxAmmo = GetMaxAmmoInClip(ped, GetHashKey(weapon))
        if parseInt(ammo) < parseInt(maxAmmo) then
            if dPNserver.removeAmmo("wammo|" .. weapon, ammo) then
                GiveWeaponToPed(ped, GetHashKey(weapon), ammo, false, false)
                SetCurrentPedWeapon(ped, GetHashKey(weapon), true)
            else
                GiveWeaponToPed(ped, GetHashKey(weapon), 0, false, false)
                SetCurrentPedWeapon(ped, GetHashKey(weapon), true)
            end
        elseif parseInt(ammo) >= parseInt(maxAmmo) then
            if dPNserver.removeAmmo("wammo|" .. weapon, maxAmmo) then
                GiveWeaponToPed(ped, GetHashKey(weapon), maxAmmo, false, false)
                SetCurrentPedWeapon(ped, GetHashKey(weapon), true)
            end
        end
        weaponInHand = weapon

    else -- Ter arma na m�o
        local ammoatual = GetAmmoInPedWeapon(ped, GetHashKey(weapon))
        SetPedAmmo(ped, GetHashKey(weapon), 0)
        RemoveWeaponFromPed(ped, GetHashKey(weapon))
        dPNserver.giveAmmo(weapon, ammoatual)
        RemoveAllPedWeapons(ped, true)

        weaponInHand = nil
    end
end

function dPN.rechargeAmmo(item, ammoWeapon)
    local ped = PlayerPedId()
    if weaponInHand then

        local maxAmmo = GetMaxAmmoInClip(ped, GetHashKey(weaponInHand))
        local ammoatual = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(weaponInHand))
        if parseInt(ammoWeapon) < parseInt(maxAmmo - ammoatual) then -- N�o tem para um pente inteiro
            if dPNserver.removeAmmo(item, ammoWeapon) then

                SetPedAmmo(ped, GetHashKey(weaponInHand), ammoatual + ammoWeapon)
                TaskReloadWeapon(ped, true)
            end
        elseif parseInt(ammoWeapon) >= parseInt(maxAmmo - ammoatual) then -- Tem para um pente inteiro
            local oqueFalta = maxAmmo - ammoatual
            if dPNserver.removeAmmo(item, oqueFalta) then
                SetPedAmmo(ped, GetHashKey(weaponInHand), ammoatual + oqueFalta)
                TaskReloadWeapon(ped, true)
            end
        end

    end
end

RegisterNetEvent('dope:nuis:abririnventario')
AddEventHandler('dope:nuis:abririnventario', function(cds, casanome)
    if cantOpen or IsPauseMenuActive() then
        return
    end

    local casabauzinho = vector3(cds[1], cds[2], cds[3])

    if casabauzinho ~= nil and casanome ~= nil then
        if printDebug then
            print("[DEBUG] Resid�ncia atual: " .. casanome)
        end
        nameCasa = casanome
        local playerCds = GetEntityCoords(PlayerPedId())
        local distance = #(playerCds - casabauzinho)
        if (ConfigClient['chestDistance'] and distance < ConfigClient['chestDistance']) or
            (not ConfigClient['chestDistance'] and distance < ConfigClient['distance']) then
            secondInventory = "house"
            if printDebug then
                print("[DEBUG] Tentando abrir ba� de resid�ncia...")
            end
        end
    end

    if ConfigClient['ip'] then
        SendNUIMessage({
            action = "openInventory",
            secondAction = secondInventory,
            url = ConfigClient['ip']
        })
    end
    SetNuiFocus(true, true)
    TransitionToBlurred(1000)
    SetCursorLocation(0.5, 0.5)
end)

RegisterNetEvent('dope:nuis:openinv')
AddEventHandler('dope:nuis:openinv', function()
    if cantOpen or IsPauseMenuActive() then
        return
    end

    secondInventory = nil
    tableCar = {}
    chestOpenReturn = nil
    SetNuiFocus(true, true)
    TransitionToBlurred(1000)
    SetCursorLocation(0.5, 0.5)

    -- Inicio do trunchest
    local ped = PlayerPedId()
    -- local veh = GetVehiclePedIsUsing(ped)
    -- if not IsPedInAnyVehicle(ped) then
    --     veh = vRP.getNearestVehicle(3)
    -- end

    local vehicle, vnetid, placa, vname, lock, banned, trunk = vRP.vehList(3)
    if vehicle and not IsPedInAnyVehicle(ped) then -- Est� perto de carro
        if GetVehicleDoorLockStatus(vehicle) == 1 then -- ESt� destrancado
            if banned then -- N�o est� apreendido
                return
            end
            local placa2 = dPNserver.getPlacaVehicle(placa)
            if placa2 then -- Carro dele
                local opnedCar = dPNserver.getOpend(vnetid)
                if opnedCar then
                    secondInventory = "trunckChest"
                    tableCar = {
                        vehicle = vehicle,
                        vnetid = vnetid,
                        placa = placa,
                        vname = vname,
                        lock = lock,
                        banned = banned,
                        trunk = trunk
                    }
                else
                    secondInventory = "jaemuso"
                end
            else
                secondInventory = "carroDeNpc"
            end
        else
            secondInventory = "carroTrancado"
        end
    end -- Fim trunkchest

    for k, v in pairs(ConfigClient['lojas']) do -- Inicio das lojas
        for _, mark in pairs(ConfigClient['lojas'][k]['locs']) do
            local x, y, z = table.unpack(mark)
            local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), x, y, z, true)

            if distance < ConfigClient['distance'] then
                secondInventory = k
            end
        end
    end -- Fim das lojas

    for k, v in pairs(ConfigClient['chestFac']) do
        local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), ConfigClient['chestFac'][k]['loc'][1],
            ConfigClient['chestFac'][k]['loc'][2], ConfigClient['chestFac'][k]['loc'][3], true)
        if (ConfigClient['chestFacDistance'] and distance < ConfigClient['chestFacDistance']) or
            (not ConfigClient['chestFacDistance'] and distance < ConfigClient['distance']) then
            local perm52 = dPNserver.verifyPermission(ConfigClient['chestFac'][k]['perm'])
            if perm52 then
                local trueChest = dPNserver.verifyOpenChest(k)
                if trueChest then
                    secondInventory = k
                    chestOpenReturn = k
                else
                    secondInventory = "jaemuso"
                end
            end
        end
    end

    TriggerEvent('dPN:inventario:vault')
    Wait(500)

    if bauCds ~= nil and nameCasa ~= nil then
        if printDebug then
            print("[DEBUG] Resid�ncia atual: " .. nameCasa)
        end

        local playerCds = GetEntityCoords(PlayerPedId())
        local distance = #(playerCds - bauCds)
        if (ConfigClient['chestDistance'] and distance < ConfigClient['chestDistance']) or
            (not ConfigClient['chestDistance'] and distance < ConfigClient['distance']) then
            secondInventory = "house"
            if printDebug then
                print("[DEBUG] Tentando abrir ba� de resid�ncia...")
            end
        end
    end

    if ConfigClient['ip'] then
        SendNUIMessage({
            action = "openInventory",
            secondAction = secondInventory,
            url = ConfigClient['ip']
        })
    end
end)

RegisterKeyMapping("abrirInventarioDopeNuis", "Abrir Invent�rio", "keyboard", 'oem_3')
RegisterCommand("abrirInventarioDopeNuis", function()
    if cantOpen or IsPauseMenuActive() then
        return
    end

    secondInventory = nil
    tableCar = {}
    chestOpenReturn = nil
    if vRP.isHandcuffed() or GetEntityHealth(PlayerPedId()) <= 101 then
        if printDebug then
            print("[NEGADO] Voc� n�o pode fazer isto morto ou algemado")
        end
        return
    end

    SetNuiFocus(true, true)
    TransitionToBlurred(1000)
    SetCursorLocation(0.5, 0.5)

    -- Inicio do trunchest
    local ped = PlayerPedId()
    if not cfgDisableOldMappingTrunk then
        local vehicle, vnetid, placa, vname, lock, banned, trunk = vRP.vehList(3)
        if vehicle and not IsPedInAnyVehicle(ped) then -- Est� perto de carro
            if GetVehicleDoorLockStatus(vehicle) == 1 then -- ESt� destrancado
                if banned then
                    return
                end
                local placa2 = dPNserver.getPlacaVehicle(placa)
                if placa2 then -- Carro dele
                    local opnedCar = dPNserver.getOpend(vnetid)
                    if opnedCar then
                        secondInventory = "trunckChest"
                        tableCar = {
                            vehicle = vehicle,
                            vnetid = vnetid,
                            placa = placa,
                            vname = vname,
                            lock = lock,
                            banned = banned,
                            trunk = trunk
                        }
                    else
                        secondInventory = "jaemuso"
                    end
                else
                    secondInventory = "carroDeNpc"
                end
            else
                secondInventory = "carroTrancado"
            end
        end -- Fim trunkchest
    end

    if not cfgDisableOldMappingShop then
        for k, v in pairs(ConfigClient['lojas']) do -- Inicio das lojas
            for _, mark in pairs(ConfigClient['lojas'][k]['locs']) do
                local x, y, z = table.unpack(mark)
                local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), x, y, z, true)
                if distance < ConfigClient['distance'] then
                    if v.perm == nil or not v.perm then
                        secondInventory = k
                    elseif v.perm then
                        if dPNserver.verifyPermission(v.perm) then
                            secondInventory = k
                        end
                    end
                end
            end
        end -- Fim das lojas
    end

    for k, v in pairs(ConfigClient['chestFac']) do
        local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), ConfigClient['chestFac'][k]['loc'][1],
            ConfigClient['chestFac'][k]['loc'][2], ConfigClient['chestFac'][k]['loc'][3], true)
        if (ConfigClient['chestDistance'] and distance < ConfigClient['chestDistance']) or
            (not ConfigClient['chestDistance'] and distance < ConfigClient['distance']) then
            local perm52 = dPNserver.verifyPermission(ConfigClient['chestFac'][k]['perm'])
            if perm52 then
                local trueChest = dPNserver.verifyOpenChest(k)
                if trueChest then
                    secondInventory = k
                    chestOpenReturn = k
                else
                    secondInventory = "jaemuso"
                end
            end
        end
    end

    TriggerEvent('dPN:inventario:vault')
    Wait(500)
    if bauCds ~= nil and nameCasa ~= nil then
        if printDebug then
            print("[DEBUG] Resid�ncia atual: " .. nameCasa)
        end

        local playerCds = GetEntityCoords(PlayerPedId())
        local distance = #(playerCds - bauCds)
        if (ConfigClient['chestDistance'] and distance < ConfigClient['chestDistance']) or
            (not ConfigClient['chestDistance'] and distance < ConfigClient['distance']) then
            secondInventory = "house"
        end
    end

    if ConfigClient['ip'] then
        SendNUIMessage({
            action = "openInventory",
            secondAction = secondInventory,
            url = ConfigClient['ip']
        }) 
        -- TriggerEvent('nation_hud:updateHud', false)
        -- TriggerEvent('wnHud:updateHud', false)
        TriggerEvent('vrp_hud:updateHud', false)


    end
end)

if cfgSeparatedShop then
    RegisterCommand("dope:inventory:openShop", function(source, args)
        if cantOpen or IsPauseMenuActive() then
            return
        end
        if vRP.isHandcuffed() or GetEntityHealth(PlayerPedId()) <= 101 then
            return
        end

        secondInventory = nil
        tableCar = {}
        chestOpenReturn = nil

        local ped = PlayerPedId()
        for k, v in pairs(ConfigClient['lojas']) do -- Inicio das lojas
            for _, mark in pairs(ConfigClient['lojas'][k]['locs']) do
                local x, y, z = table.unpack(mark)
                local distance = GetDistanceBetweenCoords(GetEntityCoords(ped), x, y, z, true)
                if distance < ConfigClient['distance'] then
                    if v.perm == nil or not v.perm then
                        secondInventory = k
                    elseif v.perm then
                        if dPNserver.verifyPermission(v.perm) then
                            secondInventory = k
                        end
                    end
                end
            end
        end -- Fim das lojas

        if secondInventory == nil then
            return
        end

        SetNuiFocus(true, true)
        TransitionToBlurred(1000)
        SetCursorLocation(0.5, 0.5)

        if ConfigClient['ip'] then
            SendNUIMessage({
                action = "openInventory",
                secondAction = secondInventory,
                url = ConfigClient['ip']
            })
        end
    end)
    RegisterKeyMapping("dope:inventory:openShop", "[Invent�rio] Abrir lojas", "keyboard", "E")
end
if cfgSeparatedTrunk then
    RegisterCommand("dope:inventory:openTrunk", function(source, args)
        if cantOpen or IsPauseMenuActive() then
            return
        end
        if vRP.isHandcuffed() or GetEntityHealth(PlayerPedId()) <= 101 then
            return
        end

        secondInventory = nil
        tableCar = {}
        chestOpenReturn = nil

        -- Inicio do trunkchest
        local ped = PlayerPedId()
        local vehicle, vnetid, placa, vname, lock, banned, trunk = vRP.vehList(3)
        if vehicle and not IsPedInAnyVehicle(ped) then -- Est� perto de carro
            if GetVehicleDoorLockStatus(vehicle) == 1 then -- ESt� destrancado
                if banned then
                    return
                end
                local placa2 = dPNserver.getPlacaVehicle(placa)
                if placa2 then -- Carro dele
                    local opnedCar = dPNserver.getOpend(vnetid)
                    if opnedCar then
                        secondInventory = "trunckChest"
                        tableCar = {
                            vehicle = vehicle,
                            vnetid = vnetid,
                            placa = placa,
                            vname = vname,
                            lock = lock,
                            banned = banned,
                            trunk = trunk
                        }
                    else
                        secondInventory = "jaemuso"
                    end
                else
                    secondInventory = "carroDeNpc"
                end
            else
                secondInventory = "carroTrancado"
            end
        end -- Fim trunkchest

        if secondInventory == nil then
            return
        end

        SetNuiFocus(true, true)
        TransitionToBlurred(1000)
        SetCursorLocation(0.5, 0.5)

        if ConfigClient['ip'] then
            SendNUIMessage({
                action = "openInventory",
                secondAction = secondInventory,
                url = ConfigClient['ip']
            })
        end
    end)
    RegisterKeyMapping("dope:inventory:openTrunk", "[Invent�rio] Abrir porta-malas", "keyboard",
        ConfigClient['keybindTrunk'] or "PAGEUP")
end

AddEventHandler('heyyImob:requestChestOpen', function(chestData)
    if printDebug then
        print("[DEBUG] Resid�ncia atual: " .. chestData.chestName)
    end

    nameCasa = chestData.chestName
    secondInventory = "house"

    if ConfigClient['ip'] then
        if printDebug then
            print("[DEBUG] Tentando abrir ba� de resid�ncia...")
        end

        SendNUIMessage({
            action = "openInventory",
            secondAction = secondInventory,
            url = ConfigClient['ip']
        })
        SetNuiFocus(true, true)
        TransitionToBlurred(1000)
        SetCursorLocation(0.5, 0.5)
    end
end)

function dPN.updateInventory()
    SendNUIMessage({
        action = "updateInventory",
        secondAction = secondInventory
    })
end

RegisterNUICallback("requsetIdentity", function(data, cb)
    local firstName, secondName, idade, id, registro, telefone, emprego, vip, multas, dinheiroCarteira, dinheiroBanco,
        admin = dPNserver.getIdentityPlayer()
    if firstName then
        cb({
            nome = firstName,
            sobrenome = secondName,
            idade = idade,
            id = id,
            registro = registro,
            telefone = telefone,
            emprego = emprego,
            vip = vip,
            multas = multas,
            carteira = dinheiroCarteira,
            banco = dinheiroBanco,
            admin = admin
        })
    end
end)

RegisterNUICallback("requestItens", function(data, cb)
    local ped = PlayerPedId()
    local inventario, atualPeso, maximoPeso, slot, slot2, slotsCompraveis, slotPrice = dPNserver.getInventoryPlayer()
    if inventario then
        cb({
            inventario = inventario,
            atualPeso = atualPeso,
            maximoPeso = maximoPeso,
            slot = slot,
            un = ConfigClient['unidades'],
            slot2 = parseInt(slot2),
            slotsComrpavel = slotsCompraveis,
            slotPrice = slotPrice
        })
    end
end)

RegisterNUICallback("requestItemSecondInventory", function(data, cb)
    local tipo = data.tipo
    if tipo then
        local lojasConfig = ConfigClient['lojas'][tipo] -- Se � uma loja de item
        local chestConfig = ConfigClient['chestFac'][tipo] -- Se � um chest
        if lojasConfig then
            local tableItem = dPNserver.getTableItemStore(lojasConfig['itens'])
            tableItem = dPNserver.getTableItemStore(lojasConfig['itens'])
            if tableItem then
                cb({
                    chest = false,
                    itemTable = tableItem
                })
            else
                print("Falha ao capturar os itens da loja")
            end
        elseif chestConfig then
            local tableItem, slots, tamanhoChest, tamanhoMyInv = dPNserver.getTableItemChest(chestConfig, tipo)
            if tableItem then
                if slots then
                    if tamanhoChest then
                        if tamanhoMyInv then
                            cb({
                                chest = true,
                                tableChest = tableItem,
                                slots = slots,
                                tamanhoChest = tamanhoChest,
                                tamanhoMyInv = tamanhoMyInv
                            })
                        else
                            print("Erro ao pegar o tamanho do invent�rio.")
                        end
                    else
                        print("Erro ao pegar o tamanho do chest do ba�" .. chestConfig .. ".")
                    end
                else
                    print("Erro ao pegar os slots do ba�" .. chestConfig .. ".")
                end

            end

        elseif tipo == "trunckChest" then
            local tableItem, slots, tamanhoChest, tamanhoTrunk = dPNserver.getItemTurnkChest(tableCar)
            if tableItem then
                if slots then
                    if tamanhoChest then
                        if tamanhoTrunk then
                            cb({
                                chest = "TrunckChest",
                                tableChest = tableItem,
                                slots = slots,
                                tamanhoChest = tamanhoChest,
                                tamanhoMyInv = tamanhoTrunk,
                                nameCar = tableCar.vname
                            })
                        else
                            print("Erro ao pegar o tamanho do trunkChest.")
                        end
                    else
                        print("Erro ao pegar o tamanho dos item do trunkChest.")
                    end
                else
                    print("Erro ao pegar os slots do trunkChest.")
                end
            else
                print("Erro ao pegar itens do trunkChest.")
            end

        elseif tipo == "house" then
            local tableItem, slots, tamanhoChest, tamanhoDosItens = dPNserver.getItemHouses(nameCasa)
            if tableItem then
                if slots then
                    if tamanhoChest then
                        if tamanhoDosItens then
                            cb({
                                chest = "house",
                                tableChest = tableItem,
                                slots = slots,
                                tamanhoChest = tonumber(tamanhoChest),
                                tamanhoMyInv = tonumber(tamanhoDosItens),
                                nameHouse = nameCasa
                            })
                        else
                            print("Erro ao pegar o tamanho do house.")
                        end
                    else
                        print("Erro ao pegar o tamanho dos item do house.")
                    end
                else
                    print("Erro ao pegar os slots do house.")
                end
            else
                print("Erro ao pegar itens do house.")
            end
        end
    end
end)

RegisterNUICallback("buyItem", function(data, cb)
    if data.item and data.preco and data.newSlot and data.amount then
        if ConfigClient['lojas'][secondInventory]['itens'][data.item] then
            if tonumber(data.preco) == tonumber(ConfigClient['lojas'][secondInventory]['itens'][data.item]['price']) then
                if ConfigClient['lojas'][secondInventory]['onlyType'] and
                    ConfigClient['lojas'][secondInventory]['onlyType'] == "sell" then
                    TriggerEvent("Notify", "negado",
                        "Este item não esta disponivel para compra na loja, somente venda", 10000)
                    return
                end
                dPNserver.buyItem(data.item, data.preco, data.newSlot, data.amount,
                    (ConfigClient['lojas'][secondInventory]['itens'][data.item]["requireItem"] or false),
                    (ConfigClient['lojas'][secondInventory]['itens'][data.item]["requiredItems"] or {}))
            end
        end
    end
end)

RegisterNUICallback("venderItem", function(data, cb)
    local slot = (data.slot or 0)
    if data.item and slot and data.amount then
        local item = data.item
        if secondInventory then
            if ConfigClient['lojas'][secondInventory] then
                if ConfigClient['lojas'][secondInventory]['itens'] then
                    if ConfigClient['lojas'][secondInventory]['itens'][item] then
                        local shop = ConfigClient['lojas'][secondInventory]['itens'][item]
                        if shop['price'] then
                            if ConfigClient['lojas'][secondInventory]['onlyType'] and
                                ConfigClient['lojas'][secondInventory]['onlyType'] == "buy" then
                                TriggerEvent("Notify", "negado",
                                    "Esse item n�o est� a venda na loja, somente compra.", 10000)
                                return
                            end

                            local price = tonumber(shop['price']) * tonumber(data.amount)
                            if ConfigClient['percentual'] then
                                local newPrice = tonumber(price) * ConfigClient['percentual']
                                dPNserver.sellItem(item, newPrice, data.amount, slot)
                            end
                        else
                            TriggerEvent("Notify", "negado", "Esse item n�o est� a venda na loja", 10000)
                        end
                    else
                        TriggerEvent("Notify", "negado", "Esse item n�o est� a venda na loja", 10000)
                    end
                end
            end
        end
    end
end)

RegisterNUICallback("moverItemTrunckChest", function(data)
    if data.item then
        dPNserver.moverSlotTrunckChest(data.item, data.oldSlot, data.newSlot, data.amount, data.trunck)
    end
end)

RegisterNUICallback("moverItemHouse", function(data)
    if data.item then
        dPNserver.moverSlotItemHouse(data.item, data.oldSlot, data.newSlot, data.amount, data.trunck)
    end
end)

RegisterNUICallback("moverItemChest", function(data)
    if data.item then
        dPNserver.moverSlotChest(data.item, data.oldSlot, data.newSlot, data.amount, data.chest)
    end
end)

RegisterNUICallback("colocarItemInventory", function(data)
    local item2 = data.item
    if data.item then
        for k, v in pairs(ConfigClient['blackItemList']['chest']) do
            if data.item == v then
                item2 = nil
                break
            else
                item2 = data.item
            end
        end
        if item2 ~= nil then
            local chest = data.chest
            local webhook = ConfigClient['chestFac'][chest]['webhook']
            local weight = ConfigClient['chestFac'][chest]['weight']
            dPNserver.colocarItem(item2, data.oldSlot, data.newSlot, data.amount, chest, webhook, weight)
        else
            TriggerEvent("Notify", "negado", "Esse item n�o pode ser colocado no ba�", 10000)
        end
    end
end)

RegisterNUICallback("colocarItemTrunkInventory", function(data)
    local item = data.item
    if data.item then
        for k, v in pairs(ConfigClient['blackItemList']['trunckchest']) do
            if data.item == v then
                item = nil
                break
            else
                item = data.item
            end
        end
        if item ~= nil then
            dPNserver.colocarItemTrunck(item, data.oldSlot, data.newSlot, data.amount, data.chest)
        else
            TriggerEvent("Notify", "negado", "Esse item n�o pode ser colocado no ba�", 10000)
        end
    end
end)

RegisterNUICallback("colocarItemHouse", function(data)
    local item = data.item
    if data.item then
        for k, v in pairs(ConfigClient['blackItemList']['homes']) do
            if data.item == v then
                item = nil
                break
            else
                item = data.item
            end
        end

        if item ~= nil then
            dPNserver.colocarItemHouse(item, data.oldSlot, data.newSlot, data.amount, data.chest)
        else
            TriggerEvent("Notify", "negado", "Esse item n�o pode ser colocado no ba�", 10000)
        end
    end
end)

RegisterNUICallback("retirarItemChest", function(data)
    if data.item then
        local chest = data.chest
        local webhook = ConfigClient['chestFac'][chest]['webhook']
        dPNserver.retirarItemChest(data.item, data.oldSlot, data.newSlot, data.amount, chest, webhook)
    end
end)

RegisterNUICallback("retirarItemTrunk", function(data)
    if data.item then
        dPNserver.retirarItemTrunck(data.item, data.oldSlot, data.newSlot, data.amount, data.chest)
    end
end)

RegisterNUICallback("retirarItemHouse", function(data)
    if data.item then
        dPNserver.retirarItemHouse(data.item, data.oldSlot, data.newSlot, data.amount, data.chest)
    end
end)

RegisterNUICallback("buySlot", function(cb)
    dPNserver.buySlot()
end)

RegisterNUICallback("closeInventory", function(cb)
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "closeInventory"
    })
    TransitionFromBlurred(1000)
    cantOpen = true
    Wait(1000)
    cantOpen = false
    dPNserver.closeInventory(tableCar.vnetid, chestOpenReturn)
    chestOpenReturn = nil
    -- TriggerEvent('nation_hud:updateHud', true)
    -- TriggerEvent('wnHud:updateHud', true)
    TriggerEvent('vrp_hud:updateHud', true)


end)

function dPN.closeInventoryPlayer()
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "closeInventory"
    })
    TransitionFromBlurred(1000)
    dPNserver.closeInventory(tableCar.vnetid, chestOpenReturn)
end

RegisterNUICallback("usarItem", function(data)
    if data.item then
        dPNserver.useItem(data.item, data.amount, data.type, data.slot, ConfigClient['keyBindWeapon'])
    end
end)

RegisterNUICallback("enviarItem", function(data)
    if data.item then
        dPNserver.sendItem(data.item, data.amount, data.slot)
    end
end)

RegisterNUICallback("droparItem", function(data)
    if data.item then
        dPNserver.dropItem(data.item, data.amount, data.slot)
    end
end)

RegisterNUICallback("moverItem", function(data)
    if data.item then
        dPNserver.moverSlot(data.item, data.oldSlot, data.newSlot, data.amount)
    end
end)

RegisterNUICallback("craftItemRemove", function(data)
    if data.item then
        dPNserver.removeItemCraft(data.item, data.oldSlot, data.amount)
    end
end)

RegisterNUICallback("craftItemDbClick", function(data)
    if data.item then
        dPNserver.dbClickRemove(data.item, data.amount)
    end
end)

RegisterNUICallback("updateCraft", function(data)
    itemResultado = nil
    quantidadeResultado = nil
    if data.tabela then
        resultado = ''
        for k, v in pairs(data.tabela) do
            local item = v.item
            local quantidade = v.quantidade
            resultado = resultado .. " " .. item .. " " .. quantidade .. ""
        end
    end
    for a, b in pairs(ConfigCraft['craft']) do
        resultadoCraft = ''
        for i = 1, 9, 1 do
            resultadoCraft = resultadoCraft .. " " .. b['slot'][i].item .. " " .. b['slot'][i].quantidade .. ""
        end
        if resultadoCraft == resultado then
            resultadoK = a
            itemResultado = dPNserver.retrieveCraftItem(b['resultado'].name) -- b['resultado'].name
            quantidadeResultado = b['resultado'].amount

            if printDebug then
                print("1", tostring(quantidadeResultado) .. "x " .. tostring(itemResultado),
                    "Resultado KEY: " .. tostring(resultadoK))
            end
            break
        end
    end
end)

RegisterNUICallback("getResultCraft", function(data, cb)
    if printDebug then
        print("2", tostring(quantidadeResultado) .. "x " .. tostring(itemResultado),
            "Resultado KEY: " .. tostring(resultadoK), ConfigCraft['craft'][resultadoK]['perm'])
    end

    local i = 0
    while not itemResultado and i < 10 do
        Wait(300)
        if printDebug then
            print("3", tostring(quantidadeResultado) .. "x " .. tostring(itemResultado),
                "Resultado KEY: " .. tostring(resultadoK), ConfigCraft['craft'][resultadoK]['perm'])
        end
        i = i + 1
    end

    if itemResultado then
        local cord = ConfigCraft['craft'][resultadoK]['loc']
        if cord ~= nil then
            local allowedCoord = false
            for _, mark2 in pairs(cord) do
                local x, y, z = table.unpack(mark2)
                local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), x, y, z, true)
                if (ConfigClient['craftDistance'] and distance < ConfigClient['craftDistance']) or
                    (not ConfigClient['craftDistance'] and distance < ConfigClient['distance']) then
                    allowedCoord = true
                    if ConfigCraft['craft'][resultadoK]['perm'] ~= nil then
                        if dPNserver.verifyPermission(ConfigCraft['craft'][resultadoK]['perm']) then
                            cb({
                                resultado = itemResultado,
                                quantidade = quantidadeResultado,
                                index = resultadoK
                            })
                            break
                        else
                            TriggerEvent("Notify", "negado", "Voc� n�o tem a permiss�o necessaria")
                        end
                    elseif ConfigCraft['craft'][resultadoK]['perm'] == nil then
                        cb({
                            resultado = itemResultado,
                            quantidade = quantidadeResultado,
                            index = resultadoK
                        })
                        break
                    end
                end
            end

            if not allowedCoord then
                TriggerEvent("Notify", "negado", "Voc� n�o est� no local correto")
            end
        elseif cord == nil then
            if ConfigCraft['craft'][resultadoK]['perm'] ~= nil then
                if dPNserver.verifyPermission(ConfigCraft['craft'][resultadoK]['perm']) then
                    cb({
                        resultado = itemResultado,
                        quantidade = quantidadeResultado,
                        index = resultadoK
                    })
                else
                    TriggerEvent("Notify", "negado", "Voc� n�o tem a permiss�o necessaria")
                end
            elseif ConfigCraft['craft'][resultadoK]['perm'] == nil then
                cb({
                    resultado = itemResultado,
                    quantidade = quantidadeResultado,
                    index = resultadoK
                })
            end
        end
    end
end)

RegisterNUICallback("resgatarItem", function(data)
    if data.slot and data.item and data.quantidade and data.index then
        if ConfigCraft['craft'][resultadoK] and ConfigCraft['craft'][resultadoK]['animation'] then
            local freezePlayer = ConfigCraft['craft'][resultadoK]['lockPed']
            local animationTime = ConfigCraft['craft'][resultadoK]['animationTime']
            local animationData = ConfigCraft['craft'][resultadoK]['animationData']
            vRP.playAnim(animationData.upper, animationData.seq, animationData.looping)
            dPN.closeInventoryPlayer()

            cantOpen = true

            if freezePlayer then
                FreezeEntityPosition(PlayerPedId(), freezePlayer)
            end
            TriggerEvent("progress",20000,"Craftando")

            Citizen.Wait(animationTime * 1000)

            cantOpen = false

            if freezePlayer then
                FreezeEntityPosition(PlayerPedId(), false)
            end

            vRP.stopAnim()
        end
        dPNserver.giveItemCraft(data.slot, data.item, data.quantidade, data.index)
    end
end)

function dPN.getDamagedWeapon(weapon)
    local weaponHash = GetHashKey(weapon)
    local dano = GetWeaponDamage(weaponHash, -1)
    return dano
end

function dPN.getWeaponStatus(weapon)
    local weaponHash = GetHashKey(weapon)
    local dano, cadencia, hudCapacity, precisao, recoil = GetWeaponHudStats(weaponHash)
    return cadencia, precisao, recoil, hudCapacity
end

local function GetIntFromBlob(b, s, o)
    r = 0
    for i = 1, s, 1 do
        r = r | (string.byte(b, o + i) << (i - 1) * 8)
    end
    return r
end

function GetWeaponHudStats(weaponHash, none)
    blob = '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0'
    retval = Citizen.InvokeNative(0xD92C739EE34C9EBA, weaponHash, blob, Citizen.ReturnResultAnyway())
    hudDamage = GetIntFromBlob(blob, 8, 0)
    hudSpeed = GetIntFromBlob(blob, 8, 8)
    hudCapacity = GetIntFromBlob(blob, 8, 16)
    hudAccuracy = GetIntFromBlob(blob, 8, 24)
    hudRange = GetIntFromBlob(blob, 8, 32)
    return retval, hudDamage, hudSpeed, hudCapacity, hudAccuracy, hudRange
end

function dPN.CarregarObjeto(dict, anim, prop, flag, mao, altura, pos1, pos2, pos3, pos4, pos5)
    if DoesEntityExist(object) then
        TriggerServerEvent("tryDeleteEntity", ObjToNet(object))
        object = nil
    end

    local ped = PlayerPedId()
    local mHash = GetHashKey(prop)

    RequestModel(mHash)
    while not HasModelLoaded(mHash) do
        RequestModel(mHash)
        Citizen.Wait(10)
    end

    if anim ~= "" then
        loadAnimSet(dict)
        TaskPlayAnim(ped, dict, anim, 3.0, 3.0, -1, flag, 0, 0, 0, 0)
    end

    if altura then
        local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, -5.0)
        object = CreateObject(mHash, coords.x, coords.y, coords.z, true, true, true)
        AttachEntityToEntity(object, ped, GetPedBoneIndex(ped, mao), altura, pos1, pos2, pos3, pos4, pos5, true, true,
            false, true, 1, true)
    else
        local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, -5.0)
        object = CreateObject(mHash, coords.x, coords.y, coords.z, true, true, true)
        AttachEntityToEntity(object, ped, GetPedBoneIndex(ped, mao), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false,
            false, 2, true)
    end
    SetEntityAsMissionEntity(object, true, true)
    SetModelAsNoLongerNeeded(mHash)

    animDict = dict
    animName = anim
    animFlags = flag
    animActived = true
    startAnimation()
end

function loadAnimSet(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end

function dPN.deleteObejetoSync(index)
    if NetworkDoesNetworkIdExist(index) then
        local v = NetToEnt(index)
        if DoesEntityExist(v) then
            SetEntityAsMissionEntity(v, false, false)
            DeleteEntity(v)
            animActived = false
        end
    end
end

function dPN.DeletarObjeto()
    stopAnim(true)
    TriggerEvent("binoculos")
    if DoesEntityExist(object) then
        dPNserver.deleteEvent(ObjToNet(object))
        object = nil
    end
end

function startAnimation()
    while true do
        local timeDistance = 500
        local ped = PlayerPedId()
        if not IsEntityPlayingAnim(ped, animDict, animName, 3) and animActived then
            TaskPlayAnim(ped, animDict, animName, 3.0, 3.0, -1, animFlags, 0, 0, 0, 0)
            timeDistance = 4
        end
        if animActived == false then
            break
        end
        Citizen.Wait(timeDistance)
    end
end

function stopAnim(upper)
    anims = {}
    if upper then
        ClearPedSecondaryTask(PlayerPedId())
    else
        ClearPedTasks(PlayerPedId())
    end
end

function dPN.playScreenEffect(name, duration)
    if duration < 0 then
        StartScreenEffect(name, 0, true)
    else
        StartScreenEffect(name, 0, true)

        Citizen.CreateThread(function()
            Citizen.Wait(math.floor((duration + 1) * 1000))
            StopScreenEffect(name)
        end)
    end
end

function dPN.giveWeapons(weapons, clear_before)
    local player = PlayerPedId()
    if clear_before then
        RemoveAllPedWeapons(player, true)
    end
    for k, weapon in pairs(weapons) do
        local hash = GetHashKey(k)
        local ammo = weapon.ammo or 0
        GiveWeaponToPed(player, hash, ammo, false)
    end
end

RegisterNetEvent("openTrunk")
AddEventHandler("openTrunk", function(vehid, trunk)
    if NetworkDoesNetworkIdExist(vehid) then
        local v = NetToVeh(vehid)
        if DoesEntityExist(v) and IsEntityAVehicle(v) then
            if trunk then
                SetVehicleDoorShut(v, 5, 0)
            else
                SetVehicleDoorOpen(v, 5, 0, 0)
            end
        end
    end
end)

RegisterNetEvent("dope:lock")
AddEventHandler("dope:lock", function(index)
    if NetworkDoesNetworkIdExist(index) then
        local v = NetToVeh(index)
        if DoesEntityExist(v) then
            if IsEntityAVehicle(v) then
                local locked = GetVehicleDoorLockStatus(v)
                if locked == 1 then
                    SetVehicleDoorsLocked(v, 2)
                else
                    SetVehicleDoorsLocked(v, 1)
                end
                SetVehicleLights(v, 2)
                Wait(200)
                SetVehicleLights(v, 0)
                Wait(200)
                SetVehicleLights(v, 2)
                Wait(200)
                SetVehicleLights(v, 0)
            end
        end
    end
end)

function dPN.vehicleClientLock(vehid, lock)
    if NetworkDoesNetworkIdExist(vehid) then
        local v = NetToVeh(vehid)

        if DoesEntityExist(v) and IsEntityAVehicle(v) then

            SetVehicleDoorsLocked(v, 1)
            SetVehicleLights(v, 2)
            Wait(200)
            SetVehicleLights(v, 0)
            Wait(200)
            SetVehicleLights(v, 2)
            Wait(200)
            SetVehicleLights(v, 0)
        end
    end
end

local PlateIndex = ""
RegisterNetEvent('cloneplates')
AddEventHandler('cloneplates', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsUsing(ped)
    local placa = GetVehicleNumberPlateText(vehicle)
    if IsEntityAVehicle(vehicle) then
        FreezeEntityPosition(vehicle, false)
        if placa == cfgPlacaClonada then
            SetVehicleNumberPlateText(vehicle, PlateIndex)
            PlateIndex = nil
        else
            PlateIndex = GetVehicleNumberPlateText(vehicle)
            SetVehicleNumberPlateText(vehicle, cfgPlacaClonada)
        end
    end
end)

function dPN.returnChest()
    if chestOpenReturn then
        return chestOpenReturn
    else
        return false
    end
end

RegisterNetEvent("dope:inventory:close")
AddEventHandler("dope:inventory:close", function()
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "closeInventory"
    })
    TransitionFromBlurred(1000)
    dPNserver.closeInventory(tableCar.vnetid, chestOpenReturn)
end)

RegisterNetEvent('dope:enable:inventario')
AddEventHandler('dope:enable:inventario', function(status)
    cantOpen = status
end)


RegisterNetEvent("hzin:AdicionarCDS")
AddEventHandler("hzin:AdicionarCDS",function(x,y,z)
    Blips = AddBlipForCoord(-343.0,-1088.01,22.36)

    SetBlipSprite(Blips, 309)
    SetBlipColour(Blips, 1)
    AddTextEntry('Chamar:Policia', 'Corridas Ilegais')
    BeginTextCommandSetBlipName('Chamar:Policia')
    EndTextCommandSetBlipName(Blips)
    Wait(50000)
    RemoveBlip(Blips)
end)

AddEventHandler("hzin:AdicionarCDS",function(x,y,z)
    Blips = AddBlipForCoord(706.0,-1582.0,9.03)

    SetBlipSprite(Blips, 309)
    SetBlipColour(Blips, 1)
    AddTextEntry('Chamar:Policia', 'Corridas Ilegais')
    BeginTextCommandSetBlipName('Chamar:Policia')
    EndTextCommandSetBlipName(Blips)
    Wait(50000)
    RemoveBlip(Blips)
end)

AddEventHandler("hzin:AdicionarCDS",function(x,y,z)
    Blips = AddBlipForCoord(853.01,-1357.0,25.42)
    SetBlipSprite(Blips, 309)
    SetBlipColour(Blips, 1)
    AddTextEntry('Chamar:Policia', 'Corridas Ilegais')
    BeginTextCommandSetBlipName('Chamar:Policia')
    EndTextCommandSetBlipName(Blips)
    Wait(50000)
    RemoveBlip(Blips)
end)


AddEventHandler("hzin:AdicionarCDS",function(x,y,z)
    Blips = AddBlipForCoord(-2180.99, -384.0, 13.29)
    SetBlipSprite(Blips, 309)
    SetBlipColour(Blips, 1)
    AddTextEntry('Chamar:Policia', 'Corridas Ilegais')
    BeginTextCommandSetBlipName('Chamar:Policia')
    EndTextCommandSetBlipName(Blips)
    Wait(50000)
    RemoveBlip(Blips)
end)


AddEventHandler("hzin:AdicionarCDS",function(x,y,z)
    Blips = AddBlipForCoord(-351.35,-738.57,53.25)

    SetBlipSprite(Blips, 309)
    SetBlipColour(Blips, 1)
    AddTextEntry('Chamar:Policia', 'Corridas Ilegais')
    BeginTextCommandSetBlipName('Chamar:Policia')
    EndTextCommandSetBlipName(Blips)
    Wait(50000)
    RemoveBlip(Blips)
end)


AddEventHandler("hzin:AdicionarCDS",function(x,y,z)
    Blips = AddBlipForCoord(619.38,650.21,128.92)
    SetBlipSprite(Blips, 309)
    SetBlipColour(Blips, 1)
    AddTextEntry('Chamar:Policia', 'Corridas Ilegais')
    BeginTextCommandSetBlipName('Chamar:Policia')
    EndTextCommandSetBlipName(Blips)
    Wait(50000)
    RemoveBlip(Blips)
end)

AddEventHandler("hzin:AdicionarCDS",function(x,y,z)

    Blips = AddBlipForCoord(1377.14,-739.26,67.24)

    SetBlipSprite(Blips, 309)
    SetBlipColour(Blips, 1)
    AddTextEntry('Chamar:Policia', 'Corridas Ilegais')
    BeginTextCommandSetBlipName('Chamar:Policia')
    EndTextCommandSetBlipName(Blips)
    Wait(50000)
    RemoveBlip(Blips)
end)

AddEventHandler("hzin:AdicionarCDS",function(x,y,z)
    Blips = AddBlipForCoord(-779.39,-1334.07,5.01)

    SetBlipSprite(Blips, 309)
    SetBlipColour(Blips, 1)
    AddTextEntry('Chamar:Policia', 'Corridas Ilegais')
    BeginTextCommandSetBlipName('Chamar:Policia')
    EndTextCommandSetBlipName(Blips)
    Wait(50000)
    RemoveBlip(Blips)
end)

AddEventHandler("hzin:AdicionarCDS",function(x,y,z)
    Blips = AddBlipForCoord(-1620.7,-921.86,8.72)

    SetBlipSprite(Blips, 309)
    SetBlipColour(Blips, 1)
    AddTextEntry('Chamar:Policia', 'Corridas Ilegais')
    BeginTextCommandSetBlipName('Chamar:Policia')
    EndTextCommandSetBlipName(Blips)
    Wait(50000)
    RemoveBlip(Blips)
end)

AddEventHandler("hzin:AdicionarCDS",function(x,y,z)
    Blips = AddBlipForCoord(1205.24,340.92,82.0)

    SetBlipSprite(Blips, 309)
    SetBlipColour(Blips, 1)
    AddTextEntry('Chamar:Policia', 'Corridas Ilegais')
    BeginTextCommandSetBlipName('Chamar:Policia')
    EndTextCommandSetBlipName(Blips)
    Wait(50000)
    RemoveBlip(Blips)
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- ROUPA
-----------------------------------------------------------------------------------------------------------------------------------------

function FadeRoupa(time, tipo, idle_copy)
    DoScreenFadeOut(800)
    Wait(time)
    if tipo == 1 then
        vRP.setCustomization(idle_copy)
    else
        vRP.setCustomization(roupaantiga)
    end
    DoScreenFadeIn(800)
end

local Roupafarda1 = {
    ['recruta'] = {
        [1885233650] = {
        [1] = {0,0,1},
        [2] = {19,0,0},
        [3] = {0,0,1},
        [4] = {130,4,1},
        [5] = {0,0,1},
        [6] = {24,0,1},
        [7] = {1,0,1},
        [8] = {154,0,1},
        [9] = {20,4,1},
        [10] = {0,0,0},
        [11] = {38,0,1},
        ["p0"] = {-1,0},
        ["p6"] = {-1,0},
        ["p1"] = {-1,0},
        ["p7"] = {-1,0},
        [0] = {0,0,0},
        ["p2"] = {-1,0}
        },
        [-1667301416] = {
            [1] = {0,0,0},
            [2] = {44,0,0},
            [3] = {14,0,2},
            [4] = {136,1,1},
            [5] = {0,0,1},
            [6] = {24,0,1},
            [7] = {0,0,2},
            [8] = {6,0,2},
            [9] = {3,0,1},
            [10] = {0,0,0},
            [11] = {250,0,1},
            ["p1"] = {-1,0},
            ["p2"] = {-1,0},
            ["p0"] = {120,0},
            ["p6"] = {-1,0},
            [0] = {0,0,0},
            ["p7"] = {-1,0},
        }
    }
}

function ColocarRoupa1()
    if GetEntityHealth(PlayerPedId()) > 101 then
        if not vRP.isHandcuffed() then
            local custom = Roupafarda1['recruta']
            if custom then
                local old_custom = vRP.getCustomization()
				roupaantiga = old_custom
                local idle_copy = {}
                idle_copy.modelhash = nil
                for l, w in pairs(custom[old_custom.modelhash]) do
                    idle_copy[l] = w
                end
                FadeRoupa(1200, 1, idle_copy)
            end
        end
    end
end

local Roupafarda2 = {
    ['soldado'] = {
        [1885233650] = {
        [1] = {0,0,1},
        [2] = {19,0,0},
        [3] = {0,0,1},
        [4] = {130,0,1},
        [5] = {0,0,1},
        [6] = {24,0,1},
        [7] = {1,0,1},
        [8] = {154,0,1},
        [9] = {20,4,1},
        [10] = {0,0,0},
        [11] = {38,1,1},
        ["p0"] = {-1,0},
        ["p6"] = {-1,0},
        ["p1"] = {-1,0},
        ["p7"] = {-1,0},
        [0] = {0,0,0},
        ["p2"] = {-1,0}   
        },
        [-1667301416] = {
            [1] = {0, 0, 0},
            [2] = {30, 0, 0},
            [3] = {18, 0, 1},
            [4] = {100, 1, 1},
            [5] = {0, 0, 0},
            [6] = {53, 0, 1},
            [7] = {0, 0, 0},
            [8] = {56, 0, 1},
            [9] = {0, 0, 0},
            [10] = {0, 0, 0},
            [11] = {230, 20, 1},
            ['p0'] = {58, 0},
            ['p1'] = {-1, 0}
        }
    }
}

function ColocarRoupa2()
    if GetEntityHealth(PlayerPedId()) > 101 then
        if not vRP.isHandcuffed() then
            local custom = Roupafarda2['soldado']
            if custom then
                local old_custom = vRP.getCustomization()
				roupaantiga = old_custom
                local idle_copy = {}
                idle_copy.modelhash = nil
                for l, w in pairs(custom[old_custom.modelhash]) do
                    idle_copy[l] = w
                end
                FadeRoupa(1200, 1, idle_copy)
            end
        end
    end
end

local Roupafarda3 = {
    ['cabo'] = {
        [1885233650] = {
            [1] = {0,0,1},
            [2] = {19,0,0},
            [3] = {0,0,1},
            [4] = {130,1,1},
            [5] = {0,0,1},
            [6] = {24,0,1},
            [7] = {1,0,1},
            [8] = {154,0,1},
            [9] = {20,4,1},
            [10] = {0,0,0},
            [11] = {38,2,1},
            ["p0"] = {-1,0},
            ["p6"] = {-1,0},
            ["p1"] = {-1,0},
            ["p7"] = {-1,0},
            [0] = {0,0,0},
            ["p2"] = {-1,0}
        },
        [-1667301416] = {
            [1] = {0, 0, 0},
            [2] = {30, 0, 0},
            [3] = {18, 0, 1},
            [4] = {100, 1, 1},
            [5] = {0, 0, 0},
            [6] = {53, 0, 1},
            [7] = {0, 0, 0},
            [8] = {56, 0, 1},
            [9] = {0, 0, 0},
            [10] = {0, 0, 0},
            [11] = {230, 20, 1},
            ['p0'] = {58, 0},
            ['p1'] = {-1, 0}
        }
    }
}

function ColocarRoupa3()
    if GetEntityHealth(PlayerPedId()) > 101 then
        if not vRP.isHandcuffed() then
            local custom = Roupafarda3['cabo']
            if custom then
                local old_custom = vRP.getCustomization()
				roupaantiga = old_custom
                local idle_copy = {}
                idle_copy.modelhash = nil
                for l, w in pairs(custom[old_custom.modelhash]) do
                    idle_copy[l] = w
                end
                FadeRoupa(1200, 1, idle_copy)
            end
        end
    end
end

local Roupafarda4 = {
    ['sargento'] = {
        [1885233650] = {
        [1] = {0,0,1},
        [2] = {19,0,0},
        [3] = {0,0,1},
        [4] = {52,1,1},
        [5] = {0,0,1},
        [6] = {24,0,1},
        [7] = {1,0,1},
        [8] = {154,0,1},
        [9] = {20,4,1},
        [10] = {0,0,0},
        [11] = {38,3,1},
        ["p0"] = {-1,0},
        ["p6"] = {-1,0},
        ["p1"] = {-1,0},
        ["p7"] = {-1,0},
        [0] = {0,0,0},
        ["p2"] = {-1,0}
        },
        [-1667301416] = {
            [1] = {0, 0, 0},
            [2] = {30, 0, 0},
            [3] = {18, 0, 1},
            [4] = {100, 1, 1},
            [5] = {0, 0, 0},
            [6] = {53, 0, 1},
            [7] = {0, 0, 0},
            [8] = {56, 0, 1},
            [9] = {0, 0, 0},
            [10] = {0, 0, 0},
            [11] = {230, 20, 1},
            ['p0'] = {58, 0},
            ['p1'] = {-1, 0}
        }
    }
}

function ColocarRoupa4()
    if GetEntityHealth(PlayerPedId()) > 101 then
        if not vRP.isHandcuffed() then
            local custom = Roupafarda4['sargento']
            if custom then
                local old_custom = vRP.getCustomization()
				roupaantiga = old_custom
                local idle_copy = {}
                idle_copy.modelhash = nil
                for l, w in pairs(custom[old_custom.modelhash]) do
                    idle_copy[l] = w
                end
                FadeRoupa(1200, 1, idle_copy)
            end
        end
    end
end


local Roupafarda5 = {
    ['tentente'] = {
        [1885233650] = {
            [1] = {0,0,1},
            [2] = {19,0,0},
            [3] = {0,0,1},
            [4] = {87,0,1},
            [5] = {0,0,1},
            [6] = {24,0,1},
            [7] = {1,0,1},
            [8] = {154,0,1},
            [9] = {20,4,1},
            [10] = {0,0,0},
            [11] = {38,4,1},
            ["p0"] = {-1,0},
            ["p6"] = {-1,0},
            ["p1"] = {-1,0},
            ["p7"] = {-1,0},
            [0] = {0,0,0},
            ["p2"] = {-1,0}
        },
        [-1667301416] = {
            [1] = {0, 0, 0},
            [2] = {30, 0, 0},
            [3] = {18, 0, 1},
            [4] = {100, 1, 1},
            [5] = {0, 0, 0},
            [6] = {53, 0, 1},
            [7] = {0, 0, 0},
            [8] = {56, 0, 1},
            [9] = {0, 0, 0},
            [10] = {0, 0, 0},
            [11] = {230, 20, 1},
            ['p0'] = {58, 0},
            ['p1'] = {-1, 0}
        }
    }
}

function ColocarRoupa5()
    if GetEntityHealth(PlayerPedId()) > 101 then
        if not vRP.isHandcuffed() then
            local custom = Roupafarda5['tentente']
            if custom then
                local old_custom = vRP.getCustomization()
				roupaantiga = old_custom
                local idle_copy = {}
                idle_copy.modelhash = nil
                for l, w in pairs(custom[old_custom.modelhash]) do
                    idle_copy[l] = w
                end
                FadeRoupa(1200, 1, idle_copy)
            end
        end
    end
end



local Roupafarda6 = {
    ['speed'] = {
        [1885233650] = {
            [1] = {0,0,1},
            [2] = {19,0,0},
            [3] = {4,0,1},
            [4] = {9,7,1},
            [5] = {0,0,1},
            [6] = {24,0,1},
            [7] = {1,0,1},
            [8] = {0,0,1},
            [9] = {21,0,1},
            [10] = {0,0,0},
            [11] = {52,0,1},
            ["p0"] = {-1,0},
            ["p6"] = {-1,0},
            ["p1"] = {-1,0},
            ["p7"] = {-1,0},
            [0] = {0,0,0},
            ["p2"] = {-1,0}
        },
        [-1667301416] = {
            [1] = {0, 0, 0},
            [2] = {30, 0, 0},
            [3] = {18, 0, 1},
            [4] = {100, 1, 1},
            [5] = {0, 0, 0},
            [6] = {53, 0, 1},
            [7] = {0, 0, 0},
            [8] = {56, 0, 1},
            [9] = {0, 0, 0},
            [10] = {0, 0, 0},
            [11] = {230, 20, 1},
            ['p0'] = {58, 0},
            ['p1'] = {-1, 0}
        }
    }
}

function ColocarRoupa6()
    if GetEntityHealth(PlayerPedId()) > 101 then
        if not vRP.isHandcuffed() then
            local custom = Roupafarda6['speed']
            if custom then
                local old_custom = vRP.getCustomization()
				roupaantiga = old_custom
                local idle_copy = {}
                idle_copy.modelhash = nil
                for l, w in pairs(custom[old_custom.modelhash]) do
                    idle_copy[l] = w
                end
                FadeRoupa(1200, 1, idle_copy)
            end
        end
    end
end

local Roupafarda7 = {
    ['gtm'] = {
        [1885233650] = {
            [1] = {0,0,1},
            [2] = {19,0,0},
            [3] = {21,0,1},
            [4] = {129,4,1},
            [5] = {0,0,1},
            [6] = {24,0,1},
            [7] = {1,0,1},
            [8] = {15,0,1},
            [9] = {20,4,1},
            [10] = {0,0,0},
            [11] = {97,0,1},
            ["p0"] = {62,8},
            ["p6"] = {-1,0},
            ["p1"] = {-1,0},
            ["p7"] = {-1,0},
            [0] = {0,0,0},
            ["p2"] = {-1,0}
        },
        [-1667301416] = {
            [1] = {0, 0, 0},
            [2] = {30, 0, 0},
            [3] = {18, 0, 1},
            [4] = {100, 1, 1},
            [5] = {0, 0, 0},
            [6] = {53, 0, 1},
            [7] = {0, 0, 0},
            [8] = {56, 0, 1},
            [9] = {0, 0, 0},
            [10] = {0, 0, 0},
            [11] = {230, 20, 1},
            ['p0'] = {58, 0},
            ['p1'] = {-1, 0}
        }
    }
}

function ColocarRoupa7()
    if GetEntityHealth(PlayerPedId()) > 101 then
        if not vRP.isHandcuffed() then
            local custom = Roupafarda7['gtm']
            if custom then
                local old_custom = vRP.getCustomization()
				roupaantiga = old_custom
                local idle_copy = {}
                idle_copy.modelhash = nil
                for l, w in pairs(custom[old_custom.modelhash]) do
                    idle_copy[l] = w
                end
                FadeRoupa(1200, 1, idle_copy)
            end
        end
    end
end


local Roupafarda8 = {
    ['graer'] = {
        [1885233650] = {
            [1] = {0,0,1},
            [2] = {19,0,0},
            [3] = {21,0,1},
            [4] = {87,0,1},
            [5] = {0,0,1},
            [6] = {24,0,1},
            [7] = {1,0,1},
            [8] = {15,0,1},
            [9] = {20,4,1},
            [10] = {0,0,0},
            [11] = {97,1,1},
            ["p0"] = {19,0},
            ["p6"] = {-1,0},
            ["p1"] = {-1,0},
            ["p7"] = {-1,0},
            [0] = {0,0,0},
            ["p2"] = {-1,0}
        },
        [-1667301416] = {
            [1] = {0, 0, 0},
            [2] = {30, 0, 0},
            [3] = {18, 0, 1},
            [4] = {100, 1, 1},
            [5] = {0, 0, 0},
            [6] = {53, 0, 1},
            [7] = {0, 0, 0},
            [8] = {56, 0, 1},
            [9] = {0, 0, 0},
            [10] = {0, 0, 0},
            [11] = {230, 20, 1},
            ['p0'] = {58, 0},
            ['p1'] = {-1, 0}
        }
    }
}

function ColocarRoupa8()
    if GetEntityHealth(PlayerPedId()) > 101 then
        if not vRP.isHandcuffed() then
            local custom = Roupafarda8['graer']
            if custom then
                local old_custom = vRP.getCustomization()
				roupaantiga = old_custom
                local idle_copy = {}
                idle_copy.modelhash = nil
                for l, w in pairs(custom[old_custom.modelhash]) do
                    idle_copy[l] = w
                end
                FadeRoupa(1200, 1, idle_copy)
            end
        end
    end
end


local Roupafarda9 = {
    ['got'] = {
        [1885233650] = {
            [1] = {0,0,1},
            [2] = {19,0,0},
            [3] = {22,0,1},
            [4] = {87,0,1},
            [5] = {0,0,1},
            [6] = {24,0,1},
            [7] = {1,0,1},
            [8] = {87,0,1},
            [9] = {20,0,1},
            [10] = {0,0,0},
            [11] = {258,0,1},
            ["p0"] = {8,0},
            ["p6"] = {-1,0},
            ["p1"] = {-1,0},
            ["p7"] = {-1,0},
            [0] = {0,0,0},
            ["p2"] = {-1,0}
        },
        [-1667301416] = {
            [1] = {0, 0, 0},
            [2] = {30, 0, 0},
            [3] = {18, 0, 1},
            [4] = {100, 1, 1},
            [5] = {0, 0, 0},
            [6] = {53, 0, 1},
            [7] = {0, 0, 0},
            [8] = {56, 0, 1},
            [9] = {0, 0, 0},
            [10] = {0, 0, 0},
            [11] = {230, 20, 1},
            ['p0'] = {58, 0},
            ['p1'] = {-1, 0}
        }
    }
}

function ColocarRoupa9()
    if GetEntityHealth(PlayerPedId()) > 101 then
        if not vRP.isHandcuffed() then
            local custom = Roupafarda9['got']
            if custom then
                local old_custom = vRP.getCustomization()
				roupaantiga = old_custom
                local idle_copy = {}
                idle_copy.modelhash = nil
                for l, w in pairs(custom[old_custom.modelhash]) do
                    idle_copy[l] = w
                end
                FadeRoupa(1200, 1, idle_copy)
            end
        end
    end
end

local Roupafarda10 = {
    ['medico'] = {
        [1885233650] = {
            [1] = {0,0,1},
            [2] = {19,0,0},
            [3] = {4,0,1},
            [4] = {20,0,1},
            [5] = {0,0,1},
            [6] = {21,0,1},
            [7] = {126,0,1},
            [8] = {11,0,1},
            [9] = {0,0,1},
            [10] = {0,0,0},
            [11] = {142,0,1},
            [0] = {0,0,0},
            ["p6"] = {-1,0},
            ["p7"] = {-1,0},
            ["p0"] = {-1,0},
            ["p1"] = {0,0},
            ["p2"] = {-1,0}
        },
        [-1667301416] = {
            [1] = {0,0,1},
            [2] = {0,0,0},
            [3] = {105,0,1},
            [4] = {23,0,1},
            [5] = {0,0,1},
            [6] = {14,3,1},
            [7] = {96,0,1},
            [8] = {0,0,1},
            [9] = {0,0,1},
            [10] = {0,0,0},
            [11] = {7,1,1},
            ["p7"] = {-1,0},
            [0] = {0,0,0},
            ["p6"] = {-1,0},
            ["p1"] = {37,0},
            ["p0"] = {-1,0},
            ["p2"] = {-1,0},
        }
    }
}

function ColocarRoupa10()
    if GetEntityHealth(PlayerPedId()) > 101 then
        if not vRP.isHandcuffed() then
            local custom = Roupafarda10['medico']
            if custom then
                local old_custom = vRP.getCustomization()
				roupaantiga = old_custom
                local idle_copy = {}
                idle_copy.modelhash = nil
                for l, w in pairs(custom[old_custom.modelhash]) do
                    idle_copy[l] = w
                end
                FadeRoupa(1200, 1, idle_copy)
            end
        end
    end
end


local Roupafarda11 = {
    ['enfermeiro'] = {
        [1885233650] = {
            [1] = {0,0,1},
            [2] = {19,0,0},
            [3] = {88,0,1},
            [4] = {20,0,1},
            [5] = {0,0,1},
            [6] = {8,0,1},
            [7] = {127,0,1},
            [8] = {0,0,1},
            [9] = {0,0,1},
            [10] = {0,0,0},
            [11] = {387,10,1},
            [0] = {0,0,0},
            ["p6"] = {-1,0},
            ["p7"] = {-1,0},
            ["p0"] = {-1,0},
            ["p1"] = {0,0},
            ["p2"] = {-1,0}
        },
        [-1667301416] = {
            [1] = {0,0,1},
            [2] = {0,0,0},
            [3] = {105,0,1},
            [4] = {23,0,1},
            [5] = {0,0,1},
            [6] = {14,3,1},
            [7] = {96,0,1},
            [8] = {0,0,1},
            [9] = {0,0,1},
            [10] = {0,0,0},
            [11] = {7,1,1},
            ["p7"] = {-1,0},
            [0] = {0,0,0},
            ["p6"] = {-1,0},
            ["p1"] = {37,0},
            ["p0"] = {-1,0},
            ["p2"] = {-1,0},
        }
    }
}

function ColocarRoupa11()
    if GetEntityHealth(PlayerPedId()) > 101 then
        if not vRP.isHandcuffed() then
            local custom = Roupafarda11['enfermeiro']
            if custom then
                local old_custom = vRP.getCustomization()
				roupaantiga = old_custom
                local idle_copy = {}
                idle_copy.modelhash = nil
                for l, w in pairs(custom[old_custom.modelhash]) do
                    idle_copy[l] = w
                end
                FadeRoupa(1200, 1, idle_copy)
            end
        end
    end
end


function MainRoupa()
    if vRP.getHealth() > 101 then
        if not vRP.isHandcuffed() then
            FadeRoupa(1200, 2)
        end
    end
end

RegisterNetEvent("inventory:farda1on")
AddEventHandler("inventory:farda1on",function()
	ColocarRoupa1()
end)

RegisterNetEvent("inventory:farda2on")
AddEventHandler("inventory:farda2on",function()
	ColocarRoupa2()
end)

RegisterNetEvent("inventory:farda3on")
AddEventHandler("inventory:farda3on",function()
	ColocarRoupa3()
end)

RegisterNetEvent("inventory:farda4on")
AddEventHandler("inventory:farda4on",function()
	ColocarRoupa4()
end)

RegisterNetEvent("inventory:farda5on")
AddEventHandler("inventory:farda5on",function()
	ColocarRoupa5()
end)

RegisterNetEvent("inventory:farda6on")
AddEventHandler("inventory:farda6on",function()
	ColocarRoupa6()
end)

RegisterNetEvent("inventory:farda7on")
AddEventHandler("inventory:farda7on",function()
	ColocarRoupa7()
end)

RegisterNetEvent("inventory:farda8on")
AddEventHandler("inventory:farda8on",function()
	ColocarRoupa8()
end)

RegisterNetEvent("inventory:farda9on")
AddEventHandler("inventory:farda9on",function()
	ColocarRoupa9()
end)

RegisterNetEvent("inventory:farda10on")
AddEventHandler("inventory:farda10on",function()
	ColocarRoupa10()
end)


RegisterNetEvent("inventory:farda11on")
AddEventHandler("inventory:farda11on",function()
	ColocarRoupa11()
end)
 -- ColocarRoupa5

RegisterNetEvent("inventory:fardaoff")
AddEventHandler("inventory:fardaoff",function()
	MainRoupa()
end)


function MainRoupa()
    if vRP.getHealth() > 101 then
        if not vRP.isHandcuffed() then
            FadeRoupa(1200, 2)
        end
    end
end




local carryingBackInProgress = false

RegisterNetEvent('carregarcomcordas')
AddEventHandler('carregarcomcordas', function(source)
	if not carryingBackInProgress then
		--if src.checkItem() then
			carryingBackInProgress = true
			local player = PlayerPedId()
			TriggerEvent('cancelando',true)	
			lib = 'missfinale_c2mcs_1'
			anim1 = 'fin_c2_mcs_1_camman'
			lib2 = 'nm'
			anim2 = 'firemans_carry'
			distans = 0.15
			distans2 = 0.27
			height = 0.63
			spin = 0.0		
			length = 100000
			controlFlagMe = 49
			controlFlagTarget = 33
			animFlagTarget = 1
			local closestPlayer = GetClosestPlayer(3)
			target = GetPlayerServerId(closestPlayer)
			if closestPlayer ~= nil then
				TriggerServerEvent('cmg2_animations:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
			else
			 	TriggerClientEvent("Notify","negado","Nenhum player proximo para ser <b>Carregado</b>.")
			end
		--else
		--	print('Voce nao tem cordas')
		--
	else
		carryingBackInProgress = false
		TriggerEvent('cancelando',false)	
		ClearPedSecondaryTask(GetPlayerPed(-1))
		DetachEntity(GetPlayerPed(-1), true, false)
		local closestPlayer = GetClosestPlayer(3)
		target = GetPlayerServerId(closestPlayer)
		TriggerServerEvent("cmg2_animations:stop",target)
	end
end,false)


-- GETCLOSESTPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
function GetClosestPlayer(radius)
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)

    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords['x'], targetCoords['y'], targetCoords['z'], plyCoords['x'], plyCoords['y'], plyCoords['z'], true)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
	if closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end


function GetPlayers()
	local players = {}
	
    for _, player in ipairs(GetActivePlayers()) do
      table.insert(players, player)
    end

    return players
end
