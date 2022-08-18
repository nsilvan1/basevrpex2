local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
src = {} Tunnel.bindInterface("vrp_admin",src)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookgive = ""
local webhookadmin = ""
local webhooksetar = ""
local webhookban = ""
local webhookcarro = ""
local webhookset = ""
local webhookcds = ""
local webhookblacklist = ""
local webhookaddcar = ""

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
 ---------------------------------------------------------
-- /EAT
---------------------------------------------------------
RegisterCommand("eat",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        vRP.varyThirst(user_id, -100)
        vRP.varyHunger(user_id, -100)
        TriggerClientEvent("Notify",source,"sucesso","Fome e Sede 100%")

    end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- DISTANCE
------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('distance',function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        local player = vRP.getUserSource(user_id)
        if vRP.hasPermission(user_id,"admin.permissao") then
            TriggerClientEvent("distance",player,args[1])
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OBITO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("obito", function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local nsource = vRP.getUserSource(parseInt(args[1]))
    local nuser_id = vRP.getUserId(nsource)
    local health
    if nuser_id then
        if vRP.hasPermission(user_id, "admin.permissao") then
            health = GetEntityHealth(GetPlayerPed(nsource))
            if health <= 101 then
                TriggerClientEvent("vrp:setObito", nsource)
                TriggerClientEvent("Notify", source, "sucesso", 'Sucesso',"Você decretou como morto o ID " .. vRP.format(nuser_id) .. "</.")
            else
                TriggerClientEvent("Notify", source, "negado",'Negado', "Esse jogador está vivo.")
            end
        end
    elseif vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"policiaacao.permissao") or vRP.hasPermission(user_id, "strea.permissao") then
        health = GetEntityHealth(GetPlayerPed(source))
        if health <= 101 then
            TriggerClientEvent("vrp:setObito", source)
            TriggerClientEvent("Notify", source, "sucesso", "Você decretou seu obito.")
        end
    else
        TriggerClientEvent("Notify", source, "negado", 'Negado',"Você não enviou o ID do usuario")
    end
end)
---------------------------------------------------------------------------------------------
-- RESET
---------------------------------------------------------------------------------------------
RegisterCommand('reset',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id,"admin.permissao") then
            if args[1] then
                local nplayer = vRP.getUserSource(parseInt(args[1]))
                local id = vRP.getUserId(nplayer)
                if id then
                    vRP.kick(id,"Transplante Iniciado.")
                    vRP.setUData(id,"vRP:spawnController",json.encode(1))
                    vRP.setUData(id,"vRP:currentCharacterMode",json.encode(1))
                    vRP.setUData(id,"vRP:tattoos",json.encode(1))
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPARBOLSA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('limpar',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") then
		local tuser_id = tonumber(args[1])
		local tplayer = vRP.getUserSource(tonumber(tuser_id))
		local tplayerID = vRP.getUserId (tonumber(tplayer))
			if tplayerID ~= nil then
			local identity = vRP.getUserIdentity(user_id)
			vRP.clearInventory(tplayerID)
				TriggerClientEvent("Notify",source,"sucesso","Limpou inventario do ID <b>"..args[1].."</b>.")
			else
				TriggerClientEvent("Notify",source,"negado","O usuário não foi encontrado ou está offline.")
        end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RG2
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('rg2',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"rg2.permissao") then
        local nuser_id = parseInt(args[1])
        local identity = vRP.getUserIdentity(nuser_id)
        local bankMoney = vRP.getBankMoney(nuser_id)
        local walletMoney = vRP.getMoney(nuser_id)
        local sets = json.decode(vRP.getUData(nuser_id,"vRP:datatable"))
        
        
        if args[1] then
           TriggerClientEvent("Notify",source,"importante","ID: <b>"..parseInt(nuser_id).."</b><br>Nome: <b>"..identity.name.." "..identity.firstname.."</b><br>Idade: <b>"..identity.age.."</b><br>Telefone: <b>"..identity.phone.."</b><br>Carteira: <b>"..vRP.format(parseInt(walletMoney)).."</b><br>Banco: <b>"..vRP.format(parseInt(bankMoney)).."</b><br>Sets: <b>"..json.encode(sets.groups).."</b>",5000)    
        else
            TriggerClientEvent("Notify",source,"negado","Digite o ID desejado!")

        end
    end
end)

---------------------------------------------------------------------------------------------
-- REMOVER ARMAS HACKER
---------------------------------------------------------------------------------------------
RegisterCommand('removearmas',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        local users = vRP.getUsers()
        for k,v in pairs(users) do
            local id = vRP.getUserSource(parseInt(k))
            if id then
                TriggerClientEvent('limparArmas',id)
                print(id)
            end
        end
    end
end)

---------------------------------------------------------------------------------------------
-- RESET
---------------------------------------------------------------------------------------------
RegisterCommand('reset',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id,"admin.permissao") then
            if args[1] then
                local nplayer = vRP.getUserSource(parseInt(args[1]))
                local id = vRP.getUserId(nplayer)
                if id then
                    vRP.setUData(id,"vRP:spawnController",json.encode(1))
                    TriggerClientEvent("Notify",user_id,"sucesso","Você <b>resetou</b> o personagem do passaporte <b>"..vRP.format(parseInt(args[1])).."</b>.",5000)
                end
            end
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPAR ARMA DE PLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('armalimpar', function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(source)
    if user_id then
        if vRP.hasPermission(user_id,"admin.permissao") then
			vRPclient.giveWeapons(source,{},true)
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('vid', function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(source)
    if user_id then
        if vRP.hasPermission(user_id,"admin.permissao") then
			vRPclient.showBlips(source)
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- VROUPAS
-----------------------------------------------------------------------------------------------------------------------------------------
local player_customs = {}
RegisterCommand('vroupas',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local custom = vRPclient.getCustomization(source)
    if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"polpar.permissao") then
        if player_customs[source] then
            player_customs[source] = nil
            vRPclient._removeDiv(source,"customization")
        else 
            local content = ""
            for k,v in pairs(custom) do
                content = content..k.." => "..json.encode(v).."<br/>" 
            end

            player_customs[source] = true
            vRPclient._setDiv(source,"customization",".div_customization{ margin: auto; padding: 4px; width: 250px; margin-top: 200px; margin-right: 50px; background: rgba(15,15,15,0.7); color: #ffff; font-weight: bold; }",content)
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- RENOMEAR PERSONAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('rename',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"suporte.permissao") then
        local idjogador = vRP.prompt(source, "Qual id do jogador?", "")
        local nome = vRP.prompt(source, "Novo nome", "")
        local firstname = vRP.prompt(source, "Novo sobrenome", "")
        local idade = vRP.prompt(source, "Nova idade", "")
        local identity = vRP.getUserIdentity(parseInt(idjogador))
        vRP.execute("vRP/update_user_identity",{
            user_id = idjogador,
            firstname = firstname,
            name = nome,
            age = idade,
            registration = identity.registration,
            phone = identity.phone
        })
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ESTOQUE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('estoque',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        if args[1] and args[2] then
            vRP.execute("creative/set_estoque",{ vehicle = args[1], quantidade = args[2] })
            TriggerClientEvent("Notify",source,"sucesso","Voce colocou mais <b>"..args[2].."</b> no estoque, para o carro <b>"..args[1].."</b>.") 
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ADD CAR -- Alterado
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('addcar',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"ceo.permissao") or vRP.hasPermission(user_id,"admin.permissao") then
        if args[1] and args[2] then
            local nplayerS = vRP.getUserSource(parseInt(args[2]))
            local nplayerID = vRP.getUserId(nplayerS)
            local identitynu = vRP.getUserIdentity(nplayerID)
            vRP.execute("creative/add_vehicle",{ user_id = parseInt(args[2]), vehicle = args[1], ipva = parseInt(os.time()) }) 
            SendWebhookMessage(webhookaddcar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ADICIONOU]: "..args[1].." \n[PARA O ID]: "..nplayerID.." "..identitynu.name.." "..identitynu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```") 
            TriggerClientEvent("Notify",source,"sucesso","Voce adicionou o veículo <b>"..args[1].."</b> para o Passaporte: <b>"..parseInt(args[2]).."</b>.")
        end
    else
        SendWebhookMessage(webhookperm, "```prolog\n".."[ID] "..user_id.."\n[COMANDO] "..rawCommand.."```")			
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REM CAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('remcar',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local nplayer = vRP.getUserId(parseInt(args[2]))
    if vRP.hasPermission(user_id,"admin.permissao") then
        if args[1] and args[2] then
            local nuser_id = vRP.getUserId(nplayer)
            local identity = vRP.getUserIdentity(user_id)
            local identitynu = vRP.getUserIdentity(nuser_id)
            vRP.execute("creative/rem_vehicle",{ user_id = parseInt(args[2]), vehicle = args[1], ipva = parseInt(os.time())  }) 
            TriggerClientEvent("Notify",source,"sucesso","Voce removeu o veículo <b>"..args[1].."</b> do Passaporte: <b>"..parseInt(args[2]).."</b>.") 
            SendWebhookMessage(webhooknovo,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[REMOVEU]: "..args[1].." \n[PARA O ID]: "..nuser_id.." "..identitynu.name.." "..identitynu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        end
    end
end)

------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- UNCUFF
------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('uncuff',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"admin.permissao") then
			TriggerClientEvent("admcuff",source)
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("item",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		vRP.upThirst(user_id)
		if vRP.hasPermission(user_id,"admin.permissao") then
			if args[1] and args[2] and vRP.itemNameList(args[1]) ~= nil then
				vRP.giveInventoryItem(user_id,args[1],parseInt(args[2]))
				SendWebhookMessage(webhookgive,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[PEGOU]: "..args[1].." \n[QUANTIDADE]: "..vRP.format(parseInt(args[2])).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FUEL
------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('admfuel',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"admin.permissao") then
			TriggerClientEvent("admfuel",source)
		end	
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- cOBJECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cobject',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		TriggerClientEvent('cobject',source,args[1],args[2])
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SYNCAREA
------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('clearall',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local x,y,z = vRPclient.getPosition(source)
    if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"polpar.permissao") then
        TriggerClientEvent("syncarea",-1,x,y,z)
    end
end)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TROCAR SEXO
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('skin',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        if parseInt(args[1]) then
            local nplayer = vRP.getUserSource(parseInt(args[1]))
            if nplayer then
                TriggerClientEvent("skinmenu",nplayer,args[2])
                TriggerClientEvent("Notify",source,"sucesso","Voce setou a skin <b>"..args[2].."</b> no passaporte <b>"..parseInt(args[1]).."</b>.")
            end
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CAR COLOR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('carcolor',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        local vehicle = vRPclient.getNearestVehicle(source,7)
        if vehicle then
            local rgb = vRP.prompt(source,"RGB Color(255 255 255):","")
            rgb = sanitizeString(rgb,"\"[]{}+=?!_()#@%/\\|,.",false)
            local r,g,b = table.unpack(splitString(rgb," "))
            TriggerClientEvent('vcolorv',source,vehicle,tonumber(r),tonumber(g),tonumber(b))
            
            TriggerClientEvent("Notify",source,"sucesso","Cor alterada")
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYDELETEOBJ
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trydeleteobj")
AddEventHandler("trydeleteobj",function(index)
    TriggerClientEvent("syncdeleteobj",-1,index)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FIX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('fix',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local vehicle = vRPclient.getNearestVehicle(source,11)
	if vehicle then
		if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
			TriggerClientEvent('reparar',source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REVIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('god',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") or vRP.hasPermission(user_id,"suporte.permissao") or vRP.hasPermission(user_id,"streamer.permissao") then
        if args[1] then
            local nplayer = vRP.getUserSource(parseInt(args[1]))
            if nplayer then
                vRPclient.killGod(nplayer)
                vRPclient.setHealth(nplayer,400)
            end
        else
            vRPclient.killGod(source)
			vRPclient.setHealth(source,400)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REVIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('god2',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") or vRP.hasPermission(user_id,"suporte.permissao") or vRP.hasPermission(user_id,"streamer.permissao") then
        if args[1] then
            local nplayer = vRP.getUserSource(parseInt(args[1]))
            if nplayer then
                vRPclient.killGod(nplayer)
                vRPclient.setHealth(nplayer,200)
            end
        else
            vRPclient.killGod(source)
			vRPclient.setHealth(source,200)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REVIVE ALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('godall',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        local users = vRP.getUsers()
        for k,v in pairs(users) do
            local id = vRP.getUserSource(parseInt(k))
            if id then
            	vRPclient.killGod(id)
				vRPclient.setHealth(id,400)
				--print(id)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK ALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('kickall',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        local users = vRP.getUsers()
        for k,v in pairs(users) do
            local id = vRP.getUserSource(parseInt(k))
            if id then
                vRP.kick(id,"Você foi vitima do terremoto.")
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('hash',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		TriggerClientEvent('vehash',source)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- WL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('wl',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"suporte.permissao") or vRP.hasPermission(user_id,"mod.permissao") or vRP.hasPermission(user_id,"wl.permissao") then
        if args[1] then
            vRP.setWhitelisted(parseInt(args[1]),true)
            TriggerClientEvent("Notify",source,"sucesso","Voce aprovou o passaporte <b>"..args[1].."</b> na whitelist.")
            SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[APROVOU WL]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TP ALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpall', function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        local player = vRP.getUserSource(user_id)
        local x,y,z = vRPclient.getPosition(source)
        if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
            local users = vRP.getUsers()
            for k,v in pairs(users) do
                local target_source = vRP.getUserSource(k)
                local rsource = vRP.getUserSource(k)
                if rsource ~= source then
                    vRPclient.teleport(rsource,x,y,z)
                end
            end
        end
    end
end) 
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNWL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('unwl',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"suporte.permissao") or vRP.hasPermission(user_id,"mod.permissao")  then
		if args[1] then
			vRP.setWhitelisted(parseInt(args[1]),false)
			TriggerClientEvent("Notify",source,"sucesso","Voce retirou o passaporte <b>"..args[1].."</b> da whitelist.")
			SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RETIROU WL]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('kick',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
		if args[1] then
			local id = vRP.getUserSource(parseInt(args[1]))
			if id then
				vRP.kick(id,"Você foi expulso da cidade.")
				TriggerClientEvent("Notify",source,"sucesso","Voce kickou o passaporte <b>"..args[1].."</b> da cidade.")
				SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[KICKOU]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ban',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
		if args[1] then
			vRP.setBanned(parseInt(args[1]),true)
			TriggerClientEvent("Notify",source,"sucesso","Voce baniu o passaporte <b>"..args[1].."</b> da cidade.")
			SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[BANIU]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNBAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('unban',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
		if args[1] then
			vRP.setBanned(parseInt(args[1]),false)
			TriggerClientEvent("Notify",source,"sucesso","Voce desbaniu o passaporte <b>"..args[1].."</b> da cidade.")
			SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[DESBANIU]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('money',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") then
		if args[1] then
			vRP.giveMoney(user_id,parseInt(args[1]))
			SendWebhookMessage(webhookadmin,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[FEZ]: $"..vRP.format(parseInt(args[1])).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('nc',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") or vRP.hasPermission(user_id,"suporte.permissao") or vRP.hasPermission(user_id,"streamer.permissao") then
		vRPclient.toggleNoclip(source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPCDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpcds',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
		local fcoords = vRP.prompt(source,"Cordenadas:","")
		if fcoords == "" then
			return
		end
		local coords = {}
		for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
			table.insert(coords,parseInt(coord))
		end
		vRPclient.teleport(source,coords[1] or 0,coords[2] or 0,coords[3] or 0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARMA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('arma',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if args[1] then
            if vRP.hasPermission(user_id,"admin.permissao") then
            vRPclient.giveWeapons(source,{[args[1]] = { ammo = 250 }})
            end
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ACCOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cc',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
	  	if vRP.hasPermission(user_id,"admin.permissao") then
			if args[1] then
			 	local nuser_id = vRP.getUserId(parseInt(args[1]))
			 	local nsource = vRP.getUserSource(parseInt(args[1]))
			 	if nsource then
			   	vRP.prompt(source,"Informations:","Steam Hex: "..GetPlayerIdentifier(parseInt(nsource),0))
			   	if GetPlayerIdentifier(parseInt(nsource),4) then
				 	TriggerClientEvent("Notify",source,"importante","<b>Usuário:</b> "..args[1].." <br><b>License:</b> "..GetPlayerIdentifier(parseInt(nsource),1).."<br><b>Discord Id:</b> "..GetPlayerIdentifier(parseInt(nsource),4).."<br><b>Steam Hex:</b> "..GetPlayerIdentifier(parseInt(nsource),0),8000)
			   	else
				 	TriggerClientEvent("Notify",source,"importante","<b>Usuário:</b> "..args[1].." <br><b>License:</b> "..GetPlayerIdentifier(parseInt(nsource),1).."<br><b>Steam Hex:</b> "..GetPlayerIdentifier(parseInt(nsource),0),8000)
			  	end
			 	else
			   		TriggerClientEvent("Notify",source,"negado","Este jogador precisa estar online, para mais informações chame um desenvolvedor",8000)
			 	end
		  	end
	  	end
	end
end)

------------------------------------------------
--[ COORDENADAS ]-------------------------------
------------------------------------------------
RegisterCommand('cds',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"owner.permissao") or vRP.hasPermission(user_id,"admin.permissao") then
        local x,y,z = vRPclient.getPosition(source)
        heading = GetEntityHeading(GetPlayerPed(-1))
        vRP.prompt(source,"Cordenadas:","['x'] = "..tD(x)..", ['y'] = "..tD(y)..", ['z'] = "..tD(z))
    end
end)

RegisterCommand('cds2',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"owner.permissao") or vRP.hasPermission(user_id,"admin.permissao") then
        local x,y,z = vRPclient.getPosition(source)
        vRP.prompt(source,"Cordenadas:",tD(x)..", "..tD(y)..", "..tD(z))
    end
end)

RegisterCommand('cds3',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"owner.permissao") or vRP.hasPermission(user_id,"admin.permissao") then
        local x,y,z = vRPclient.getPosition(source)
        vRP.prompt(source,"Cordenadas:","{name='ATM', id=277, x="..tD(x)..", y="..tD(y)..", z="..tD(z).."},")
    end
end)

RegisterCommand('cds4',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"owner.permissao") or vRP.hasPermission(user_id,"admin.permissao") then
        local x,y,z = vRPclient.getPosition(source)
        vRP.prompt(source,"Cordenadas:","x = "..tD(x)..", y = "..tD(y)..", z = "..tD(z))
    end
end)

function tD(n)
    n = math.ceil(n * 100) / 100
    return n
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TD
-----------------------------------------------------------------------------------------------------------------------------------------
function tD(n)
    n = math.ceil(n*100)/100
    return n
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('coords',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
			local x,y,z = vRPclient.getPosition(source)
			vRP.prompt(source,"Cordenadas:",mathLegth(x)..","..mathLegth(y)..","..mathLegth(z))
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MATHLEGTH
-----------------------------------------------------------------------------------------------------------------------------------------
function mathLegth(n)
	n = math.ceil(n*100)/100
	return n
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('group',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
		if args[1] and args[2] then
			vRP.addUserGroup(parseInt(args[1]),args[2])
			TriggerClientEvent("Notify",source,"sucesso","Voce setou o passaporte <b>"..parseInt(args[1]).."</b> no grupo <b>"..args[2].."</b>.")
			SendWebhookMessage(webhooksetar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SETOU]: "..args[1].." \n[GRUPO]: "..args[2].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNGROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ungroup',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
		if args[1] and args[2] then
			vRP.removeUserGroup(parseInt(args[1]),args[2])
			TriggerClientEvent("Notify",source,"sucesso","Voce removeu o passaporte <b>"..parseInt(args[1]).."</b> do grupo <b>"..args[2].."</b>.")
			SendWebhookMessage(webhooksetar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[REMOVEU]: "..args[1].." \n[GRUPO]: "..args[2].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tptome',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
		if args[1] then
			local tplayer = vRP.getUserSource(parseInt(args[1]))
			local x,y,z = vRPclient.getPosition(source)
			if tplayer then
				vRPclient.teleport(tplayer,x,y,z)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpto',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then
		if args[1] then
			local tplayer = vRP.getUserSource(parseInt(args[1]))
			if tplayer then
				vRPclient.teleport(source,vRPclient.getPosition(tplayer))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpway',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") or vRP.hasPermission(user_id,"suporte.permissao") then
		TriggerClientEvent('tptoway',source)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DELNPCS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('delnpcs',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		TriggerClientEvent('delnpcs',source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('adm',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
     if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") then        
        local identity = vRP.getUserIdentity(user_id)
        local mensagem = vRP.prompt(source,"Mensagem:","")
        if mensagem == "" then
            return
        end
        vRPclient.setDiv(-1,"anuncio"," @keyframes blinking {    0%{ background-color: #ff3d50; border: 2px solid #871924; opacity: 0.8; }   } .div_anuncio { font-size: 11px; font-family: arial; color: rgba(255, 255, 255,1); padding: 20px; bottom: 17%; right: 2%; max-width: 500px; position: absolute; -webkit-border-radius: 5px; animation: blinking 1s infinite; } bold { font-size: 16px; }","<bold>"..mensagem.."</bold><br><br>Administração: "..identity.name.." "..identity.firstname)
        SetTimeout(7000,function()
            vRPclient.removeDiv(-1,"anuncio")
        end)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('pon',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"suporte.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
        local users = vRP.getUsers()
        local players = ""
        local quantidade = 0
        for k,v in pairs(users) do
            if k ~= #users then
                players = players..", "
            end
            players = players..k
            quantidade = quantidade + 1
        end
        TriggerClientEvent('chatMessage',source,"TOTAL ONLINE",{255,160,0},quantidade)
        TriggerClientEvent('chatMessage',source,"ID's ONLINE",{255,160,0},players)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHAT ADMIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('aa',function(source,args,rawCommand)
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		local permission = "suporte.permissao"
		if vRP.hasPermission(user_id,permission) then
			local soldado = vRP.getUsersByPermission(permission)
			for l,w in pairs(soldado) do
				local player = vRP.getUserSource(parseInt(w))
				if player then
					async(function()
						TriggerClientEvent('chatMessage',player,"[CHAT ADMIN] ["..user_id.."] "..identity.name.." "..identity.firstname,{255,0,0},rawCommand:sub(3))
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tuning',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mod.permissao") then
		TriggerClientEvent('vehtuning',source)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- /KILL 
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('kill',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        if args[1] then
            local nplayer = vRP.getUserSource(parseInt(args[1]))
            if nplayer then
                vRPclient.killGod(nplayer)
                vRPclient.setHealth(nplayer,0)
            end
        else
            vRPclient.killGod(source)
            vRPclient.setHealth(source,0)
            vRPclient.setArmour(source,0)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /SPEC
----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("spec",function(source,args)
    local source = source
    local user_idDoJogadorParaSpectar = tonumber(args[1])
    local user_idDoJogadorQueExecutouoCOMANDO = vRP.getUserId(source)
    if vRP.hasPermission(user_idDoJogadorQueExecutouoCOMANDO,"admin.permissao") then
        local sourceDoJogadorParaSpectar = vRP.getUserSource(user_idDoJogadorParaSpectar)
        if true then
            TriggerClientEvent("SpecMode", source,sourceDoJogadorParaSpectar)
        end
    end
end)

------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- /a arma
------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('a',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if args[1] == "taser" and vRP.hasPermission(user_id,"admin.permissao") then
            vRPclient.giveWeapons(source,{["WEAPON_STUNGUN"] = { ammo = 0 }})
            vRPclient.giveWeapons(source,{["weapon_raypistol"] = { ammo = 1 }})
        elseif args[1] == "ak" and vRP.hasPermission(user_id,"admin.permissao") then
            vRPclient.giveWeapons(source,{["weapon_assaultrifle_mk2"] = { ammo = 250 }})
        elseif args[1] == "tec" and vRP.hasPermission(user_id,"admin.permissao") then
            vRPclient.giveWeapons(source,{["weapon_machinepistol"] = { ammo = 250 }})
        elseif args[1] == "g3" and vRP.hasPermission(user_id,"admin.permissao") then
            vRPclient.giveWeapons(source,{["weapon_specialcarbine_mk2"] = { ammo = 250 }})
        elseif args[1] == "m4" and vRP.hasPermission(user_id,"admin.permissao") then
            vRPclient.giveWeapons(source,{["weapon_carbinerifle"] = { ammo = 250 }})
        elseif args[1] == "mpx" and vRP.hasPermission(user_id,"admin.permissao") then
            vRPclient.giveWeapons(source,{["weapon_carbinerifle_mk2"] = { ammo = 250 }})
        elseif args[1] == "sig" and vRP.hasPermission(user_id,"admin.permissao") then
            vRPclient.giveWeapons(source,{["weapon_combatpdw"] = { ammo = 250 }})
        elseif args[1] == "glock" and vRP.hasPermission(user_id,"admin.permissao") then
            vRPclient.giveWeapons(source,{["weapon_combatpistol"] = { ammo = 250 }})
        elseif args[1] == "da" and vRP.hasPermission(user_id,"admin.permissao") then
            vRPclient.giveWeapons(source,{["weapon_doubleaction"] = { ammo = 250 }})
        elseif args[1] == "paraquedas" and vRP.hasPermission(user_id,"admin.permissao") then
            vRPclient.giveWeapons(source,{["gadget_parachute"] = { ammo = 1 }})
        elseif args[1] == "tg" and vRP.hasPermission(user_id,"admin.permissao") then
            vRPclient.giveWeapons(source,{["weapon_hominglauncher"] = { ammo = 10 }})
        elseif args[1] == "uzi" and vRP.hasPermission(user_id,"admin.permissao") then
            vRPclient.giveWeapons(source,{["weapon_microsmg"] = { ammo = 250 }})
        elseif args[1] == "ap" and vRP.hasPermission(user_id,"admin.permissao") then
            vRPclient.giveWeapons(source,{["weapon_appistol"] = { ammo = 250 }})
        elseif args[1] == "five" and vRP.hasPermission(user_id,"admin.permissao") then
            vRPclient.giveWeapons(source,{["weapon_pistol_mk2"] = { ammo = 250 }})
        elseif args[1] == "smg" and vRP.hasPermission(user_id,"admin.permissao") then
            vRPclient.giveWeapons(source,{["weapon_smg_mk2"] = { ammo = 250 }})
        elseif args[1] == "sniper" and vRP.hasPermission(user_id,"admin.permissao") then
            vRPclient.giveWeapons(source,{["weapon_heavysniper_mk2"] = { ammo = 250 }})
        elseif args[1] == "fogos" and vRP.hasPermission(user_id,"admin.permissao") then
            vRPclient.giveWeapons(source,{["weapon_firework"] = { ammo = 25 }})
        elseif args[1] == "luz" and vRP.hasPermission(user_id,"admin.permissao") then
            vRPclient.giveWeapons(source,{["weapon_flashlight"] = { ammo = 250 }})
        elseif args[1] == "colete" and vRP.hasPermission(user_id,"admin.permissao") then
            vRPclient.setArmour(source,100)
        elseif args[1] == "limpiar" and vRP.hasPermission(user_id,"admin.permissao") then
            vRPclient.giveWeapons(source,{},true)
        elseif vRP.hasPermission(user_id,"admin.permissao") then
            TriggerClientEvent("Notify",source,"negado","Especifique uma arma.")
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ADD CASA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('addcasa',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        if args[1] and args[2] then
            local nuser_id = parseInt(args[1])
            local identity = vRP.getUserIdentity(user_id)
            local identitynu = vRP.getUserIdentity(nuser_id)
            vRP.execute("homes/rem_allpermissions",{ home = tostring(args[2]) })
            vRP.execute("homes/buy_permissions",{ home = tostring(args[2]), user_id = nuser_id, tax = os.time() })
            TriggerClientEvent("Notify",source,"sucesso","Voce adicionou a casa <b>"..args[2].."</b> para o Passaporte: <b>"..parseInt(args[1]).."</b>.") 
            SendWebhookMessage(webhookcasas,"```ini\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ADICIONOU A CASA]: "..args[2].." \n[PARA O ID]: "..nuser_id.." "..identitynu.name.." "..identitynu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r``` <@310606304995442690> <@290346669294354434>") 
        end
    end
end)

------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FUEL
------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('admfuel',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"admin.permissao") then
			TriggerClientEvent("admfuel",source)
		end	
	end
end)

------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FUEL
------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('admfueln',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id,"admin.permissao") then
            TriggerClientEvent("admfuel",source)
        end 
    end
end)

--[ DEBUG ]-------------------------------------------------------------------------------------------------------------------

RegisterCommand('debug',function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
		local player = vRP.getUserSource(user_id)
		if vRP.hasPermission(user_id,"ceo.permissao") then
			TriggerClientEvent("ToggleDebug",player)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHAT CEO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('st',function(source,args,rawCommand)
    if args[1] then
        local user_id = vRP.getUserId(source)
        local identity = vRP.getUserIdentity(user_id)
        local permission = "ceo.permissao"
        if vRP.hasPermission(user_id,permission) then
            local soldado = vRP.getUsersByPermission(permission)
            for l,w in pairs(soldado) do
                local player = vRP.getUserSource(parseInt(w))
                if player then
                    async(function()
                        TriggerClientEvent('chatMessage',player,"[CHAT CEO] ["..user_id.."] "..identity.name.." "..identity.firstname,{0,191,255},rawCommand:sub(3))
                    end)
                end
            end
        end
    end
end)