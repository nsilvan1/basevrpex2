-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("vrp_chest",src)
vCLIENT = Tunnel.getInterface("vrp_chest")
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookbaupolicia = "https://discord.com/api/webhooks/853698955904417812/QVl5v-wlgy2uNoC5o6vWzjDblqjBWxOAD4YEAk4-AxRjgoxJevRuqrqTuvUuD6FRIfeq"
local webhookbauparamedico = "https://discord.com/api/webhooks/856343032635195442/OABMktlKpmKUIsDHxyGF1jL08A4Wa6wvE7lUH97q9y38rcc0SD_95Wv9OdSe8wSOUjlc"
local webhookbaugangues = "https://discord.com/api/webhooks/853699002540884028/PImtMRgGO7kMpvSkLXX6A0kPEa-vedEKf8PCv_kJKxc61CgVNAMdfuOU4hy8Eish26mx"
local webhookbauBloods = "https://discord.com/api/webhooks/853699061995405312/serSsBOZNdktEzLY46m1BPaU0l0sklk83vGdoZfVUO1D2KpHnERfDEH9k6qqWrh7BwsX"
local webhookbauCrips = "https://discord.com/api/webhooks/853699107310927904/MZbpXQZTqkYCaHfX8p6rT7nhkPZwu5FUAMFy_D3wrNIySAkvc1GVPTcjtX-hI_X7yDE3"
local webhookbauAlbanesa = "https://discord.com/api/webhooks/853699147122999306/t1h-lSlZsYJ_e4-3-FV4hKQ_hqy3pyeZGMWmvJkgYED1Gr84AWXdQjfgr0iAXv_BtYO2"

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST
-----------------------------------------------------------------------------------------------------------------------------------------
local chest = {
	["Policia"] = { 15000,"policia.permissao" },
	["Paramedico"] = { 15000,"paramedico.permissao" },
	["Ballas"] = { 5000,"ballas.permissao" },
	["Groove"] = { 5000,"grove.permissao" },
	["Vagos"] = { 5000,"vagos.permissao" },
	["Bloods"] = { 5000,"blood.permissao" },
	["Crips"] = { 5000,"crips.permissao" },
	["Albanesa"] = { 5000,"albanesa.permissao" },
	["Sovietica"] = { 5000,"mafia.permissao" },
	["Britanica"] = { 5000,"britanicabau.permissao" },
	["MotoClub"] = { 5000,"motoclub.permissao" },
	["Bahamas"] = { 5000,"bahamas.permissao" },
	["Lifeinvader"] = { 5000,"lifeinvader.permissao" },
	["Mecanico"] = { 5000,"mecanico.permissao" },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local actived = {}
local chestTimer = 0
local beingUsed = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVEDOWNTIME
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for k,v in pairs(actived) do
            if v > 0 then
                actived[k] = v - 1
                if v == 0 then
                    actived[k] = nil
                end
            end
        end
    end
end)
 
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if chestTimer > 0 then
            chestTimer = chestTimer - 1
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKINTPERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkIntPermissions(chestName)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if not vRP.searchReturn(source,user_id) then
            if vRP.hasPermission(user_id,chest[chestName][2]) then
                if not beingUsed[chest[chestName][2]] then
                    beingUsed[chest[chestName][2]] = true
                     return true         
                end
            end
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function src.openChest(chestName)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local hsinventory = {}
        local myinventory = {}
        local data = vRP.getSData("chest:"..tostring(chestName))
        local result = json.decode(data) or {}
        if result then
            for k,v in pairs(result) do
                table.insert(hsinventory,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, peso = vRP.getItemWeight(k) })
            end
 
            local inv = vRP.getInventory(parseInt(user_id))
            for k,v in pairs(inv) do
                table.insert(myinventory,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, peso = vRP.getItemWeight(k) })
            end
        end
        return hsinventory,myinventory,vRP.getInventoryWeight(user_id),vRP.getInventoryMaxWeight(user_id),vRP.computeItemsWeight(result),parseInt(chest[tostring(chestName)][1])
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function src.storeItem(chestName,itemName,amount)
	local source = source
	if itemName then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if user_id and actived[parseInt(user_id)] == 0 or not actived[parseInt(user_id)] then
			if string.match(itemName,"identidade") then
				TriggerClientEvent("Notify",source,"importante","Não pode guardar este item.",8000)
				return
			end

			local data = vRP.getSData("chest:"..tostring(chestName))
			local items = json.decode(data) or {}
				if items then
					if parseInt(amount) > 0 then
						local new_weight = vRP.computeItemsWeight(items)+vRP.getItemWeight(itemName)*parseInt(amount)
						if new_weight <= parseInt(chest[tostring(chestName)][1]) then
							if vRP.tryGetInventoryItem(parseInt(user_id),itemName,parseInt(amount)) then
								if user_id and actived[parseInt(user_id)] == 0 or not actived[parseInt(user_id)] then
									actived[parseInt(user_id)] = 4
								if chestName == "Policia" then
									SendWebhookMessage(webhookbaupolicia,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[GUARDOU]: "..vRP.format(parseInt(amount)).." "..vRP.itemNameList(itemName).." \n[BAU]: "..chestName.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
								elseif chestName == "Ballas" or chestName == "Groove" or chestName == "Vagos" or chestName == "Mafia" or chestName == "Elements" or chestName == "MotoClub" or chestName == "Bahamas" or chestName == "Bratva" then
									SendWebhookMessage(webhookbaugangues,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[GUARDOU]: "..vRP.format(parseInt(amount)).." "..vRP.itemNameList(itemName).." \n[BAU]: "..chestName.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
								elseif chestName == "Bloods" then
									SendWebhookMessage(webhookbaubloods,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[GUARDOU]: "..vRP.format(parseInt(amount)).." "..vRP.itemNameList(itemName).." \n[BAU]: "..chestName.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
								elseif chestName == "Crips" then
									SendWebhookMessage(webhookbauCrips,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[GUARDOU]: "..vRP.format(parseInt(amount)).." "..vRP.itemNameList(itemName).." \n[BAU]: "..chestName.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
								elseif chestName == "Albanesa" then
									SendWebhookMessage(webhookbauAlbanesa,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[GUARDOU]: "..vRP.format(parseInt(amount)).." "..vRP.itemNameList(itemName).." \n[BAU]: "..chestName.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
								elseif chestName == "Paramedico" then
									SendWebhookMessage(webhookbauparamedico,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[GUARDOU]: "..vRP.format(parseInt(amount)).." "..vRP.itemNameList(itemName).." \n[BAU]: "..chestName.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")	
								end
								if items[itemName] ~= nil then
									items[itemName].amount = parseInt(items[itemName].amount) + parseInt(amount)
								else
									items[itemName] = { amount = parseInt(amount) }
								end
								vRP.setSData("chest:"..tostring(chestName),json.encode(items))
								TriggerClientEvent('Creative:UpdateChest',source,'updateChest')
							end

						end
					else
						TriggerClientEvent("Notify",source,"negado","<b>Vault</b> cheio.",8000)
					end
				else
					TriggerClientEvent("Notify",source,"negado","Digite o valor corretamente.",8000)
				end
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function src.takeItem(chestName,itemName,amount)
	local source = source
	if itemName then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
			if user_id and actived[parseInt(user_id)] == 0 or not actived[parseInt(user_id)] then
				local data = vRP.getSData("chest:"..tostring(chestName))
				local items = json.decode(data) or {}
				if items then
					if parseInt(amount) > 0 then
						if items[itemName] ~= nil and parseInt(items[itemName].amount) >= parseInt(amount) then
							if vRP.getInventoryWeight(parseInt(user_id))+vRP.getItemWeight(itemName)*parseInt(amount) <= vRP.getInventoryMaxWeight(parseInt(user_id)) then
								if user_id and actived[parseInt(user_id)] == 0 or not actived[parseInt(user_id)] then
									actived[parseInt(user_id)] = 4
								if chestName == "Policia" then
									SendWebhookMessage(webhookbaupolicia,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RETIROU]: "..vRP.format(parseInt(amount)).." "..vRP.itemNameList(itemName).." \n[BAU]: "..chestName.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
								elseif chestName == "Ballas" or chestName == "Groove" or chestName == "Vagos" or chestName == "Mafia" or chestName == "Elements" or chestName == "MotoClub" or chestName == "Bahamas" or chestName == "Bratva" then
									SendWebhookMessage(webhookbaugangues,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RETIROU]: "..vRP.format(parseInt(amount)).." "..vRP.itemNameList(itemName).." \n[BAU]: "..chestName.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
								elseif chestName == "Bloods" then
									SendWebhookMessage(webhookbauBloods,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RETIROU]: "..vRP.format(parseInt(amount)).." "..vRP.itemNameList(itemName).." \n[BAU]: "..chestName.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
								elseif chestName == "Crips" then
									SendWebhookMessage(webhookbauCrips,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RETIROU]: "..vRP.format(parseInt(amount)).." "..vRP.itemNameList(itemName).." \n[BAU]: "..chestName.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
								elseif chestName == "webhookbauAlbanesa" then
									SendWebhookMessage(webhookbauCrips,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RETIROU]: "..vRP.format(parseInt(amount)).." "..vRP.itemNameList(itemName).." \n[BAU]: "..chestName.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
								end
								vRP.giveInventoryItem(parseInt(user_id),itemName,parseInt(amount))
								items[itemName].amount = parseInt(items[itemName].amount) - parseInt(amount)
								if parseInt(items[itemName].amount) <= 0 then
									items[itemName] = nil
								end
							
								TriggerClientEvent('Creative:UpdateChest',source,'updateChest')
								vRP.setSData("chest:"..tostring(chestName),json.encode(items))
							end
							
						else
							TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
						end
					end
				else
					TriggerClientEvent("Notify",source,"negado","Digite o valor corretamente.",8000)
				end
				
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
function src.chestClose(chestName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		beingUsed[chest[chestName][2]] = false
	end
	return false
end