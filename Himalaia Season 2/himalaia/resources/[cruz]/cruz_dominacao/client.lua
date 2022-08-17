local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
gn = Tunnel.getInterface("cruz_dominacao",gn)

-------------------------------------------------------------
-- VARIAVEIS
-------------------------------------------------------------
local segundos = 0 
local pegando = false 

-------------------------------------------------------------
-- COORDENADAS
-------------------------------------------------------------
local locais = {
    -- DROGAS

    [1] = { ['x'] = 38.89, ['y'] = 3666.48, ['z'] = 39.58, ['perm'] = "drogas.permissao", ['blip'] = 1},

    -- ARMAS

    [5] = { ['x'] = 2664.13, ['y'] = 1642.32, ['z'] = 24.88, ['perm'] = "armas.permissao", ['blip'] = 1},

    -- MUNICAO

    [9] = { ['x'] = 1488.17, ['y'] = 1128.32, ['z'] = 114.34, ['perm'] = "municoes.permissao", ['blip'] = 1},

    -- LAVAGEM
    
    [13] = { ['x'] = 305.48, ['y'] = 2892.99, ['z'] = 43.6, ['perm'] = "lavagem.permissao", ['blip'] = 1},

}

Citizen.CreateThread(function()
    while true do
        local timeDistance = 1000
        local ped = GetPlayerPed(-1)
        local x,y,z = table.unpack(GetEntityCoords(ped))
        for k,v in pairs(locais) do
            local dist = GetDistanceBetweenCoords(v.x, v.y, v.z, x, y, z, true)
            if dist <= 15 and not pegando then
                timeDistance = 4
                DrawMarker(23,v.x,v.y,v.z-1,0,0,0,0.0,0,0,1.5,1.5,1.5,255,0,0,50,0,0,0,1)
                if IsControlJustPressed(0, 38) and gn.permissao(v.perm) and dist <= 1 then
                    if gn.lootear(k) then
                        pegando = true 
                        TriggerEvent('cancelando',true)
                        FreezeEntityPosition(ped, true)
                        vRP._playAnim(false,{{"anim@heists@ornate_bank@grab_cash_heels","grab"}},true)
                        TriggerEvent("progress", 13000, "pegando")
                        SetTimeout(13000, function()
                            FreezeEntityPosition(ped, false)
                            vRP._stopAnim(false)
                            gn.pagamento(v.perm,v.blip,k)
                            TriggerEvent('cancelando',false)
                            pegando = false
                        end)
                    else
                        TriggerEvent("Notify","negado","Já coletaram o farm!")
                    end            
                end    
            end    
        end
        Citizen.Wait(timeDistance)
    end    
end) 

