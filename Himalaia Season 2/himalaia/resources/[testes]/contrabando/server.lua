local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

src = {}
Tunnel.bindInterface("contrabando", src)
clientAPI = Tunnel.getInterface("contrabando")

--[[ local dsmkfskmfskmf = false

local function sucesso(body)
    dsmkfskmfskmf = true
    print('SCRIPT AUTENTICADO')
    --dsmkfskmfskmf = true
    -- Função de sucesso para você executar a ação quiser que aconteça 
    -- deve ficar no arquivo principal do server-side, aquele que você vai mandar ao bot para colocar a autenticação
    -- essa função serve para você setar as variáveis de autenticação do seu código, como verdadeiras, por exemplo.
    -- lembre-se, importante deixá-la local, e atenção para infratores não descubrirem as variáveis de autenticação externamente
end

local function erro(body)
    dsmkfskmfskmf = false
    print('SCRIPT NÃO AUTORIZADO,ENTRE EM CONTATO COM O DESENVOLVEDOR "xuxucão#7119')
    print('SCRIPT NÃO AUTORIZADO,ENTRE EM CONTATO COM O DESENVOLVEDOR "xuxucão#7119')
    print('SCRIPT NÃO AUTORIZADO,ENTRE EM CONTATO COM O DESENVOLVEDOR "xuxucão#7119')
    print('SCRIPT NÃO AUTORIZADO,ENTRE EM CONTATO COM O DESENVOLVEDOR "xuxucão#7119')
    print('SCRIPT NÃO AUTORIZADO,ENTRE EM CONTATO COM O DESENVOLVEDOR "xuxucão#7119')
    print('SCRIPT NÃO AUTORIZADO,ENTRE EM CONTATO COM O DESENVOLVEDOR "xuxucão#7119')
    print('SCRIPT NÃO AUTORIZADO,ENTRE EM CONTATO COM O DESENVOLVEDOR "xuxucão#7119')
    print('SCRIPT NÃO AUTORIZADO,ENTRE EM CONTATO COM O DESENVOLVEDOR "xuxucão#7119')
    print('SCRIPT NÃO AUTORIZADO,ENTRE EM CONTATO COM O DESENVOLVEDOR "xuxucão#7119')
    print('SCRIPT NÃO AUTORIZADO,ENTRE EM CONTATO COM O DESENVOLVEDOR "xuxucão#7119')
    print('SCRIPT NÃO AUTORIZADO,ENTRE EM CONTATO COM O DESENVOLVEDOR "xuxucão#7119')
    print('SCRIPT NÃO AUTORIZADO,ENTRE EM CONTATO COM O DESENVOLVEDOR "xuxucão#7119')
    print('SCRIPT NÃO AUTORIZADO,ENTRE EM CONTATO COM O DESENVOLVEDOR "xuxucão#7119')
    print('SCRIPT NÃO AUTORIZADO,ENTRE EM CONTATO COM O DESENVOLVEDOR "xuxucão#7119')
    print('SCRIPT NÃO AUTORIZADO,ENTRE EM CONTATO COM O DESENVOLVEDOR "xuxucão#7119')
    print('SCRIPT NÃO AUTORIZADO,ENTRE EM CONTATO COM O DESENVOLVEDOR "xuxucão#7119')
    print('SCRIPT NÃO AUTORIZADO,ENTRE EM CONTATO COM O DESENVOLVEDOR "xuxucão#7119')

    Wait(15000)
    os.exit()
end

local function timeout(body)
    print(body.err)
    print(body.err)
    print(body.err)
    print(body.err)
    print(body.err)
    print(body.err)
    print(body.err)
    print(body.err)
    print(body.err)
    print(body.err)
    print(body.err)

    -- Função de timeout para você executar a ação quiser que aconteça 
    -- deve ficar no arquivo principal do server-side, aquele que você vai mandar ao bot para colocar a autenticação
    -- nessa função, é interessante que você execute a ação que quiser quando a autenticação não receber resposta da api
    -- lembre-se, importante deixá-la local
    -- o erro nesse caso sempre será "E_TIMEDOUT", e será especificado também por "body.err"
end
 ]]
function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end



    local items = {
        ["Drogas3"] = {
            items = { 
                ["cocaina"] = { name = vRP.itemNameList("cocaina") },
            }
        },
        ["Drogas1"] = {
            items = { 
                ["maconha"] = { name = vRP.itemNameList("maconha") },
            }
        },
        ["Drogas2"] = {
            items = { 
                ["metanfetamina"] = { name = vRP.itemNameList("metanfetamina") },
            }
        },
        ["Drogas4"] = {
            items = { 
                ["ecstasy"] = { name = vRP.itemNameList("ecstasy") },
            }
        },
        ["mafia1"] = {
            items = {
                ["m-glock"] = { name = vRP.itemNameList("wammo_WEAPON_PISTOL_MK2") },
            }
        },
        ["mafia2"] = {
            items = {
                ["m-glock"] = { name = vRP.itemNameList("wammo_WEAPON_PISTOL_MK2") },
            }
        },
        ["armas1"] = {
            items = {
                ["fiveseven"] = { name = vRP.itemNameList("wbody_WEAPON_PISTOL_MK2") },
            }
        },
        ["armas2"] = {
            items = {
                ["fiveseven"] = { name = vRP.itemNameList("wbody_WEAPON_PISTOL_MK2") }
            }
        }
    } 

-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function paymentFac(QualFac,qtd)
    local source = source
    local user_id = vRP.getUserId(source)
    local value = vRP.getSData('xuxuco:SaldoDeVendas'..QualFac)
    local resultado = json.decode(value) or 0

    if QualFac == 'Drogas1' then
        vRP.setSData('xuxuco:SaldoDeVendas'..'Drogas1',resultado+qtd)

    elseif QualFac == 'Drogas3' then
        vRP.setSData('xuxuco:SaldoDeVendas'..'Drogas2',resultado+qtd)

    elseif QualFac == 'Drogas2' then
        vRP.setSData('xuxuco:SaldoDeVendas'..'Drogas2',resultado+qtd)
    elseif QualFac == 'Armas1' then
        vRP.setSData('xuxuco:SaldoDeVendas'..'Armas1',resultado+qtd)
    elseif QualFac == 'Armas2' then
        vRP.setSData('xuxuco:SaldoDeVendas'..'Armas2',resultado+qtd)
    elseif QualFac == 'Muni1' then
        vRP.setSData('xuxuco:SaldoDeVendas'..'Muni1',resultado+qtd)
    elseif QualFac == 'Muni2' then
        vRP.setSData('xuxuco:SaldoDeVendas'..'Muni2',resultado+qtd)
    end
end

function src.getItems(type)
    return items[type].items
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK ESTOQUE
-----------------------------------------------------------------------------------------------------------------------------------------
function src.muni1(item)
    local source = source 
    local user_id = vRP.getUserId(source)
    local quantia = vRP.prompt(source, 'QUANTIDADE', '')
    local data = vRP.getSData("chest:"..config.bauMAFIADEMUNI1)
	local items = json.decode(data) or {}
    local identity = vRP.getUserIdentity(user_id)


    if user_id then
        
        if item == 'm-glock' then
            if items['wammo_WEAPON_PISTOL_MK2'] ~= nil and parseInt(items['wammo_WEAPON_PISTOL_MK2'].amount) >= parseInt(quantia) then
                    items['wammo_WEAPON_PISTOL_MK2'].amount = parseInt(items['wammo_WEAPON_PISTOL_MK2'].amount) - parseInt(quantia)
                if vRP.tryFullPayment(user_id, parseInt(quantia) * config.valorMUNIFIVE) then
                    vRP.giveInventoryItem(user_id, "wammo_WEAPON_PISTOL_MK2", quantia)
                    paymentFac('Muni1',quantia * config.valorMUNIFIVE)
                    vRP.setSData("chest:"..config.bauMAFIADEMUNI1,json.encode(items))


                    
                    SendWebhookMessage(config.WebhookMuni1,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: MUNIÇÃO DE FIVE SEVEN\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
                else
                    TriggerClientEvent('Notify',source,'aviso','Você não possui dinheiro insuficiente')
                end
            else
                TriggerClientEvent('Notify',source,'aviso','Não há essa quantidade no estoque. ')
            end
        elseif item == 'm-shotgun' then
            if items['wammo_WEAPON_SAWNOFFSHOTGUN'] ~= nil and parseInt(items['wammo_WEAPON_SAWNOFFSHOTGUN'].amount) >= parseInt(quantia) then
                items['wammo_WEAPON_SAWNOFFSHOTGUN'].amount = parseInt(items['wammo_WEAPON_SAWNOFFSHOTGUN'].amount) - parseInt(quantia)
                if vRP.tryFullPayment(user_id, parseInt(quantia) * config.valorMUNIDOZE) then
                    vRP.giveInventoryItem(user_id, "wammo_WEAPON_SAWNOFFSHOTGUN", quantia)
                    paymentFac('Muni1',quantia * config.valorDOZE)
                    vRP.setSData("chest:"..config.bauMAFIADEMUNI1,json.encode(items),json.encode(items))


                    SendWebhookMessage(config.WebhookMuni1,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: MUNIÇÃO DE DOZE\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

                else
                    TriggerClientEvent('Notify',source,'aviso','Você não possui dinheiro insuficiente')
                end
            else
                TriggerClientEvent('Notify',source,'aviso','Não há essa quantidade no estoque. ')
            end
        elseif item == 'm-skorpionv61' then
            if items['wammo_WEAPON_MACHINEPISTOL'] ~= nil and parseInt(items['wammo_WEAPON_MACHINEPISTOL'].amount) >= parseInt(quantia) then
                items['wammo_WEAPON_MACHINEPISTOL'].amount = parseInt(items['wammo_WEAPON_MACHINEPISTOL'].amount) - parseInt(quantia)
                if vRP.tryFullPayment(user_id, parseInt(quantia) * config.valorMUNITEC9) then
                    vRP.giveInventoryItem(user_id, "wammo_WEAPON_MACHINEPISTOL", quantia)
                    paymentFac('Muni1',quantia * config.valorMUNITEC9)
                    vRP.setSData("chest:"..config.bauMAFIADEMUNI1,json.encode(items),json.encode(items))


                    SendWebhookMessage(config.WebhookMuni1,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: MUNIÇÃO DE TEC9\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

                else
                    TriggerClientEvent('Notify',source,'aviso','Você não possui dinheiro insuficiente')
                end
            else
                TriggerClientEvent('Notify',source,'aviso','Não há essa quantidade no estoque. ')
            end
        elseif item == 'm-g36mk2' then
            if items['wammo_WEAPON_SPECIALCARBINE_MK2'] ~= nil and parseInt(items['wammo_WEAPON_SPECIALCARBINE_MK2'].amount) >= parseInt(quantia) then
                items['wammo_WEAPON_SPECIALCARBINE_MK2'].amount = parseInt(items['wammo_WEAPON_SPECIALCARBINE_MK2'].amount) - parseInt(quantia)
                if vRP.tryFullPayment(user_id, parseInt(quantia) * config.valorMUNIG3) then
                    vRP.giveInventoryItem(user_id, "wammo_WEAPON_SPECIALCARBINE_MK2", quantia)
                    paymentFac('Muni1',quantia * config.valorMUNIG3)
                    vRP.setSData("chest:"..config.bauMAFIADEMUNI1,json.encode(items),json.encode(items))


                    SendWebhookMessage(config.WebhookMuni1,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: MUNIÇÃO DE G36\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

                else
                    TriggerClientEvent('Notify',source,'aviso','Você não possui dinheiro insuficiente')
                end
            end
        elseif item == 'm-mpx' then
            if items['wammo_WEAPON_ASSAULTRIFLE_MK2'] ~= nil and parseInt(items['wammo_WEAPON_ASSAULTRIFLE_MK2'].amount) >= parseInt(quantia) then
                items['wammo_WEAPON_ASSAULTRIFLE_MK2'].amount = parseInt(items['wammo_WEAPON_ASSAULTRIFLE_MK2'].amount) - parseInt(quantia)
                vRP.setSData("chest:"..config.bauMAFIADEMUNI1,json.encode(items),json.encode(items))
                if vRP.tryFullPayment(user_id, parseInt(quantia) * config.valorMUNIAK) then
                    vRP.giveInventoryItem(user_id, "wammo_WEAPON_ASSAULTRIFLE_MK2", quantia)
                    paymentFac('Muni1',quantia * config.valorMUNIAK)
                    vRP.setSData("chest:"..config.bauMAFIADEMUNI1,json.encode(items),json.encode(items))

                    SendWebhookMessage(config.WebhookMuni1,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: MUNIÇÃO DE AK-47\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

                end
            else
                TriggerClientEvent('Notify',source,'aviso','Não há essa quantidade no estoque. ')
            end
        elseif item == 'm-mp5mk2' then
            if items['wammo_WEAPON_SMG_MK2'] ~= nil and parseInt(items['wammo_WEAPON_SMG_MK2'].amount) >= parseInt(quantia) and parseInt(items['wammo_WEAPON_SMG_MK2'].amount) > 0  then
                items['wammo_WEAPON_SMG_MK2'].amount = parseInt(items['wammo_WEAPON_SMG_MK2'].amount) - parseInt(quantia)
                if vRP.tryFullPayment(user_id, parseInt(quantia) * config.valorMUNIMP5) then
                    vRP.giveInventoryItem(user_id, "wammo_WEAPON_SMG_MK2", quantia)
                    paymentFac('Muni1',quantia * config.valorMUNIMP5)
                    vRP.setSData("chest:"..config.bauMAFIADEMUNI1,json.encode(items),json.encode(items))

                    SendWebhookMessage(config.WebhookMuni1,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: MUNIÇÃO DE MP5 MK2\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

                else
                    TriggerClientEvent('Notify',source,'aviso','Você não possui dinheiro insuficiente')
                end
            else
                TriggerClientEvent('Notify',source,'aviso','Não há essa quantidade no estoque. ')
            end
        end
    end
end

function src.muni2(item)
    local source = source 
    local user_id = vRP.getUserId(source)
    local quantia = vRP.prompt(source, 'QUANTIDADE', '')
    local data = vRP.getSData("chest:"..config.bauMAFIADEMUNI2)
	local items = json.decode(data) or {}
    local identity = vRP.getUserIdentity(user_id)


    if user_id then
        
        if item == 'm-glock' then
            if items['wammo_WEAPON_PISTOL_MK2'] ~= nil and parseInt(items['wammo_WEAPON_PISTOL_MK2'].amount) >= parseInt(quantia) then
                    items['wammo_WEAPON_PISTOL_MK2'].amount = parseInt(items['wammo_WEAPON_PISTOL_MK2'].amount) - parseInt(quantia)
                if vRP.tryFullPayment(user_id, parseInt(quantia) * config.valorMUNIFIVE) then
                    vRP.giveInventoryItem(user_id, "wammo_WEAPON_PISTOL_MK2", quantia)
                    vRP.setSData("chest:"..config.bauMAFIADEMUNI2,json.encode(items),json.encode(items))

                    paymentFac('Muni2',quantia * config.valorMUNIFIVE)

                    SendWebhookMessage(config.WebhookMuni2,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: MUNIÇÃO DE FIVE SEVEN\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
                else
                    TriggerClientEvent('Notify',source,'aviso','Você não possui dinheiro insuficiente')
                end
            else
                TriggerClientEvent('Notify',source,'aviso','Não há essa quantidade no estoque. ')
            end
        elseif item == 'm-shotgun' then
            if items['wammo_WEAPON_SAWNOFFSHOTGUN'] ~= nil and parseInt(items['wammo_WEAPON_SAWNOFFSHOTGUN'].amount) >= parseInt(quantia) then
                items['wammo_WEAPON_SAWNOFFSHOTGUN'].amount = parseInt(items['wammo_WEAPON_SAWNOFFSHOTGUN'].amount) - parseInt(quantia)
                if vRP.tryFullPayment(user_id, parseInt(quantia) * config.valorMUNIDOZE) then
                    vRP.giveInventoryItem(user_id, "wammo_WEAPON_SAWNOFFSHOTGUN", quantia)
                    paymentFac('Muni2',quantia * config.valorMUNIDOZE)
                    vRP.setSData("chest:"..config.bauMAFIADEMUNI2,json.encode(items),json.encode(items))


                    SendWebhookMessage(config.WebhookMuni2,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: MUNIÇÃO DE DOZE\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

                else
                    TriggerClientEvent('Notify',source,'aviso','Você não possui dinheiro insuficiente')
                end
            else
                TriggerClientEvent('Notify',source,'aviso','Não há essa quantidade no estoque. ')
            end
        elseif item == 'm-skorpionv61' then
            if items['wammo_WEAPON_MACHINEPISTOL'] ~= nil and parseInt(items['wammo_WEAPON_MACHINEPISTOL'].amount) >= parseInt(quantia) then
                items['wammo_WEAPON_MACHINEPISTOL'].amount = parseInt(items['wammo_WEAPON_MACHINEPISTOL'].amount) - parseInt(quantia)
                if vRP.tryFullPayment(user_id, parseInt(quantia) * config.valorMUNITEC9) then
                    vRP.giveInventoryItem(user_id, "wammo_WEAPON_MACHINEPISTOL", quantia)
                    paymentFac('Muni2',quantia * config.valorMUNITEC9)
                    vRP.setSData("chest:"..config.bauMAFIADEMUNI2,json.encode(items),json.encode(items))
                    SendWebhookMessage(config.WebhookMuni2,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: MUNIÇÃO DE TEC9\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

                else
                    TriggerClientEvent('Notify',source,'aviso','Você não possui dinheiro insuficiente')
                end
            else
                TriggerClientEvent('Notify',source,'aviso','Não há essa quantidade no estoque. ')
            end
        elseif item == 'm-g36mk2' then
            if items['wammo_WEAPON_SPECIALCARBINE_MK2'] ~= nil and parseInt(items['wammo_WEAPON_SPECIALCARBINE_MK2'].amount) >= parseInt(quantia) then
                items['wammo_WEAPON_SPECIALCARBINE_MK2'].amount = parseInt(items['wammo_WEAPON_SPECIALCARBINE_MK2'].amount) - parseInt(quantia)
                if vRP.tryFullPayment(user_id, parseInt(quantia) * config.valorMUNIG3) then
                    vRP.giveInventoryItem(user_id, "wammo_WEAPON_SPECIALCARBINE_MK2", quantia)
                    paymentFac('Muni2',quantia * config.valorMUNIG3)
                    vRP.setSData("chest:"..config.bauMAFIADEMUNI2,json.encode(items),json.encode(items))


                    SendWebhookMessage(config.WebhookMuni2,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: MUNIÇÃO DE G36\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

                else
                    TriggerClientEvent('Notify',source,'aviso','Você não possui dinheiro insuficiente')
                end
            end
        elseif item == 'm-mpx' then
            if items['wammo_WEAPON_ASSAULTRIFLE_MK2'] ~= nil and parseInt(items['wammo_WEAPON_ASSAULTRIFLE_MK2'].amount) >= parseInt(quantia) then
                items['wammo_WEAPON_ASSAULTRIFLE_MK2'].amount = parseInt(items['wammo_WEAPON_ASSAULTRIFLE_MK2'].amount) - parseInt(quantia)
                if vRP.tryFullPayment(user_id, parseInt(quantia) * config.valorMUNIAK) then
                    vRP.giveInventoryItem(user_id, "wammo_WEAPON_ASSAULTRIFLE_MK2", quantia)
                    paymentFac('Muni2',quantia * config.valorMUNIAK)
                    vRP.setSData("chest:"..config.bauMAFIADEMUNI2,json.encode(items),json.encode(items))


                    SendWebhookMessage(config.WebhookMuni2,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: MUNIÇÃO DE AK-47\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

                end
            else
                TriggerClientEvent('Notify',source,'aviso','Não há essa quantidade no estoque. ')
            end
        elseif item == 'm-mp5mk2' then
            if items['wammo_WEAPON_SMG_MK2'] ~= nil and parseInt(items['wammo_WEAPON_SMG_MK2'].amount) >= parseInt(quantia) and parseInt(items['wammo_WEAPON_SMG_MK2'].amount) > 0  then
                items['wammo_WEAPON_SMG_MK2'].amount = parseInt(items['wammo_WEAPON_SMG_MK2'].amount) - parseInt(quantia)
                if vRP.tryFullPayment(user_id, parseInt(quantia) * config.valorMUNIMP5) then
                    vRP.giveInventoryItem(user_id, "wammo_WEAPON_SMG_MK2", quantia)
                    paymentFac('Muni2',quantia * config.valorMUNIMP5)
                    vRP.setSData("chest:"..config.bauMAFIADEMUNI2,json.encode(items),json.encode(items))

                    SendWebhookMessage(config.WebhookMuni2,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: MUNIÇÃO DE MP5 MK2\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

                else
                    TriggerClientEvent('Notify',source,'aviso','Você não possui dinheiro insuficiente')
                end
            else
                TriggerClientEvent('Notify',source,'aviso','Não há essa quantidade no estoque. ')
            end
        end
    end
end

function src.armas1(item)
    local source = source 
    local user_id = vRP.getUserId(source)
    local quantia = vRP.prompt(source, 'QUANTIDADE', '')
    local data = vRP.getSData("chest:"..config.bauMAFIADEARMAS1)
	local items = json.decode(data) or {}
    local identity = vRP.getUserIdentity(user_id)


    if user_id then
        
        if item == 'fiveseven' then
            if items['wbody_WEAPON_PISTOL_MK2'] ~= nil and parseInt(items['wbody_WEAPON_PISTOL_MK2'].amount) >= parseInt(quantia) then
                    items['wbody_WEAPON_PISTOL_MK2'].amount = parseInt(items['wbody_WEAPON_PISTOL_MK2'].amount) - parseInt(quantia)
                if vRP.tryFullPayment(user_id, parseInt(quantia) * config.valorFIVE) then
                    vRP.giveInventoryItem(user_id, "wbody_WEAPON_PISTOL_MK2", quantia)
                    paymentFac('Armas1',quantia * config.valorFIVE)
                    vRP.setSData("chest:"..config.bauMAFIADEARMAS1,json.encode(items))
                    SendWebhookMessage(config.WebhookArmas1,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: FIVE SEVEN\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

                else
                    TriggerClientEvent('Notify',source,'aviso','Você não possui dinheiro insuficiente')
                end
            else
                TriggerClientEvent('Notify',source,'aviso','Não há essa quantidade no estoque. ')
            end
        elseif item == 'remington' then
            if items['wbody_WEAPON_SAWNOFFSHOTGUN'] ~= nil and parseInt(items['wbody_WEAPON_SAWNOFFSHOTGUN'].amount) >= parseInt(quantia) then
                items['wbody_WEAPON_SAWNOFFSHOTGUN'].amount = parseInt(items['wbody_WEAPON_SAWNOFFSHOTGUN'].amount) - parseInt(quantia)
                if vRP.tryFullPayment(user_id, parseInt(quantia) * config.valorDOZE) then
                    vRP.giveInventoryItem(user_id, "wbody_WEAPON_SAWNOFFSHOTGUN", quantia)
                    paymentFac('Armas1',quantia * config.valorDOZE)
                    vRP.setSData("chest:"..config.bauMAFIADEARMAS1,json.encode(items))


                    SendWebhookMessage(config.WebhookArmas1,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: DOZE\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
                else
                    TriggerClientEvent('Notify',source,'aviso','Você não possui dinheiro insuficiente')
                end
            else
                TriggerClientEvent('Notify',source,'aviso','Não há essa quantidade no estoque. ')
            end
        elseif item == 'tec9' then
            if items['wbody_WEAPON_MACHINEPISTOL'] ~= nil and parseInt(items['wbody_WEAPON_MACHINEPISTOL'].amount) >= parseInt(quantia) then
                items['wbody_WEAPON_MACHINEPISTOL'].amount = parseInt(items['wbody_WEAPON_MACHINEPISTOL'].amount) - parseInt(quantia)
                if vRP.tryFullPayment(user_id, parseInt(quantia) * config.valorTEC9) then
                    vRP.giveInventoryItem(user_id, "wbody_WEAPON_MACHINEPISTOL", quantia)
                    paymentFac('Armas1',quantia * config.valorTEC9)
                    vRP.setSData("chest:"..config.bauMAFIADEARMAS1,json.encode(items))

                    SendWebhookMessage(config.WebhookArmas1,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: TEC9\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

                else
                    TriggerClientEvent('Notify',source,'aviso','Você não possui dinheiro insuficiente')
                end
            else
                TriggerClientEvent('Notify',source,'aviso','Não há essa quantidade no estoque. ')
            end
        elseif item == 'G36' then
            if items['wbody_WEAPON_SPECIALCARBINE_MK2'] ~= nil and parseInt(items['wbody_WEAPON_SPECIALCARBINE_MK2'].amount) >= parseInt(quantia) then
                items['wbody_WEAPON_SPECIALCARBINE_MK2'].amount = parseInt(items['wbody_WEAPON_SPECIALCARBINE_MK2'].amount) - parseInt(quantia)
                if vRP.tryFullPayment(user_id, parseInt(quantia) * config.valorG3) then
                    vRP.giveInventoryItem(user_id, "wbody_WEAPON_SPECIALCARBINE_MK2", quantia)
                    paymentFac('Armas1',quantia * config.valorG3)
                    vRP.setSData("chest:"..config.bauMAFIADEARMAS1,json.encode(items))

                    SendWebhookMessage(config.WebhookArmas1,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: G36\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

                else
                    TriggerClientEvent('Notify',source,'aviso','Você não possui dinheiro insuficiente')
                end
            else
                TriggerClientEvent('Notify',source,'aviso','Não há essa quantidade no estoque. ')
            end
        elseif item == 'ak74' then
            if items['wbody_WEAPON_ASSAULTRIFLE_MK2'] ~= nil and parseInt(items['wbody_WEAPON_ASSAULTRIFLE_MK2'].amount) >= parseInt(quantia) then
                items['wbody_WEAPON_ASSAULTRIFLE_MK2'].amount = parseInt(items['wbody_WEAPON_ASSAULTRIFLE_MK2'].amount) - parseInt(quantia)
                if vRP.tryFullPayment(user_id, parseInt(quantia) * config.valorAK) then
                    vRP.giveInventoryItem(user_id, "wbody_WEAPON_ASSAULTRIFLE_MK2", quantia)
                    paymentFac('Armas1',quantia * config.valorAK)
                    vRP.setSData("chest:"..config.bauMAFIADEARMAS1,json.encode(items))

                    SendWebhookMessage(config.WebhookArmas1,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: AK47\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
                else
                    TriggerClientEvent('Notify',source,'aviso','Você não possui dinheiro insuficiente.')
                end
            else
                TriggerClientEvent('Notify',source,'aviso','Não há essa quantidade no estoque. ')
            end
        elseif item == 'mp5mk2' then
            if items['wbody_WEAPON_SMG_MK2'] ~= nil and parseInt(items['wbody_WEAPON_SMG_MK2'].amount) >= parseInt(quantia) and parseInt(items['wbody_WEAPON_SMG_MK2'].amount) > 0  then
                items['wbody_WEAPON_SMG_MK2'].amount = parseInt(items['wbody_WEAPON_SMG_MK2'].amount) - parseInt(quantia)
                if vRP.tryFullPayment(user_id, parseInt(quantia) * config.valorMP5) then
                    vRP.giveInventoryItem(user_id, "wbody_WEAPON_SMG_MK2", quantia)
                    paymentFac('Armas1',quantia * config.valorMP5)
                    vRP.setSData("chest:"..config.bauMAFIADEARMAS1,json.encode(items))


                    SendWebhookMessage(config.WebhookArmas1,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: MP5\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
                else
                    TriggerClientEvent('Notify',source,'aviso','Você não possui dinheiro insuficiente')
                end
            else
                TriggerClientEvent('Notify',source,'aviso','Não há essa quantidade no estoque. ')
            end
        end
    end
end

function src.armas2(item)
    local source = source 
    local user_id = vRP.getUserId(source)
    local quantia = vRP.prompt(source, 'QUANTIDADE', '')
    local data = vRP.getSData("chest:"..config.bauMAFIADEARMAS2)
	local items = json.decode(data) or {}
    local identity = vRP.getUserIdentity(user_id)

    if user_id then
        
        if item == 'fiveseven' then
            if items['wbody_WEAPON_PISTOL_MK2'] ~= nil and parseInt(items['wbody_WEAPON_PISTOL_MK2'].amount) >= parseInt(quantia) then
                    items['wbody_WEAPON_PISTOL_MK2'].amount = parseInt(items['wbody_WEAPON_PISTOL_MK2'].amount) - parseInt(quantia)
                    if vRP.tryFullPayment(user_id, parseInt(quantia) * config.valorFIVE) then
                    vRP.giveInventoryItem(user_id, "wbody_WEAPON_PISTOL_MK2", quantia)
                    vRP.setSData("chest:"..config.bauMAFIADEARMAS1,json.encode(items))

                    paymentFac('Armas2',quantia * config.valorFIVE)
                    SendWebhookMessage(config.WebhookArmas2,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: FIVE SEVEN\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

                else
                    TriggerClientEvent('Notify',source,'aviso','Você não possui dinheiro insuficiente')
                end
            else
                TriggerClientEvent('Notify',source,'aviso','Você não possui dinheiro insuficiente')
            end
        elseif item == 'remington' then
            if items['wbody_WEAPON_SAWNOFFSHOTGUN'] ~= nil and parseInt(items['wbody_WEAPON_SAWNOFFSHOTGUN'].amount) >= parseInt(quantia) then
                items['wbody_WEAPON_SAWNOFFSHOTGUN'].amount = parseInt(items['wbody_WEAPON_SAWNOFFSHOTGUN'].amount) - parseInt(quantia)
                if vRP.tryFullPayment(user_id, parseInt(quantia) * config.valorDOZE) then
                    vRP.giveInventoryItem(user_id, "wbody_WEAPON_SAWNOFFSHOTGUN", quantia)
                    paymentFac('Armas2',quantia * config.valorDOZE)
                    vRP.setSData("chest:"..config.bauMAFIADEARMAS2,json.encode(items))
                    SendWebhookMessage(config.WebhookArmas2,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: DOZE\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

                else
                    TriggerClientEvent('Notify',source,'aviso','Você não possui dinheiro insuficiente')
                end
            else
                TriggerClientEvent('Notify',source,'aviso','Não há essa quantidade no estoque. ')
            end
        elseif item == 'tec9' then
            if items['wbody_WEAPON_MACHINEPISTOL'] ~= nil and parseInt(items['wbody_WEAPON_MACHINEPISTOL'].amount) >= parseInt(quantia) then
                items['wbody_WEAPON_MACHINEPISTOL'].amount = parseInt(items['wbody_WEAPON_MACHINEPISTOL'].amount) - parseInt(quantia)
                if vRP.tryFullPayment(user_id, parseInt(quantia) * config.valorTEC9) then
                    vRP.giveInventoryItem(user_id, "wbody_WEAPON_MACHINEPISTOL", quantia)
                    paymentFac('Armas2',quantia * config.valorTEC9)
                    vRP.setSData("chest:"..config.bauMAFIADEARMAS2,json.encode(items))
                    SendWebhookMessage(config.WebhookArmas2,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: TEC9\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

                else
                    TriggerClientEvent('Notify',source,'aviso','Você não possui dinheiro insuficiente')
                end
            else
                TriggerClientEvent('Notify',source,'aviso','Não há essa quantidade no estoque. ')
            end
        elseif item == 'G36' then
            if items['wbody_WEAPON_SPECIALCARBINE_MK2'] ~= nil and parseInt(items['wbody_WEAPON_SPECIALCARBINE_MK2'].amount) >= parseInt(quantia) then
                items['wbody_WEAPON_SPECIALCARBINE_MK2'].amount = parseInt(items['wbody_WEAPON_SPECIALCARBINE_MK2'].amount) - parseInt(quantia)
                if vRP.tryFullPayment(user_id, parseInt(quantia) * config.valorG3) then
                    vRP.giveInventoryItem(user_id, "wbody_WEAPON_SPECIALCARBINE_MK2", quantia)
                    paymentFac('Armas2',quantia * config.valorG3)
                    vRP.setSData("chest:"..config.bauMAFIADEARMAS2,json.encode(items))

                    SendWebhookMessage(config.WebhookArmas2,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: G36\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

                else
                    TriggerClientEvent('Notify',source,'aviso','Você não possui dinheiro insuficiente')
                end
            else
                TriggerClientEvent('Notify',source,'aviso','Não há essa quantidade no estoque. ')
            end
        elseif item == 'ak74' then
            if items['wbody_WEAPON_ASSAULTRIFLE_MK2'] ~= nil and parseInt(items['wbody_WEAPON_ASSAULTRIFLE_MK2'].amount) >= parseInt(quantia) then
                items['wbody_WEAPON_ASSAULTRIFLE_MK2'].amount = parseInt(items['wbody_WEAPON_ASSAULTRIFLE_MK2'].amount) - parseInt(quantia)
                if vRP.tryFullPayment(user_id, parseInt(quantia) * config.valorAK) then
                    vRP.giveInventoryItem(user_id, "wbody_WEAPON_ASSAULTRIFLE_MK2", quantia)
                    paymentFac('Armas2',quantia * config.valorAK)
                    vRP.setSData("chest:"..config.bauMAFIADEARMAS2,json.encode(items))
                    SendWebhookMessage(config.WebhookArmas2,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: AK47\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")

                else
                    TriggerClientEvent('Notify',source,'aviso','Você não possui dinheiro insuficiente.')
                end
            else
                TriggerClientEvent('Notify',source,'aviso','Não há essa quantidade no estoque. ')
            end
        elseif item == 'mp5mk2' then
            if items['wbody_WEAPON_SMG_MK2'] ~= nil and parseInt(items['wbody_WEAPON_SMG_MK2'].amount) >= parseInt(quantia) and parseInt(items['wbody_WEAPON_SMG_MK2'].amount) > 0  then
                items['wbody_WEAPON_SMG_MK2'].amount = parseInt(items['wbody_WEAPON_SMG_MK2'].amount) - parseInt(quantia)
                if vRP.tryFullPayment(user_id, parseInt(quantia) * config.valorMP5) then
                    vRP.giveInventoryItem(user_id, "wbody_WEAPON_SMG_MK2", quantia)
                    paymentFac('Armas2',quantia * config.valorMP5)
                    vRP.setSData("chest:"..config.bauMAFIADEARMAS2,json.encode(items))

                    SendWebhookMessage(config.WebhookArmas2,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: MP5\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
                else
                    TriggerClientEvent('Notify',source,'aviso','Você não possui dinheiro insuficiente')
                end
            else
                TriggerClientEvent('Notify',source,'aviso','Não há essa quantidade no estoque. ')
            end
        end
    end
end


function src.compraBallas()
    local source = source 
    local user_id = vRP.getUserId(source)
    local data = vRP.getSData("chest:"..config.bauDROGAS2)
	local items = json.decode(data) or {}
    local quantia = vRP.prompt(source, 'QUANTIDADE', '')
    local identity = vRP.getUserIdentity(user_id)



    if items['lsd'] ~= nil and parseInt(items['lsd'].amount) >= parseInt(quantia) and parseInt(items['lsd'].amount) > 0  then
        items['lsd'].amount = parseInt(items['lsd'].amount) - parseInt(quantia)
        if vRP.tryFullPayment(user_id, parseInt(quantia) * config.PrecoDaDroga) then
            vRP.giveInventoryItem(user_id, "lsd", quantia)
            paymentFac('Drogas2',quantia * config.PrecoDaDroga)
            vRP.setSData("chest:"..config.bauDROGAS2,json.encode(items),json.encode(items))


            SendWebhookMessage(config.WebhookDrogas2,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: Cigarro de Maconha\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        else
            TriggerClientEvent('Notify',source,'aviso','Você não possui dinheiro insuficiente')
        end
    else
        TriggerClientEvent('Notify',source,'aviso','Não há essa quantidade no estoque. ')
    end
end


function src.compraGroove()
    local source = source 
    local user_id = vRP.getUserId(source)
    local data = vRP.getSData("chest:"..config.bauDROGAS1)
	local items = json.decode(data) or {}
    local quantia = vRP.prompt(source, 'QUANTIDADE', '')
    local identity = vRP.getUserIdentity(user_id)



    if items['cigarromaconha'] ~= nil and parseInt(items['cigarromaconha'].amount) >= parseInt(quantia) and parseInt(items['cigarromaconha'].amount) > 0  then
        items['cigarromaconha'].amount = parseInt(items['cigarromaconha'].amount) - parseInt(quantia)
        if vRP.tryFullPayment(user_id, parseInt(quantia) * config.PrecoDaDroga) then
            vRP.giveInventoryItem(user_id, "cigarromaconha", quantia)
            paymentFac('Drogas1',quantia * config.PrecoDaDroga)
            vRP.setSData("chest:"..config.bauDROGAS1,json.encode(items),json.encode(items))


            SendWebhookMessage(config.WebhookDrogas1,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: cocaina\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        else
            TriggerClientEvent('Notify',source,'aviso','Você não possui dinheiro insuficiente')
        end
    else
        TriggerClientEvent('Notify',source,'aviso','Não há essa quantidade no estoque. ')
    end
end

function src.compraVagos()
    local source = source 
    local user_id = vRP.getUserId(source)
    local data = vRP.getSData("chest:"..config.bauDROGAS3)
	local items = json.decode(data) or {}
    local quantia = vRP.prompt(source, 'QUANTIDADE', '')
    local identity = vRP.getUserIdentity(user_id)



    if items['cocaina'] ~= nil and parseInt(items['cocaina'].amount) >= parseInt(quantia) and parseInt(items['cocaina'].amount) > 0  then
        items['cocaina'].amount = parseInt(items['cocaina'].amount) - parseInt(quantia)
        if vRP.tryFullPayment(user_id, parseInt(quantia) * config.PrecoDaDroga) then
            vRP.giveInventoryItem(user_id, "cocaina", quantia)
            paymentFac('Drogas3',quantia * config.PrecoDaDroga)
            vRP.setSData("chest:"..config.bauDROGAS3,json.encode(items),json.encode(items))
            SendWebhookMessage(config.WebhookDrogas3,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[COMPROU]: LSD\n[QUANTIDADE]:"..parseInt(quantia)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        else
            TriggerClientEvent('Notify',source,'aviso','Você não possui dinheiro insuficiente')
        end
    else
        TriggerClientEvent('Notify',source,'aviso','Não há essa quantidade no estoque. ')
    end
end




-----------------------------------------------------------------------------------------------------------------------------------------
-- SACAR

function src.kvgnksnfvusdjfvgoudjgd9ujg984()
    local source = source
    local user_id = vRP.getUserId(source)

    if user_id == config.IDParaSacarSaldoDrogas1 then
        local value = vRP.getSData('xuxuco:SaldoDeVendas'..'Drogas1')
        local resultado = json.decode(value) or 0
        TriggerClientEvent('Notify', source, 'aviso', 'Saldo De Vendas: $'..vRP.format(parseInt(resultado)))
        local qtd = vRP.prompt(source, "Digite o valor  que deseja Sacar:", "")

        if qtd == '' then

            return

        end

         if resultado >= parseInt(qtd) and not string.match(qtd, "-") and not parseInt(qtd) > resultado then
            qtd = tonumber(qtd)
            vRP.setSData('xuxuco:SaldoDeVendas'..'Drogas1',resultado-qtd)
            vRP.giveMoney(user_id,qtd)
            TriggerClientEvent('Notify', source, 'aviso', 'Você Sacou: $'..vRP.format(parseInt(qtd)))
         else
            TriggerClientEvent('Notify',source,'sucesso','Sem saldo disponivel.')
         end

    elseif user_id == config.IDParaSacarSaldoDrogas2 then
        local value = vRP.getSData('xuxuco:SaldoDeVendas'..'Drogas2')
        local resultado = json.decode(value) or 0
        TriggerClientEvent('Notify', source, 'aviso', 'Saldo De Vendas: $'..vRP.format(parseInt(resultado)))
        local qtd = vRP.prompt(source, "Digite o valor  que deseja Sacar:", "")

        if qtd == '' then

            return

        end
        if resultado >= parseInt(qtd) and  not string.match(qtd, "-") and not parseInt(qtd) > resultado then
            qtd = tonumber(qtd)
            vRP.setSData('xuxuco:SaldoDeVendas'..'Drogas2',resultado-qtd)
            vRP.giveMoney(user_id,qtd)
            TriggerClientEvent('Notify', source, 'aviso', 'Você Sacou: $'..vRP.format(parseInt(qtd)))
        else
            TriggerClientEvent('Notify',source,'sucesso','Sem saldo disponivel.')
        end

    elseif user_id == config.IDParaSacarSaldoDrogas3 then
        local value = vRP.getSData('xuxuco:SaldoDeVendas'..'Drogas3')
        local resultado = json.decode(value) or 0
        TriggerClientEvent('Notify', source, 'aviso', 'Saldo De Vendas: $'..vRP.format(parseInt(resultado)))
        local qtd = vRP.prompt(source, "Digite o valor  que deseja Sacar:", "")

        if qtd == '' then

            return

        end

        if resultado >= parseInt(qtd) and  not string.match(qtd, "-") and not parseInt(qtd) > resultado then
            qtd = tonumber(qtd)
            vRP.setSData('xuxuco:SaldoDeVendas'..'Drogas3',resultado-qtd)
            vRP.giveMoney(user_id,qtd)
            TriggerClientEvent('Notify', source, 'aviso', 'Você Sacou: $'..vRP.format(parseInt(qtd)))
        else
            TriggerClientEvent('Notify',source,'sucesso','Sem saldo disponivel.')
        end

    elseif user_id == config.IDParaSacarSaldoArmas1 then
        local value = vRP.getSData('xuxuco:SaldoDeVendas'..'Armas1')
        local resultado = json.decode(value) or 0
        TriggerClientEvent('Notify', source, 'aviso', 'Saldo De Vendas: $'..vRP.format(parseInt(resultado)))
        local qtd = vRP.prompt(source, "Digite o valor  que deseja Sacar:", "")

        if qtd == '' then

            return

        end
        if resultado >= parseInt(qtd) and  not string.match(qtd, "-") and not parseInt(qtd) > resultado then
            qtd = tonumber(qtd)
            vRP.setSData('xuxuco:SaldoDeVendas'..'Armas1',resultado-qtd)
            vRP.giveMoney(user_id,qtd)
            TriggerClientEvent('Notify', source, 'aviso', 'Você Sacou: $'..vRP.format(parseInt(qtd)))
        else
            TriggerClientEvent('Notify',source,'sucesso','Sem saldo disponivel.')
        end 
    elseif user_id == config.IDParaSacarSaldoArmas2 then
        local value = vRP.getSData('xuxuco:SaldoDeVendas'..'Armas2')
        local resultado = json.decode(value) or 0
        TriggerClientEvent('Notify', source, 'aviso', 'Saldo De Vendas: $'..vRP.format(parseInt(resultado)))
        local qtd = vRP.prompt(source, "Digite o valor  que deseja Sacar:", "")

        if qtd == '' then

            return

        end
        if resultado >= parseInt(qtd) and  not string.match(qtd, "-") and not parseInt(qtd) > resultado then
            qtd = tonumber(qtd)
            vRP.setSData('xuxuco:SaldoDeVendas'..'Armas2',resultado-qtd)
            vRP.giveMoney(user_id,qtd)
            TriggerClientEvent('Notify', source, 'aviso', 'Você Sacou: $'..vRP.format(parseInt(qtd)))
        else
            TriggerClientEvent('Notify',source,'sucesso','Sem saldo disponivel.')
        end
    elseif user_id == config.IDParaSacarSaldoMuni1 then
        local value = vRP.getSData('xuxuco:SaldoDeVendas'..'Muni1')
        local resultado = json.decode(value) or 0
        TriggerClientEvent('Notify', source, 'aviso', 'Saldo De Vendas: $'..vRP.format(parseInt(resultado)))
        local qtd = vRP.prompt(source, "Digite o valor  que deseja Sacar:", "")

        if qtd == '' then

            return

        end
        if resultado >= parseInt(qtd) and  not string.match(qtd, "-") and not parseInt(qtd) > resultado then
            qtd = tonumber(qtd)
            vRP.setSData('xuxuco:SaldoDeVendas'..'Muni1',resultado-qtd)
            vRP.giveMoney(user_id,qtd)
            TriggerClientEvent('Notify', source, 'aviso', 'Você Sacou: $'..vRP.format(parseInt(qtd)))
        else
            TriggerClientEvent('Notify',source,'sucesso','Sem saldo disponivel.')
        end 
    elseif user_id == config.IDParaSacarSaldoMuni2 then
        local value = vRP.getSData('xuxuco:SaldoDeVendas'..'Muni2')
        local resultado = json.decode(value) or 0
        TriggerClientEvent('Notify', source, 'aviso', 'Saldo De Vendas: $'..vRP.format(parseInt(resultado)))
        local qtd = vRP.prompt(source, "Digite o valor  que deseja Sacar:", "")

        if qtd == '' then

            return

        end
        if resultado >= parseInt(qtd) and  not string.match(qtd, "-") and not parseInt(qtd) > resultado then
            qtd = tonumber(qtd)
            vRP.setSData("xuxuco:SaldoDeVendas" .. "Muni2", resultado - qtd)
            vRP.giveMoney(user_id, qtd)
            TriggerClientEvent("Notify", source, "aviso", "Você Sacou: $" .. vRP.format(parseInt(qtd)))
        else
            TriggerClientEvent("Notify", source, "sucesso", "Sem saldo disponivel.")
        end
    end
end









