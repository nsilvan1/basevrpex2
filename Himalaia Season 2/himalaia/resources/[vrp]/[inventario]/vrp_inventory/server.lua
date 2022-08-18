-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
local idgens = Tools.newIDGenerator()
Tunnel.bindInterface("vrp_inventory",cRP)
vCLIENT = Tunnel.getInterface("vrp_inventory")
vRPclient = Tunnel.getInterface("vRP")

vGARAGE = Tunnel.getInterface("vrp_garages")
vDIAGNOSTIC = Tunnel.getInterface("vrp_diagnostic")
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookequipar = "https://discord.com/api/webhooks//A5-blezuSD7yRDGNL9Zxm3-YRMH7C2xHyIfXDgpy0LOoJn3noge67YpAXWEnkEWSvhCj" 
local webhookenviaritem = "https://discord.com/api/webhooks//_2tln-NOn-WZ2fk6FDNywcFskT6Ufu0R6VLDGQ8DxFxbVIQNw6ZtsFs-fLreXNOPdgXg"
local webhookdropar = ""

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local actived = {}

local vthirst = 0
local vhunger = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOCHILA
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.Mochila()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local inventario = {}
		local inv = vRP.getInventory(user_id)
		for k,v in pairs(inv) do
			if vRP.itemBodyList(k) then
				table.insert(inventario,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, type = vRP.itemTypeList(k), peso = vRP.getItemWeight(k), desc = vRP.itemDescList(k) })
			end
		end
		return inventario,vRP.getInventoryWeight(user_id),vRP.getInventoryMaxWeight(user_id)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SENDITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.sendItem(itemName,amount)
	local source = source
	if itemName then
		local user_id = vRP.getUserId(source)
		local nplayer = vRPclient.getNearestPlayer(source,2)
		local nuser_id = vRP.getUserId(nplayer)
		local identity = vRP.getUserIdentity(user_id)
		local identitynu = vRP.getUserIdentity(nuser_id)
		if nuser_id and vRP.itemIndexList(itemName) and itemName ~= "identidade" then
			if parseInt(amount) > 0 then
				if vRP.getInventoryWeight(nuser_id) + vRP.getItemWeight(itemName) * amount <= vRP.getInventoryMaxWeight(nuser_id) then
					if vRP.tryGetInventoryItem(user_id,itemName,amount) then
						vRP.giveInventoryItem(nuser_id,itemName,amount)
						vRPclient._playAnim(source,true,{{"mp_common","givetake1_a"}},false)
						TriggerClientEvent("Notify",source,"sucesso","Enviou <b>"..vRP.format(parseInt(amount)).."x "..vRP.itemNameList(itemName).."</b>.",8000)
						SendWebhookMessage(webhookenviaritem,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ENVIOU]: "..vRP.format(amount).." "..vRP.itemNameList(itemName).." \n[PARA O ID]: "..nuser_id.." "..identitynu.name.." "..identitynu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
						TriggerClientEvent("Notify",nplayer,"sucesso","Recebeu <b>"..vRP.format(parseInt(amount)).."x "..vRP.itemNameList(itemName).."</b>.",8000)
						TriggerClientEvent('Creative:Update',source,'updateMochila')
						TriggerClientEvent('Creative:Update',nplayer,'updateMochila')
						return true
					end
				end
			else
				local inv = vRP.getInventory(user_id)
				for k,v in pairs(inv) do
					if itemName == k then
						if vRP.getInventoryWeight(nuser_id) + vRP.getItemWeight(itemName) * parseInt(v.amount) <= vRP.getInventoryMaxWeight(nuser_id) then
							if vRP.tryGetInventoryItem(user_id,itemName,parseInt(v.amount)) then
								vRP.giveInventoryItem(nuser_id,itemName,parseInt(v.amount))
								vRPclient._playAnim(source,true,{{"mp_common","givetake1_a"}},false)
								TriggerClientEvent("Notify",source,"sucesso","Enviou <b>"..vRP.format(parseInt(v.amount)).."x "..vRP.itemNameList(itemName).."</b>.",8000)
								SendWebhookMessage(webhookenviaritem,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ENVIOU]: "..vRP.format(parseInt(v.amount)).." "..vRP.itemNameList(itemName).." \n[PARA O ID]: "..nuser_id.." "..identitynu.name.." "..identitynu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
								TriggerClientEvent("Notify",nplayer,"sucesso","Recebeu <b>"..vRP.format(parseInt(v.amount)).."x "..vRP.itemNameList(itemName).."</b>.",8000)
								TriggerClientEvent('Creative:Update',source,'updateMochila')
								TriggerClientEvent('Creative:Update',nplayer,'updateMochila')
								return true
							end
						end
					end
				end
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.dropItem(itemName,amount)
	local source = source
	if itemName ~= "identidade" then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		local x,y,z = vRPclient.getPosition(source)
		if parseInt(amount) > 0 and vRP.tryGetInventoryItem(user_id,itemName,amount) then
			TriggerEvent("DropSystem:create",itemName,amount,x,y,z)
			vRPclient._playAnim(source,true,{{"pickup_object","pickup_low"}},false)
			SendWebhookMessage(webhookdropar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[DROPOU]: "..vRP.itemNameList(itemName).." \n[QUANTIDADE]: "..vRP.format(parseInt(amount)).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			TriggerClientEvent('Creative:Update',source,'updateMochila')
			return true
		else
			local inv = vRP.getInventory(user_id)
			for k,v in pairs(inv) do
				if itemName == k then
					if vRP.tryGetInventoryItem(user_id,itemName,parseInt(v.amount)) then
						TriggerEvent("DropSystem:create",itemName,parseInt(v.amount),x,y,z)
						vRPclient._playAnim(source,true,{{"pickup_object","pickup_low"}},false)
						SendWebhookMessage(webhookdropar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[DROPOU]: "..vRP.itemNameList(itemName).." \n[QUANTIDADE]: "..vRP.format(parseInt(v.amount)).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
						TriggerClientEvent('Creative:Update',source,'updateMochila')
						return true
					end
				end
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANDAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
local bandagem = {}
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k,v in pairs(bandagem) do
			if v > 0 then
				bandagem[k] = v - 1
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- USEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
local pick = {}
local blips = {}
function cRP.useItem(itemName,type,ramount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and ramount ~= nil and parseInt(ramount) >= 0 and not actived[user_id] and actived[user_id] == nil then
		if type == "usar" then
			if itemName == "bandagem" then
				vida = vRPclient.getHealth(source)
				if vida > 101 and vida < 400 then
					if bandagem[user_id] == 0 or not bandagem[user_id] then
						if vRP.tryGetInventoryItem(user_id,"bandagem",1) or vRP.tryGetInventoryItem(user_id,"kitmedico",1) then
							actived[user_id] = true
							vRPclient._CarregarObjeto(source,"amb@world_human_clipboard@male@idle_a","idle_c","v_ret_ta_firstaid",49,60309)
							TriggerClientEvent('Creative:Update',source,'updateMochila')
							TriggerClientEvent('cancelando',source,true)
							TriggerClientEvent("progress",source,9000,"Cura")
							SetTimeout(9000,function()
								actived[user_id] = nil
								bandagem[user_id] = 80
								TriggerClientEvent('bandagem',source)
								TriggerClientEvent('cancelando',source,false)
								vRPclient._DeletarObjeto(source)
								TriggerClientEvent("Notify",source,"sucesso","<b>Cura</b> utilizada com sucesso.",8000)
							end)
						end
					else
						TriggerClientEvent("Notify",source,"importante","Você precisa aguardar <b>"..bandagem[user_id].." segundos</b> para utilizar outra Bandagem.",8000)
					end
				else
					TriggerClientEvent("Notify",source,"aviso","Você não pode utilizar de vida cheia ou nocauteado.",8000)
				end
		    --------------------------------------------------------------------------------------------------------------------------------------------------
			--[ REMEDIOS ]------------------------------------------------------------------------------------------------------------------------------------
			--------------------------------------------------------------------------------------------------------------------------------------------------
		elseif itemName == "dorflex" or itemName == "cicatricure" or itemName == "dipiroca" or itemName == "nocucedin" or itemName == "paracetanal" or itemName == "decupramim" or itemName == "buscopau" or itemName == "navagina" or itemName == "analdor" or itemName == "sefodex" or itemName == "nokusin" or itemName == "glicoanal" then
			if (vRP.tryGetInventoryItem(user_id,"dorflex",1) or vRP.tryGetInventoryItem(user_id,"cicatricure",1) or vRP.tryGetInventoryItem(user_id,"dipiroca",1) or vRP.tryGetInventoryItem(user_id,"nocucedin",1) or vRP.tryGetInventoryItem(user_id,"paracetanal",1) or vRP.tryGetInventoryItem(user_id,"decupramim",1) or vRP.tryGetInventoryItem(user_id,"buscopau",1) or vRP.tryGetInventoryItem(user_id,"navagina",1) or vRP.tryGetInventoryItem(user_id,"analdor",1) or vRP.tryGetInventoryItem(user_id,"sefodex",1) or vRP.tryGetInventoryItem(user_id,"nokusin",1) or vRP.tryGetInventoryItem(user_id,"glicoanal",1)) then
				TriggerClientEvent('Creative:Update',source,'updateMochila')
				vRPclient._playAnim(source,true,{{"mp_player_intdrink","loop_bottle"}},true)	
				TriggerClientEvent('cancelando',source,true)
				TriggerClientEvent("progress",source,5000,"bandagem")
				SetTimeout(5000,function()
					vRPclient._stopAnim(source,false)
					TriggerClientEvent('cancelando',source,false)
					TriggerClientEvent("Notify",source,"sucesso","Remédio utilizado com sucesso.",8000)
				end)
			end
		    --------------------------------------------------------------------------------------------------------------------------------------------------
			--[ BEBIDAS ]-------------------------------------------------------------------------------------------------------------------------------------
			--------------------------------------------------------------------------------------------------------------------------------------------------	
			    elseif itemName == "agua" then
                local src = source
                if vRP.tryGetInventoryItem(user_id,"agua",1) then

                    actived[user_id] = true
                    TriggerClientEvent('Creative:Update',source,'updateMochila')
                    vRPclient._CarregarObjeto(src,"mp_player_intdrink","loop_bottle","prop_ld_flow_bottle",49,60309)
                    TriggerClientEvent("progress",source,10000,"Bebendo")

                    SetTimeout(10000,function()
                        actived[user_id] = nil
						vthirst = -20
                        vRPclient._stopAnim(source,false)
                        vRP.varyThirst(user_id,vthirst)
                        vRP.varyHunger(user_id,0)
                        vRPclient._DeletarObjeto(src)
                        TriggerClientEvent("Notify",source,"sucesso","Você tomou <b>Água</b>.")
                    end)

                end
	
			elseif itemName == "leite" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"leite",1) then

					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_energy_drink",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")

					SetTimeout(10000,function()
						actived[user_id] = nil
						vhunger = -20
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,0)
						vRP.varyHunger(user_id,vhunger)
						vRPclient._DeletarObjeto(src)
						TriggerClientEvent("Notify",source,"sucesso","Você tomou <b>Leite</b>.")
					end)

				end
			elseif itemName == "colete" then
				if vRP.tryGetInventoryItem(user_id,"colete",1) then
					vRPclient.setArmour(source,100)
					TriggerClientEvent('Creative:Update',source,'updateMochila')
				end	
			elseif itemName == "cafe" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"cafe",1) then

					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_aa_coffee@idle_a","idle_a","prop_fib_coffee",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")

					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,-30)
						vRP.varyHunger(user_id,0)
						vRPclient._DeletarObjeto(src)
						TriggerClientEvent("Notify",source,"sucesso","Você tomou <b>Café</b>.")
					end)

				end
			elseif itemName == "cafecleite" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"cafecleite",1) then

					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_aa_coffee@idle_a","idle_a","prop_fib_coffee",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")

					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,-40)
						vRP.varyHunger(user_id,0)
						vRPclient._DeletarObjeto(src)
						TriggerClientEvent("Notify",source,"sucesso","Você tomou <b>Cafe com Leite</b>.")
					end)

				end
			elseif itemName == "cafeexpresso" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"cafeexpresso",1) then

					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_aa_coffee@idle_a","idle_a","prop_fib_coffee",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")

					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,-40)
						vRP.varyHunger(user_id,0)
						vRPclient._DeletarObjeto(src)
						TriggerClientEvent("Notify",source,"sucesso","Você tomou <b>Cafe Expresso</b>.")
					end)

				end
			elseif itemName == "capuccino" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"capuccino",1) then

					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_aa_coffee@idle_a","idle_a","prop_fib_coffee",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")

					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,-55)
						vRP.varyHunger(user_id,0)
						vRPclient._DeletarObjeto(src)
						TriggerClientEvent("Notify",source,"sucesso","Você tomou <b>Capuccino</b>.")
					end)

				end
			elseif itemName == "frappuccino" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"frappuccino",1) then

					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_aa_coffee@idle_a","idle_a","prop_fib_coffee",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")

					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,-65)
						vRP.varyHunger(user_id,0)
						vRPclient._DeletarObjeto(src)
						TriggerClientEvent("Notify",source,"sucesso","Você tomou <b>Frappuccino</b>.")
					end)

				end
			elseif itemName == "cha" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"cha",1) then

					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_energy_drink",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")

					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,-50)
						vRP.varyHunger(user_id,0)
						vRPclient._DeletarObjeto(src)
						TriggerClientEvent("Notify",source,"sucesso","Você tomou <b>Chá</b>.")
					end)

				end
			elseif itemName == "icecha" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"icecha",1) then

					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_energy_drink",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")

					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,-50)
						vRP.varyHunger(user_id,0)
						vRPclient._DeletarObjeto(src)
						TriggerClientEvent("Notify",source,"sucesso","Você tomou <b>Chá Gelado</b>.")
					end)

				end
			elseif itemName == "cola" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"cola",1) then

					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","ng_proc_sodacan_01a",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")

					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,-40)
						vRP.varyHunger(user_id,0)
						vRPclient._DeletarObjeto(src)
						TriggerClientEvent("Notify",source,"sucesso","Você tomou um<b>Refrigerante</b>.")
					end)

				end
			elseif itemName == "mochila" then
				if vRP.getInventoryMaxWeight(user_id) >= 90 then
					TriggerClientEvent("Notify",source,"negado","Você não pode equipar mais mochilas.",8000)
				else
					if vRP.tryGetInventoryItem(user_id,"mochila",1) then
						TriggerClientEvent('Creative:Update',source,'updateMochila')
						vRP.varyExp(user_id,"physical","strength",650)
						TriggerClientEvent("Notify",source,"sucesso","<b>Mochila</b> equipada com sucesso.",8000)
					end
				end
			elseif itemName == "cerveja" then
				if vRP.tryGetInventoryItem(user_id,"cerveja",1) then
					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					TriggerClientEvent('cancelando',source,true)
					vRPclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
					TriggerClientEvent("progress",source,30000,"bebendo")
					SetTimeout(30000,function()
						actived[user_id] = nil
						vRPclient.playScreenEffect(source,"RaceTurbo",180)
						vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
						TriggerClientEvent('cancelando',source,false)
						vRPclient._DeletarObjeto(source)
						TriggerClientEvent("Notify",source,"sucesso","<b>Cerveja</b> utilizada com sucesso.",8000)
					end)
				end
			elseif itemName == "tequila" then
				if vRP.tryGetInventoryItem(user_id,"tequila",1) then
					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					TriggerClientEvent('cancelando',source,true)
					vRPclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
					TriggerClientEvent("progress",source,30000,"bebendo")
					SetTimeout(30000,function()
						actived[user_id] = nil
						vRPclient.playScreenEffect(source,"RaceTurbo",180)
						vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
						TriggerClientEvent('cancelando',source,false)
						vRPclient._DeletarObjeto(source)
						TriggerClientEvent("Notify",source,"sucesso","<b>Tequila</b> utilizada com sucesso.",8000)
					end)
				end
			elseif itemName == "vodka" then
				if vRP.tryGetInventoryItem(user_id,"vodka",1) then
					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					TriggerClientEvent('cancelando',source,true)
					vRPclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
					TriggerClientEvent("progress",source,30000,"bebendo")
					SetTimeout(30000,function()
						actived[user_id] = nil
						vRPclient.playScreenEffect(source,"RaceTurbo",180)
						vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
						TriggerClientEvent('cancelando',source,false)
						vRPclient._DeletarObjeto(source)
						TriggerClientEvent("Notify",source,"sucesso","<b>Vodka</b> utilizada com sucesso.",8000)
					end)
				end
			elseif itemName == "whisky" then
				if vRP.tryGetInventoryItem(user_id,"whisky",1) then
					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					TriggerClientEvent('cancelando',source,true)
					vRPclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","p_whiskey_notop",49,28422)
					TriggerClientEvent("progress",source,30000,"bebendo")
					SetTimeout(30000,function()
						actived[user_id] = nil
						vRPclient.playScreenEffect(source,"RaceTurbo",180)
						vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
						TriggerClientEvent('cancelando',source,false)
						vRPclient._DeletarObjeto(source)
						TriggerClientEvent("Notify",source,"sucesso","<b>Whisky</b> utilizado com sucesso.",8000)
					end)
				end
			elseif itemName == "conhaque" then
				if vRP.tryGetInventoryItem(user_id,"conhaque",1) then
					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					TriggerClientEvent('cancelando',source,true)
					vRPclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
					TriggerClientEvent("progress",source,30000,"bebendo")
					SetTimeout(30000,function()
						actived[user_id] = nil
						vRPclient.playScreenEffect(source,"RaceTurbo",180)
						vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
						TriggerClientEvent('cancelando',source,false)
						vRPclient._DeletarObjeto(source)
						TriggerClientEvent("Notify",source,"sucesso","<b>Conhaque</b> utilizado com sucesso.",8000)
					end)
				end
			elseif itemName == "absinto" then
				if vRP.tryGetInventoryItem(user_id,"absinto",1) then
					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					TriggerClientEvent('cancelando',source,true)
					vRPclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
					TriggerClientEvent("progress",source,30000,"bebendo")
					SetTimeout(30000,function()
						actived[user_id] = nil
						vRPclient.playScreenEffect(source,"RaceTurbo",180)
						vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
						TriggerClientEvent('cancelando',source,false)
						vRPclient._DeletarObjeto(source)
						TriggerClientEvent("Notify",source,"sucesso","<b>Absinto</b> utilizado com sucesso.",8000)
					end)
				end
			elseif itemName == "maconha" then
				if vRP.tryGetInventoryItem(user_id,"maconha",1) then
					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					vRPclient._playAnim(source,true,{{"mp_player_int_uppersmoke","mp_player_int_smoke"}},true)
					TriggerClientEvent("progress",source,10000,"fumando")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRPclient.playScreenEffect(source,"RaceTurbo",180)
						vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
						TriggerClientEvent("Notify",source,"sucesso","<b>Maconha</b> utilizada com sucesso.",8000)
					end)
				end
			elseif itemName == "cocaina" then
				if vRP.tryGetInventoryItem(user_id,"cocaina",1) then
					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					vRPclient._playAnim(source,true,{{"mp_player_int_uppersmoke","mp_player_int_smoke"}},true)
					TriggerClientEvent('cancelando',source,true)
					TriggerClientEvent("progress",source,10000,"cheirando")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						TriggerClientEvent('cancelando',source,false)
						vRPclient.playScreenEffect(source,"RaceTurbo",120)
						vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",120)
						TriggerClientEvent("Notify",source,"sucesso","<b>Cocaína</b> utilizada com sucesso.",8000)
					end)
				end
			elseif itemName == "lancaperfume" then
				if vRP.tryGetInventoryItem(user_id,"lancaperfume",1) then
					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					vRPclient._playAnim(source,true,{{"mp_player_int_uppersmoke","mp_player_int_smoke"}},true)
					TriggerClientEvent('cancelando',source,true)
					TriggerClientEvent("progress",source,10000,"baforando")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						TriggerClientEvent('cancelando',source,false)
						vRPclient.playScreenEffect(source,"RaceTurbo",120)
						vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",120)
						TriggerClientEvent("Notify",source,"sucesso","<b>Lança</b> utilizada com sucesso.",8000)
					end)
				end
			elseif itemName == "metanfetamina" then
				if vRP.tryGetInventoryItem(user_id,"metanfetamina",1) then
					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					vRPclient._playAnim(source,true,{{"mp_player_int_uppersmoke","mp_player_int_smoke"}},true)
					TriggerClientEvent("progress",source,10000,"fumando")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRPclient.playScreenEffect(source,"RaceTurbo",180)
						vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
						TriggerClientEvent("Notify",source,"sucesso","<b>Metanfetamina</b> utilizada com sucesso.",8000)
					end)
				end	
			elseif itemName == "lsd" then
				if vRP.tryGetInventoryItem(user_id,"lsd",1) then
					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					vRPclient._playAnim(source,true,{{"mp_player_int_uppersmoke","mp_player_int_smoke"}},true)
					TriggerClientEvent("progress",source,10000,"tomando")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRPclient.playScreenEffect(source,"RaceTurbo",180)
						vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
						TriggerClientEvent("Notify",source,"sucesso","<b>LSD</b> utilizado com sucesso.",8000)
					end)
				end		
			elseif itemName == "capuz" then
				if vRP.getInventoryItemAmount(user_id,"capuz") >= 1 then
					local nplayer = vRPclient.getNearestPlayer(source,2)
					if nplayer then
						vRPclient.setCapuz(nplayer)
						vRP.closeMenu(nplayer)
						TriggerClientEvent("Notify",source,"sucesso","<b>Capuz</b> utilizado com sucesso.",8000)
					end
				end
			elseif itemName == "energetico" then
				if vRP.tryGetInventoryItem(user_id,"energetico",1) then
					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					TriggerClientEvent('cancelando',source,true)
					vRPclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_energy_drink",49,28422)
					TriggerClientEvent("progress",source,7000,"bebendo")
					SetTimeout(7000,function()
						actived[user_id] = nil
						TriggerClientEvent('energeticos',source,true)
						TriggerClientEvent('cancelando',source,false)
						vRPclient._DeletarObjeto(source)
						TriggerClientEvent("Notify",source,"sucesso","<b>Energético</b> utilizado com sucesso.",8000)
					end)
					SetTimeout(60000,function()
						TriggerClientEvent('energeticos',source,false)
						TriggerClientEvent("Notify",source,"aviso","O efeito do <b>Energético</b> passou e o coração voltou a bater normalmente.",8000)
					end)
				end
				elseif itemName == "flash" then
				if vRP.tryGetInventoryItem(user_id,"flash",1) then
					actived[user_id] = true
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					TriggerClientEvent('cancelando',source,true)
					vRPclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_energy_drink",49,28422)
					TriggerClientEvent("progress",source,7000,"bebendo")
					SetTimeout(7000,function()
						actived[user_id] = nil
						TriggerClientEvent('flash',source,true)
						TriggerClientEvent('cancelando',source,false)
						vRPclient._DeletarObjeto(source)
						TriggerClientEvent("Notify",source,"sucesso","<b>Flash</b> utilizado com sucesso.",8000)
					end)
					SetTimeout(60000,function()
						TriggerClientEvent('flash',source,false)
						TriggerClientEvent("Notify",source,"aviso","O efeito do <b>Flash</b> passou e o coração voltou a bater normalmente.",8000)
					end)
				end
			elseif itemName == "lockpick" then
				local vehicle,vnetid,placa,vname,lock,banned,trunk,model,street = vRPclient.vehList(source,7)
				local policia = vRP.getUsersByPermission("policia.permissao")
				if #policia < 0 then
					TriggerClientEvent("Notify",source,"aviso","Número insuficiente de policiais no momento para iniciar o roubo.")
					return true
				end
				if vRP.hasPermission(user_id,"paramedico.permissao") then
					TriggerEvent("setPlateEveryone",placa)
					vGARAGE.vehicleClientLock(-1,vnetid,lock)
					return
				end
				if vRP.getInventoryItemAmount(user_id,"lockpick") >= 1 and vRP.tryGetInventoryItem(user_id,"lockpick",1) and vehicle then
					actived[user_id] = true
					if vRP.hasPermission(user_id,"paramedico.permissao") then
						actived[user_id] = nil
						TriggerClientEvent('Creative:Update',source,'updateMochila')
						TriggerEvent("setPlateEveryone",placa)
						vGARAGE.vehicleClientLock(-1,vnetid,lock)
						TriggerClientEvent("vrp_sound:source",source,'lock',0.5)
						return
					end

					TriggerClientEvent('cancelando',source,true)
					vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
					TriggerClientEvent("progress",source,20000,"roubando")
					SetTimeout(20000,function()
						actived[user_id] = nil
						TriggerClientEvent('cancelando',source,false)
						vRPclient._stopAnim(source,false)

						if math.random(100) >= 80 then
							TriggerClientEvent('Creative:Update',source,'updateMochila')
							TriggerEvent("setPlateEveryone",placa)
							vGARAGE.vehicleClientLock(-1,vnetid,lock)
							TriggerClientEvent("vrp_sound:source",source,'lock',0.5)
						else
							TriggerClientEvent("Notify",source,"negado","Roubo do veículo concluído e as autoridades foram acionadas.",8000)
							local policia = vRP.getUsersByPermission("policia.permissao")
							local x,y,z = vRPclient.getPosition(source)
							for k,v in pairs(policia) do
								local player = vRP.getUserSource(parseInt(v))
								if player then
									async(function()
										local id = idgens:gen()
										vRPclient._playSound(player,"CONFIRM_BEEP","HUD_MINI_GAME_SOUNDSET")
										TriggerClientEvent('chatMessage',player,"Dispatch",{65,130,255},"Roubo na ^1"..street.."^0 do veículo ^1"..model.."^0 de placa ^1"..placa.."^0 verifique o ocorrido.")
										pick[id] = vRPclient.addBlip(player,x,y,z,10,5,"Ocorrência",0.5,false)
										SetTimeout(20000,function() vRPclient.removeBlip(player,pick[id]) idgens:free(id) end)
									end)
								end
							end
						end
					end)
				end
			elseif itemName == "masterpick" then
				local vehicle,vnetid,placa,vname,lock,banned,trunk,model,street = vRPclient.vehList(source,7)
				local policia = vRP.getUsersByPermission("policia.permissao")
				if #policia < 0 then
					TriggerClientEvent("Notify",source,"aviso","Número insuficiente de policiais no momento para iniciar o roubo.")
					return true
				end
				if vRP.hasPermission(user_id,"policia.permissao") then
					TriggerClientEvent('Creative:Update',source,'updateMochila')
					TriggerEvent("setPlateEveryone",placa)
					vGARAGE.vehicleClientLock(-1,vnetid,lock)
					TriggerClientEvent("vrp_sound:source",source,'lock',0.5)
					return
				end
				if vRP.getInventoryItemAmount(user_id,"masterpick") >= 1 and vehicle then
					actived[user_id] = true
							TriggerClientEvent('cancelando',source,true)
							vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
							TriggerClientEvent("progress",source,60000,"roubando")
							SetTimeout(60000,function()

								TriggerClientEvent('cancelando',source,false)
								vRPclient._stopAnim(source,false)
								actived[user_id] = nil
								TriggerClientEvent('Creative:Update',source,'updateMochila')
								TriggerEvent("setPlateEveryone",placa)
								vGARAGE.vehicleClientLock(-1,vnetid,lock)
								TriggerClientEvent("vrp_sound:source",source,'lock',0.5)
							return
						end)
					end
			elseif itemName == "militec" then
				if not vRPclient.isInVehicle(source) then
					local vehicle = vRPclient.getNearestVehicle(source,3.5)
					if vehicle then
						if vRP.hasPermission(user_id,"mecanicawolf.permissao") then
							actived[user_id] = true
							TriggerClientEvent('cancelando',source,true)
							vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
							TriggerClientEvent("progress",source,30000,"reparando motor")
							SetTimeout(30000,function()
								actived[user_id] = nil
								TriggerClientEvent('cancelando',source,false)
								TriggerClientEvent('repararmotor',source,vehicle)
								vRPclient._stopAnim(source,false)
							end)
						else
							if vRP.tryGetInventoryItem(user_id,"militec",1) then
								actived[user_id] = true
								TriggerClientEvent('Creative:Update',source,'updateMochila')
								TriggerClientEvent('cancelando',source,true)
								vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
								TriggerClientEvent("progress",source,30000,"reparando motor")
								SetTimeout(30000,function()
									actived[user_id] = nil
									TriggerClientEvent('cancelando',source,false)
									TriggerClientEvent('repararmotor',source,vehicle)
									vRPclient._stopAnim(source,false)
								end)
							end
						end
					end
				end	
			elseif itemName == "repairkit" then
				if not vRPclient.isInVehicle(source) then
					local vehicle = vRPclient.getNearestVehicle(source,3.5)
					if vehicle then
						if vRP.hasPermission(user_id,"mecanicawolf.permissao.permissao") then
							actived[user_id] = true
							TriggerClientEvent('cancelando',source,true)
							vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
							TriggerClientEvent("progress",source,30000,"reparando veículo")
							SetTimeout(30000,function()
								actived[user_id] = nil
								TriggerClientEvent('cancelando',source,false)
								TriggerClientEvent('reparar',source)
								vRPclient._stopAnim(source,false)
							end)
						else
							if vRP.tryGetInventoryItem(user_id,"repairkit",1) then
								actived[user_id] = true
								TriggerClientEvent('Creative:Update',source,'updateMochila')
								TriggerClientEvent('cancelando',source,true)
								vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
								TriggerClientEvent("progress",source,30000,"reparando veículo")
								SetTimeout(30000,function()
									actived[user_id] = nil
									TriggerClientEvent('cancelando',source,false)
									TriggerClientEvent('reparar',source)
									vRPclient._stopAnim(source,false)
								end)
							end
						end
					end
				end	
			elseif itemName == "estepes" then
				if not vRPclient.isInVehicle(source) then
					local vehicle = vRPclient.getNearestVehicle(source,7)
					if vehicle then
						if vRP.hasPermission(user_id,"mecanico.permissao") then
							actived[user_id] = true
							TriggerClientEvent('cancelando',source,true)
							vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
							TriggerClientEvent("progress",source,45000)
							SetTimeout(45000,function()
								actived[user_id] = nil
								TriggerClientEvent('cancelando',source,false)
								TriggerClientEvent('repararpneus',source,vehicle)
								vRPclient._stopAnim(source,false)
							end)
						else
							if vRP.tryGetInventoryItem(user_id,"pneus",1) then
								actived[user_id] = true
								TriggerClientEvent('Creative:Update',source,'updateMochila')
								TriggerClientEvent('cancelando',source,true)
								vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
								TriggerClientEvent("progress",source,45000)
								SetTimeout(45000,function()
									actived[user_id] = nil
									TriggerClientEvent('cancelando',source,false)
									TriggerClientEvent('repararpneus',source,vehicle)
									vRPclient._stopAnim(source,false)
								end)
							end
						end
					end
				end	
			elseif itemName == "placa" then
                if vRPclient.GetVehicleSeat(source) then
                    if vRP.tryGetInventoryItem(user_id,"placa",1) then
                        local placa = vRP.generatePlate()
                        TriggerClientEvent('Creative:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        TriggerClientEvent("vehicleanchor",source)
                        TriggerClientEvent("progress",source,59500,"clonando")
                        SetTimeout(60000,function()
                            TriggerClientEvent('cancelando',source,false)
                            TriggerClientEvent("cloneplates",source,placa)
                            --TriggerEvent("setPlateEveryone",placa)
                            TriggerClientEvent("Notify",source,"sucesso","Placa clonada com sucesso.",8000)
                        end)
                    end
				end
			end
		elseif type == "equipar" then
			if vRP.tryGetInventoryItem(user_id,itemName,1) then
				local weapons = {}
				local identity = vRP.getUserIdentity(user_id)
				weapons[string.gsub(itemName,"wbody|","")] = { ammo = 0 }
				vRPclient._giveWeapons(source,weapons)
				SendWebhookMessage(webhookequipar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[EQUIPOU]: "..vRP.itemNameList(itemName).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				TriggerClientEvent('Creative:Update',source,'updateMochila')
			end
		elseif type == "recarregar" then
			local uweapons = vRPclient.getWeapons(source)
      		local weaponuse = string.gsub(itemName,"wammo|","")
      		local weaponusename = "wammo|"..weaponuse
			local identity = vRP.getUserIdentity(user_id)
      		if uweapons[weaponuse] then
        		local itemAmount = 0
        		local data = vRP.getUserDataTable(user_id)
        		for k,v in pairs(data.inventory) do
          		if weaponusename == k then
            		if v.amount > 250 then
              			v.amount = 250
            		end

            		itemAmount = v.amount

					if vRP.tryGetInventoryItem(user_id, weaponusename, parseInt(v.amount)) then
						local weapons = {}
						weapons[weaponuse] = { ammo = v.amount }
						itemAmount = v.amount
						vRPclient._giveWeapons(source,weapons,false)
						SendWebhookMessage(webhookequipar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RECARREGOU]: "..vRP.itemNameList(itemName).." \n[MUNICAO]: "..parseInt(v.amount).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
						TriggerClientEvent('Creative:Update',source,'updateMochila')
						end
					end
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	actived[user_id] = nil
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ GMOCHILA ]---------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('gmochila',function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)

	if user_id then
		if vRP.getExp(user_id,"physical","strength") == 1900 then -- 90Kg
			if vRP.getInventoryMaxWeight(user_id)-vRP.getInventoryWeight(user_id) >= 15 then
				TriggerClientEvent("Notify",source,"sucesso","Você desequipou uma de suas mochilas.")
				vRP.varyExp(user_id,"physical","strength",-580)
				vRP.giveInventoryItem(user_id,"mochila",1)
			else
				TriggerClientEvent("Notify",source,"negado","Você precisa esvaziar a mochila antes de fazer isso.")
			end
		elseif vRP.getExp(user_id,"physical","strength") == 1320 then -- 75Kg
			if vRP.getInventoryMaxWeight(user_id)-vRP.getInventoryWeight(user_id) >= 24 then
				TriggerClientEvent("Notify",source,"sucesso","Você desequipou uma de suas mochilas.")
				vRP.varyExp(user_id,"physical","strength",-650)
				vRP.giveInventoryItem(user_id,"mochila",1)
			else
				TriggerClientEvent("Notify",source,"negado","Você precisa esvaziar a mochila antes de fazer isso.")
			end
		elseif vRP.getExp(user_id,"physical","strength") == 670 then -- 51Kg
			if vRP.getInventoryMaxWeight(user_id)-vRP.getInventoryWeight(user_id) >= 45 then
				TriggerClientEvent("Notify",source,"sucesso","Você desequipou sua mochila.")
				vRP.varyExp(user_id,"physical","strength",-650)
				vRP.giveInventoryItem(user_id,"mochila",1)
			else
				TriggerClientEvent("Notify",source,"negado","Você precisa esvaziar a mochila antes de fazer isso.")
			end
		elseif vRP.getExp(user_id,"physical","strength") == 20 then -- 6Kg
			TriggerClientEvent("Notify",source,"negado","Você não tem mochilas equipadas.")
		end
	end
end)











for n,e in pairs({(function(e,...)local W="This file was obfuscated using PSU Obfuscator 4.0.A | https://www.psu.dev/ & discord.gg/psu";local z=e[(355743046)];local S=e[((501754472-#("woooow u hooked an opcode, congratulations~ now suck my cock")))];local L=e.Q6cX64C56v;local X=e['gRVCX1WY'];local o=e[((630475035-#("psu == femboy hangout")))];local v=e[(1781660)];local F=e[(404337926)];local J=e[(148608376)];local O=e[(945297115)];local G=e[(547305580)];local q=e[((521429625-#("psu 34567890fps, luraph 1fps, xen 0fps")))];local s=e[(524582611)];local u=e[(599516051)];local E=e['WWzQu'];local f=e.RAW482pW;local I=e[((#{942;127;722;883;(function(...)return 847,740,...;end)()}+835090560))];local m=e.RWUVLRLl;local R=e[((#{708;738;62;987;}+669292015))];local Q=e[((568294596-#("When the exploiter is sus")))];local g=e[(119226622)];local j=e["l2fG9xB"];local D=e[(572167784)];local C=e[(432652862)];local t=e["jk5VsiX"];local x=e[((#{648;(function(...)return...;end)(596,262,847,151)}+466726698))];local a=e.ecav3;local c=e[(791244531)];local _=e[(942548926)];local P=e[((#{137;112;587;538;}+849895058))];local U=e[(429467923)];local V=e["jH18rVde7t"];local w=e.U3JljS56OO;local b=e[(586960471)];local H=((getfenv)or(function(...)return(_ENV);end));local l,i,n=({}),(""),(H(x));local d=((n[""..e[t].."\105"..e['WHMj0F']..e['B5brsQgFhV']..e[I]])or(n[""..e[t].."\105"..e['WHMj0F']])or({}));local l=(((d)and(d["\98\120\111"..e[u]]))or(function(e,n)local l,x=x,c;while((e>c)and(n>c))do local d,a=e%o,n%o;if d~=a then x=x+l;end;e,n,l=(e-d)/o,(n-a)/o,l*o;end;if e<n then e=n;end;while e>c do local n=e%o;if n>c then x=x+l;end;e,l=(e-n)/o,l*o;end;return(x);end));local r=(o^D);local p=(r-x);local y,A,k;local h=(i["\98"..e['bPiSJi'].."\116"..e[a]]);local Y=(i[""..e[E]..e[w].."\97"..e[u]]);local r=(i[""..e['hVk0rR']..e[F].."\117\98"]);local r=(i["\115\117\98"]);local i=(n["\116\121\112"..e[a]]);local B=(n["\109"..e[f].."\116\104"]["\102"..e[b]..e[s]..e[s].."\114"]);local M=(n["\115\101\108"..e[a].."\99"..e.WHMj0F]);local T=(n["\112\97"..e[m].."\114\115"]);local N=((n[""..e[C].."\97\116\104"]["\108"..e[j].."\101\120"..e["bcCAp"]])or(function(n,e,...)return((n*o)^e);end));local i=(n[""..e[F]..e[a].."\116\109"..e[a].."\116\97\116"..e[f]..e[t].."\108\101"]);local i=((n["\117\110\112\97\99\107"])or(n["\116"..e[f].."\98"..e[b]..e[a]][""..e[g].."\110\112\97"..e[E]..e.jZGwvrCr]));local g=(n["\114"..e[f].."\119"..e[F]..e[a]..e['WHMj0F']]);local g=(n["\116"..e[s].."\110\117"..e[C].."\98\101\114"]);local Z=(d["\98"..e.tm3a56UI..e[s]..e["WHMj0F"]])or(function(e,...)return(p-e);end);local p=(d["\98\111\114"])or(function(n,e,...)return(p-k(p-n,p-e));end);k=(d["\98"..e[f]..e["tm3a56UI"].."\100"])or(function(n,e,...)return(((n+e)-l(n,e))/o);end);A=((d["\114\115"..e[w].."\105"..e["xDM3C"].."\116"])or(function(n,e,...)if(e<c)then return(y(n,-(e)));end;return(B(n%o^D/o^e));end));y=((d["\108\115"..e[w]..e[m].."\102\116"])or(function(n,e,...)if(e<c)then return(A(n,-(e)));end;return((n*o^e)%o^D);end));if((not(n["\98"..e[m]..e["WHMj0F"]..e['B5brsQgFhV']..e[I]]))and(not(n["\98\105"..e.WHMj0F])))then d[""..e[t].."\111"..e[u]]=p;d[""..e[u]..e[F]..e[w].."\105"..e["xDM3C"].."\116"]=A;d[""..e[t].."\120\111\114"]=l;d[""..e[b].."\115\104"..e[m]..e['xDM3C']..e['WHMj0F']]=y;d["\98"..e[f]..e.tm3a56UI..e[j]]=k;d["\98\110"..e[s]..e["WHMj0F"]]=Z;end;local o=(n["\116"..e[f]..e[t].."\108\101"][""..e[u]..e[a]..e[C].."\111\118"..e[a]]);local f=(n[""..e.WHMj0F.."\97"..e[t]..e[b].."\101"]["\99\111\110\99\97\116"]);local p=(((n[""..e["WHMj0F"].."\97\98\108"..e[a]][""..e[E].."\114"..e[a].."\97\116\101"]))or((function(e,...)return({i({},c,e);});end)));local o=(n[""..e.WHMj0F.."\97\98"..e[b]..e[a]]["\105"..e['tm3a56UI']..e[F]..e[a].."\114\116"]);n[""..e[t].."\105\116\51\50"]=d;local n=((-O+(function()local o,n=c,x;(function(n,e)e(e(n and e,e),e(e,e))end)(function(l,e)if o>X then return l end o=o+x n=(n-Q)%U if(n%z)>=P then return e(l(l,l),e(l and e,e and e)and l(e and l,e))else return l end return e end,function(l,e)if o>J then return l end o=o+x n=(n*L)%V if(n%v)<=R then n=(n+_)%G return e(e(e and e,e),e(l and e,e and e))else return l end return e end)return n;end)()));local o=(#W+S);local a,b=({}),({});for e=c,o-x do local n=Y(e);a[e]=n;b[e]=n;b[n]=e;end;local u,d=(function(l)local d,e,c=h(l,x,q);if((d+e+c)~=(248))then n=n+(153);o=o+((225-#("i am not wally stop asking me for wally hub support please fuck off")));end;l=r(l,((#{550;630;213;478;}+1)));local n,d,c=(""),(""),({});local e=x;local function t()local n=g(r(l,e,e),((51-#("concat was here"))));e=e+x;local l=g(r(l,e,e+n-x),(36));e=e+n;return(l);end;n=b[t()];c[x]=n;while(e<#l)do local e=t();if a[e]then d=a[e];else d=n..r(n,x,x);end;a[o]=n..r(d,x,x);c[#c+x],n,o=d,d,o+x;end;return(f(c));end)("PSU|25F1210276277122752771414276111127713131027F27K111N1N27m27m1l1l27q27627927727717171a1a2761513162762361n18121p1J24N25j1527623B151R1t1h24y25S1727622T1T1T161m1128m25X27A23b1L25r24v27a22X1625425D1m27622r22h1l23J21h1N1K2161z181K22K22f1P1C1t101J22522328s23t26h28g1022r1F131S1m24y25v27d102331v1L1B21m22c27X1022X21523M25C27A2331s22X1Q27E27g27627i1024k24S182761i1h27j1027W27U2B22752Az131a13192761x1x1027I1k1n131I1M141O1t29y27l27I1B1b102B71A1e2A71X212172Bg2Bi2bK2bm2bO2Ay1n151O1r2b12bq131114151X1w2cf141Q1p2cE27G16161Z1Y27F27g27c1d1B161X2131627C2cm2Co1027C2BS2bu2bL2B92BB101x1z1227c1k1G141i2C82BN2Bp2cV142D82C42dB2bc2be2DH2Dj2Dl2C92C627q2d72BT27l27V2751321i21H25T25t2761Q1L1F27622a21j1L1S151A121L1H111y21B1r11171Q22u2ax102381r1s17161R171927324827726k26A1e287171R21d2181m28U171n21M21F1P1K2262102bt29Z1H1j1I1r1R1m1n141j1n26724q28p1022A21F16131B27j21421U2861022v121H161n1224W2642FT22E21r1R16111K1D21l2122g021I2242eY2242111e1f1s1t2F61922z29Y2341J121d1023k26D2dc22C1z1I101b213213181926K23o2g722821o1D1o1S1N1123a122g72GJ2fV121B1o26M24f2I8181b192iB1123J1v29y22C2121J181525d24p2a722621b1c1824n2611r27621w1x13171k1p1O21j217191l2132161A171H1821A2Jd1l21D21F1J1b1Q1722X1g2821022U1f1r1N1M1q1E191f1D22x1K1h2762251y1q28u21321J27g2ET22n23621b2eL1821B21S2A722f21e19181a2HD27622d1h2191422N26o25h2g72881k141S2K126e23U2dc23b2bn2ja131H12162712452Hi102391R1u121t1r2Gl1n21721K1i1S24R25U1G27622021P1O1c1f11161D21i21P101r21021D1j162382af1026O25R21M2i727621Z21h2G31v1T1d1N22X2g721V2JN102eP2232172A723816171G2712if27621v2181t1n1y21e1S25G24j2fD2g821J28a2lw1z21F1r2n028T1121t2152gH2282mK1n2JS2351a2eF2GI2Gk161j2k3181h27s1L132k529W29y2372lJ1m1p24s25G2gH2j52ND1R1q22X2Ha2762i92Gm2Ic26t23x2Nr21U21c1r181F21P2H0181O21121f2Mz24I25t2GH22r1H2Ii141R23N26E2Jx21y2eS1n21I21I2G12G326I2Ng102l8141G1m1721C21Z2B121y191p23d2N928H1M1j1S22z2ka2762371m1H1s112Hi111b2Lt1T2AA1N2md25725v2Kb1022b21e1o21g2142991i161221J21j2l92q81726V2422R52352q71G1G21m21c1121d2171H192jE2My161Q22V2LF1I2JJ1s2IZ1e1H26124L2ey21u2dF182lW122Kp21V2g722E2ga1n28k21t26p25m2ey22r2II1l2C11H1c23L26v2J31022w1s2d622227t1U2Ih2I3101n2EK1P2T5111s22p21B1L2O022z2mt102sm2GM28K21s26D2662DC22B21c1H27P1b2152nn24r25r2LP22821r2NC2jT1W2q0141V1A1623j2JW2762312IB1D1F1v1U2FX1T2162282dC22S2MC1C2LU1P15191x2252dc2hz2i12I321H2nn23P2681C2MU2122IZ2pZ2kB2HA191k24f26n2b12G91O22e2142g722i21H121f1b1C1M22K2112JX2SU1d1628A2MB161O2692q422321a1s21m2181b1128e29y2PO2Pq2612iV27622B21I141l26k24C2A72311C2EJ25h24k2DC2AO21821O2791B1D1124M25P2ob28i28k1h21m21o1F151p1i1d1E2Of26f23K2B12321B1I2311s2GH2n21T2g01624j25g1j2Fe2FG2FI2fk2FM21L1j2NY1N2o023M26f2FT21z1Y1H2JC1115182G01B21t2vR27621X2172A12k51123s26g2A722q2Hi1321v2o32VD2iz21821921P22G2AR2Oa1d2SD2191b1T21Q21q2ZI2172H32762Pw2V02142RB1r25H24r2gH21v1Y2Iz1n1j24J25N2dC22E14112uc2Ue2uG2N02ZP1Z27F31011D21n21I1i21n21927o21021H102F41b2I41H2v22dc22P1K112F12F52Mh22321r27x21S26726723M2l62762x321P2jj1L26x2412dc22A21n2H71s21F21H1r1P22N2fS2762241Z2Ux1d21o2i02i21n26i2432ft22621N1O1f2fL1W21f1f2ij28n2N32JD312c121121P22l2a72O52Ej23o2712R52jZ2k1162Xi1a2Pc28w2lX28K2q32G722B2132oI101l111A22T2FT2212131U1511310L2PC2Gm22J2162iO21d141c1u26o2452992fU2g12EO2wF2FJ2q92y92yb2NZ2Gv25f24o29y22t27p28s2672Wo1023b1M181t2482VB2762hN2hp1B21p31092uF1b2ky1021y21G1j2iz2LD2Dc21T1Y310q2992h91B1W22M2G722C21d1t1c21I310m22q2in2wp21n1D2bb25d2nq29A2II312H1g152gm1D1P2q824F2pu2MU2NN21m314o1626e2xQ2QP2GM21N22F2NR2I91n1C27g2Cy2YD2gv1T24k2632vC10313C1o1p141e2Pz2q11N24W28F27622E21J315S1g23J1j2DC2202131v31361N21C2171726U2lo2762222112u9172uB2g1310a21o22c2Lp21u31791a2842k5312A2jR1q2351029y22B21N310Z162351n2HP2R621k1a2EO172xM2OF21g2i01l1I192QZ26M23R2a722V162iz2Uh2jx311u1821g316024y2gq2762342lU2Lw2GM2LZ2M125A2A62KZ2L11425628Y27622N1O2402pM29a2tz2Ws1h31702Dc21u2zh1t21R21528l161B313A2Eg2Nt122lW317t2o8318427622829f1K318H1v21121o2d61y2RH2Q72q92522ss2762se2Bk21h2mk1621922a2ft3158315A213316031622b12N21Q26V2HX2QP2G02uD2uF21o22k29Y2I91J1424H25l2FT311U311W21r2Ty311P1426k317c102262rW132lH2122181J1p1e1n22L2hT31B02vh2f61k1T314R2o51F2jT1T22o2NR312531272Fl1x21i2ri2x7316123p2gH2202151F312w1925K314B2yU1R2r92202r52i92QT2QV2QX2lu2R02MD25W314527622u318a1V1M21o3167319V1B1a27N31CD31Bz2Vj2162222y4102qq1H2172171S1Q2g115310i2X82Js28s1d257316u10317E1d2172ZA3156314j21D27P2iR1724s311a1022P31c51T1818141331C82Mu2yj21C1x1m1G319S317q31C5171T22Y2Na315I1L222313L314J2HO2Hq22z1C2dc2N4191j2hG1N2tz24L319f31DM2f32F51926c23V2Ey2I92N6313o1u2vl2B122t1m13239182Lp22R2X61D21M310M2ej1D2lL25k24m2fT2p92G11a1x317F2eV1724x25O2NR2Pw2802er2ET172YL2yN24m31e12UV2fl1I23h1I2EY2Yi2em2oH319s1w2212m51022D2h01n21N313D313f31aS317j2Uf22o2zF27623928U2K21527s21K22n2gh23231cS31282pY2Gg2871j31CM1B122152262jX22a2131r314N31hH319S314R2382OK2k531Hj2eY31Hm2y031f122O2gB2MU2gK22931hk1031582rY1l2S022J311s31DM313Y2FL2XG2hh10257318w31iZ2LX2CG2wh2en22E311V27622W28P141d3141316E1123m26C2ey313C1Q31AB316y314x276314Z2yd1v1n2Eo111w2zo2JY31jj2o021T31bx316k2132HA2eE2W4314Q29Y22U2B9101T2ti2ob31iT2RZ28t31hg31B231CH2ZX15314u318O315F102Kd2kF1m1B23i31h82Zq1o2Tz31fL1y2yv2ol1931K031k231691h31kI1023a2qk2p22Gk31Dp31Dr31dT31DV2qW1Q31dY26Y2RM319v2EJ2EL2eN2ep21j31i81T2ml1226e31AZ2ag1718172vc1221i31B5318X319X2eV26k24d29y2j52rE2k828531b0161H2ff21j2zc27621323u24G2Lp2Wx2bW21m21428j1t31If1924Y25u317Y21N28p1R21931HS31a2311z2I326731Mx27622z2fH2BO2122Fm21J23628s1722r2qC27622121M21e22J1u2A731fb1L2612zw29A316B31g81l2351e2FT31332F42F621D316x315t317L2Lp21v21i28P2O71Q21J2zZ18310122s1l31h831G22UL315Z171o1N1d1531P42eo24y316I2qp2DL314v31eX1731kb1624N25q316j22B21o1q1R1A21J316021o2292eY2m72M92W71d25l24h316J2w32W52vV318a151v1J1x2Kr2762381T312W26g23s31bc21L1K21E21I31DH1k23A2cf31d52K01N22o31mN31Ef31EK2k731nC31Ne102nI27I1t21t1S2182B122v2ih24m25d2B12341S1u26i311h27622f21i1d1721K1z27T112n82a722c21N2bF2Gf31cJ2l22V626o2422Jx2I91q1B2G22k21726131pZ2KC1y1b1H1p1921i31bG316n2351t1O2wP21m2bm1p1d2tl2gv21O21f31p52XW21r311V2Hh192z923S2vm2Qp1A1N24S31E121t21E102qr25225K2jx2YI1h31kO310A24126s2AQ27H27J27w1529Y2bu1j111o22022831Tm279192102192b71o1831h82c41O24p24x2c72c92212292ay1K2w823R24F2Ay2SW1O23t2412Ay1Q2Pg25024S2ay1r191o21R2132AY1O1A1o22w2342AY1P2iC2CB2aY1U1C1O24K2582aY1v2I121g2182AY1s1E1o22G21s2ay1T1f1O24e23Q2Ay121g1O22H21t2Ay2Lj1o22k21w2Ay2Bu1o21p2112Ay111J1o21h2192Ay161k312727p2bU31Pe1o21V22j2AY141M2PH2mG2BU151N1O25y25q2aY31V231UX31uZ2bu1B2jA21F2172Ay181Q1o21q2122Ay1931CS23J22v2aY1E1s1O26125D2aY1f31sk2rx2AY313P1O21L2bE2BU1D1V1O25324V2aY21E1w1O21d2152Ay21f1X1O23a2322ay21C1Y1o25k25s2ay21d1Z1O22r23f2Ay21i2101O1U2GH1I21J2111o21n1z2ay21g2121O1K316J1I21H2131O23w2442aY31n11o31sq2AY21n2151o25W25O2AY21K2161o22s23G2AY21L2171o22L21X2Ay21q2181O24223U2AY21R2191o25824K2Ay21O21A1o22u23I2aY21P21b1o1w21k2aY1Y21C1O24d23P2aY1z21d1O24623Y2Ay1w2R823h22T2AY1x21f1O22Q23E2Ay21221G1o24V25327E27K2791J21321g31u31731752d92bm1N2ob2dY1O23m24a31uF2W821S22G31Uk31p121X22L31UP2PG22522d31uu31uW23V24331v031V224023S31V62Ic1G2ey1I31vB1o22m21y31vg2I123i22U31vL31Vn192r51i31Vs1O1E313t1i31VY1o2la31W31h1O24C23o31w81i316m2aR1I31WE1o23n24B31WJ31Wl213311431Wo1l1o23l24931WT31wv25a24M2AY31Wz1o24N25b31X41o1o24523x2Ay31X92vp22631xD31Xf22322B31Xj31cs26725j31Xo31xq2Jr31XU31SK24t25131xy1u1o25s25K2ay31y41o24a23M31y931Yb21031A92bU31YG1o22y23631yl31Yn23u24231yR31Yt25u25m31YX31YZ132t231Z331Z523123931z931Zb161u2Ay31Zg1o21k1W31ZL2141O24R24Z31zP31ZR25424G31Zv31ZX21821g3201320323622y3207320922d225320d320F2E01I320K1O25x25p320P320r24B23N320V320x21e2163211321331X232172R81y21M321c321E228220321I321K24F23r27E1327912321r321t2B01o25T25l2ay2bl1O23C22o31Ub1o22222A32251o1B31dl1I31uL1031sl2Bu31Uq1o23g22S322h1o1529q31W931v223722z322P1o26325F31vA31vc2302mN2Bu31Vh1o24g25432321o21b21j31VR31VT22t23H31VX31vz23X245323f1o22O23c323k1o23b23331wD31Wf21W22K323t1O26225e2ay31WP23y24632421O22722F324631X01M2NR1i31x522c224324g2JA24J257324k1O21C214324O1o22622E324s1O21t22H324v1O21z22n324Z1O23D22p325431y521721f32591O25524h31YF31yH21m31502bU31YM1o25124t325m324C2771I31yy1O21A21I2ay31z41O24l259325Y1o21y22m326231Zh24M25a32671o21U22I326c1o24423W326g1o23323B326K1O21221q326o1O24o24W326s1o25924l320J320l22I21U32701o1X21L32741O32A832781O26525h327b1o24W24O327f2JB21B327J1O21631Ta321p327O327q321S31U322x317W321x2m91K32822242ae2bu31ug1O24823K32291O24923l322D1O122aP2bu31UV1o23522X322l1O238230328r22v23J328V1o24x24P322y1o25624i329424I25632981O23422w329c1o1V2G71i31w41A31852hP323l25724J329o1O22b223329s25B24N329w323y23Q24e32a023z24732A4321432162BU31X522P23d32Ac1O23k2f92Bu31xE1o22N21Z32Ak22A22232aO21I21a32as23923132AW24y24q32b01O24S25032B423E22q32b81O25Z25R325I1O1z31Rt2bU31ys1O22z237325Q1O26625I32bp31z521o21032Bu26025C32by1O24723Z32C225v25n32C624z24r32CA22f22732cE21421C32Ci23F22R32cM219310P2bU326W25224u32cu1l2Lp1i320W1o26425g32d123S24032D51S2a71I321D1o24123t32dc23O24C27e1514321Q32dj327t24323v27e2cG321Q1G2D527i1f2EF31U7111p31tM31tq2cS111i32du32J327623n318K1u26W26E27625z25Z322d1a241323s2Dd22q21v31Ej1K1s1827L2rY1Z1W2bj31V11O24u252322p1A2WH328v1A21H323W1x2542491C1c31wL1C1I329032Jb27Q1E32391K312i27G32KF111f1E2qu32kf1C1g323B27l2bS31ej2Bu322U24Q24y27e1D1c2812A331dE27G31Ej31RK1A32jd141Y26t32JK1026F26F327X1432jM32jo1X2482552dw310727g32j632jz32j92W822922131tm2cW2cY2DS23g23a328221521d27v141632In323N31uL23P24D32e21Q27A32Jw2K62ef27l2cW1431la2ar2b5276"),(#W-((#{712;581;(function(...)return 166,408,...;end)(575,672,128)}+83)));local function x(e,n,...)if(e==810584326)then return((l(l((n)-352491,515887),759749))-489049);elseif(e==800641876)then return(l(((l(n,668194))-598550)-17302,536084));elseif(e==944044013)then return(l(l(((n)-844570)-90236,822884),775087));elseif(e==295530947)then return((l((l((n)-193062,409342))-519143,132647))-41147);elseif(e==258681377)then return((l(l(l(n,281246),749809),278912))-869590);elseif(e==409241898)then return(l(l(l(l(n,725050),854167),73674),885223));elseif(e==203256537)then return((l(l(n,637870),933217))-867650);elseif(e==23994419)then return((l((n)-126071,342507))-640922);elseif(e==239704765)then return((l((n)-876662,904025))-92736);elseif(e==514266734)then return(l(l(((l(n,159170))-419372)-728672,577544),123712));else end;end;local s=e[(630475014)];local m=e[((946840433-#("still waiting for luci to fix the API :|")))];local w=e[(826966026)];local F=e[((#{(function(...)return;end)()}+752980701))];local D=e[(791244531)];local C=e[((521429630-#("https://www.youtube.com/watch?v=Lrj2Hq7xqQ8")))];local x=e.uPqEDA;local o=e[((#{549;763;}+466726701))];local f=e[(73390856)];local function c()local e=l(h(u,d,d),n);n=e%x;d=(d+o);return(e);end;local function t()local e,o=h(u,d,d+s);e=l(e,n);n=e%x;o=l(o,n);n=o%x;d=d+s;return((o*x)+e);end;local function a()local e,o,c,a=h(u,d,d+C);e=l(e,n);n=e%x;o=l(o,n);n=o%x;c=l(c,n);n=c%x;a=l(a,n);n=a%x;d=d+f;return((a*F)+(c*w)+(o*x)+e);end;local function f(l,e,n)if(n)then local e=(l/s^(e-o))%s^((n-o)-(e-o)+o);return(e-(e%o));else local e=s^(e-o);return(((l%(e+e)>=e)and(o))or(D));end;end;local C=""..e[m];local function x(...)return({...}),M(C,...);end;local function X(...)local X=e[((#{819;}+609405766))];local m=e[((572167813-#("Perth Was here impossible ikr")))];local p=e[(238930950)];local W=e[(617635313)];local V=e[((#{}+854376268))];local w=e[((630475119-#("PSU|161027525v21222B11273172751L275102731327523d27f22I27f21o26o24Y21J1827F1X27f1r27F23823a26w1... oh wait")))];local _=e[((596530545-#("i am not wally stop asking me for wally hub support please fuck off")))];local D=e['aLMu3XbeF'];local U=e['gk8BMuYC5W'];local g=e[(73390856)];local F=e[((#{986;20;216;}+898350524))];local o=e[((#{294;715;110;96;}+791244527))];local H=e[((376340251-#("guys someone play Among Us with memcorrupt he is so lonely :(")))];local M=e['O0X5TUt'];local j=e[(801379773)];local I=e["kFBLrzcI"];local A=e[((521429692-#("PSU|161027525v21222B11273172751L275102731327523d27f22I27f21o26o24Y21J1827F1X27f1r27F23823a26w1... oh wait")))];local P=e[((#{696;948;668;297;}+931674294))];local L=e[(578527547)];local i=e[(532446733)];local v=e[(40024488)];local E=e[(517825164)];local x=e[(466726703)];local C=e['uPqEDA'];local function k(...)local e=({});local s=({});local y=({});for e=o,a(n)-x,x do y[e]=k();end;local k=t(n);for t=o,a(n)-x,x do local s=c(n);if(s%i==D)then local n=c(n);e[t]=(n~=o);elseif(s%i==F)then while(true)do local a=a(n);if(a==o)then e[t]=('');break;end;if(a>X)then local o,c=(''),(r(u,d,d+a-x));d=d+a;for e=x,#c,x do local e=l(h(r(c,e,e)),n);n=e%C;o=o..b[e];end;e[t]=o;else local x,o=(''),({h(u,d,d+a-x)});d=d+a;for o,e in T(o)do local e=l(e,n);n=e%C;x=x..b[e];end;e[t]=x;end;break;end;elseif(s%i==o)then while(true)do local d=a(n);local l=a(n);local a=x;local d=(f(l,x,v)*(w^m))+d;local n=f(l,i,M);local l=((-x)^f(l,m));if(n==o)then if(d==o)then e[t]=B(l*o);break;else n=x;a=o;end;elseif(n==H)then e[t]=(d==o)and(l*(x/o))or(l*(o/o));break;end;local n=N(l,n-U)*(a+(d/(w^_)));e[t]=n%x==o and B(n)or n break;end;elseif(s%i==V)then while(true)do local n=a(n);e[t]=r(u,d,d+n-x);d=d+n;break;end;else e[t]=nil end;end;local l=a(n);for e=o,l-x,x do s[e]=({});end;for C=o,l-x,x do local l=c(n);if(l~=o)then l=l-x;local b,r,m,u,i,d=o,o,o,o,o,o;local h=f(l,x,A);if(h==w)then i=(t(n));u=(c(n));d=s[(a(n))];elseif(h==A)then r=(t(n));i=(t(n));u=(c(n));d=s[(a(n))];elseif(h==p)then elseif(h==o)then r=(t(n));i=(t(n));u=(c(n));d=(t(n));elseif(h==x)then i=(t(n));u=(c(n));d=(a(n));elseif(h==F)then r=(t(n));i=(t(n));u=(c(n));d=(a(n));b=({});for e=x,r,x do b[e]=({[o]=c(n),[x]=t(n)});end;end;if(f(l,E,E)==x)then m=s[a(n)];else m=s[C+x];end;if(f(l,F,F)==x)then d=e[d];end;if(f(l,g,g)==x)then i=e[i];end;if(f(l,p,p)==x)then r=e[r];end;if(f(l,D,D)==x)then b=({});for e=x,c(),x do b[e]=a();end;end;local e=s[C];e[j]=u;e[W]=d;e[-P]=r;e['GXk7']=m;e["VEMilI"]=i;e[-I]=b;end;end;local n=c(n);return({["yhjN"]=y;[L]=n;[-839803.2858523071]=e;["SSl"]=s;['g4TF']=o;["xzHzEzF"]=k;});end;return(k(...));end;local function u(e,n,f,...)local d=e[199080];local l=0;local n=e["SSl"];local t=e["xzHzEzF"];local x=e[-839803.2858523071];local F=e["yhjN"];return(function(...)local o='GXk7';local a=-840402;local c=n[l];local r=-(1);local e=({});local s={...};local e=(575323450);local m=441715;local e=(true);local n={};local e=-637755;local h={};local x=423072;local b=(M(C,...)-1);local l='VEMilI';local e=1;for e=0,b,e do if(e>=d)then h[e-d]=s[e+1];else n[e]=s[e+1];end;end;local s=b-d+1;repeat local e=c;local d=e[m];c=e[o];if(d<=17)then if(d<=8)then if(d<=3)then if(d<=1)then if(d==0)then n[e[l]]=e[x];e=e[o];local d=e[l];n[d](n[1+d]);for e=d,t do n[e]=nil;end;e=e[o];n[e[l]]=f[e[x]];e=e[o];n[e[l]]=n[e[x]][e[a]];e=e[o];local h;local u;local s;local r=0;local function d(n,e,l)e=(r+e)%3 r=((e~=0)and r+((e<2)and n or-n)or r*n)%l return r end for o=2,33 do if d(6618,6687+o,2218)>=1109 then if d(3773,6605+o,2354)<1177 then if d(1425,5148+o,2058)<=1029 then n[e[l]]=#n[e[x]];else local o=e[x];local x=n[o];for e=o+1,e[a]do x=x..n[e];end;n[e[l]]=x;end else if(n[e[l]]==e[a])then c=c+1;else c=e[x];end;if d(1452,2470+o,3552)>1776 then n[e[l]]=n[e[x]];else if(e[l]~=e[a])then c=c+1;else c=e[x];end;end end else h=l;if d(8543,3772+o,2556)<=1278 then if d(9922,3928+o,2850)<1425 then n[e[l]]=f[e[x]];else u=e[x];end s=e[h];else n[s]=u;if d(7001,3972+o,972)>=486 then else end end end end n[e[l]]=e[x];e=e[o];local d=e[l];n[d]=n[d](i(n,d+1,e[x]));for e=d+1,t do n[e]=nil;end;e=e[o];local c=e[l];local d=n[e[x]];n[c+1]=d;n[c]=d[e[a]];e=e[o];n[e[l]]=n[e[x]];e=e[o];local d=e[l];n[d](i(n,d+1,e[x]));for e=d+1,t do n[e]=nil;end;e=e[o];local c=e[l];local d=n[e[x]];n[c+1]=d;n[c]=d[e[a]];e=e[o];local d=e[l];n[d](n[1+d]);for e=d,t do n[e]=nil;end;e=e[o];n[e[l]]=f[e[x]];e=e[o];n[e[l]]=n[e[x]][e[a]];e=e[o];n[e[l]]=e[x];e=e[o];local d=e[l];n[d](n[1+d]);for e=d,t do n[e]=nil;end;e=e[o];n[e[l]]=f[e[x]];e=e[o];n[e[l]]=n[e[x]][e[a]];e=e[o];n[e[l]]=e[x];e=e[o];local l=e[l];n[l](n[1+l]);for e=l,t do n[e]=nil;end;e=e[o];e=e[o];elseif(d<=1)then local l=e[l];n[l]=n[l](i(n,l+1,e[x]));for e=l+1,t do n[e]=nil;end;end;elseif(d>2)then elseif(d<3)then do return;end;end;elseif(d<=5)then if(d>4)then n[e[l]]=u(F[e[x]],(nil),f);elseif(d<5)then n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];local d=(_86);(function()n[e[l]]=e[x];e=e[o];end){};local d=(_75);(function()n[e[l]]=e[x];e=e[o];end){};n[e[l]]=e[x];e=e[o];local t;local c;local i;local a=0;local function d(n,e,l)e=(a+e)%3 a=((e~=0)and a+((1==e)and-n or n)or a*n)%l return a end for o=0,34 do if d(3878,5947+o,2036)<1018 then if d(9540,1240+o,390)<=195 then if d(8132,6212+o,832)<416 then i=e[t];else n[i]=c;end else if d(1430,1545+o,3810)<=1905 then c=e[x];else t=l;end end else if d(9338,9741+o,3670)>1835 then if d(1432,5539+o,2672)<1336 then else end else if d(3874,4989+o,2682)>1341 then else end end end end local d=(_194);(function()n[e[l]]=e[x];e=e[o];end){};n[e[l]]=e[x];e=e[o];local c;local t;local i;local a=0;local function d(n,e,l)e=(a+e)%3 a=((e~=0)and a+((e<2)and n or-n)or a*n)%l return a end for o=1,34 do if d(2360,5663+o,3830)<1915 then if d(3102,7896+o,3932)>=1966 then if d(1192,1154+o,2910)>=1455 then c=l;else i=e[c];end else if d(1860,9159+o,3516)>1758 then t=e[x];else end end else if d(2633,4845+o,872)>436 then if d(1493,7580+o,632)<=316 then else n[i]=t;end else if d(8966,5346+o,714)>357 then else end end end end local i;local t;local c;local a=0;local function d(n,e,l)e=(a+e)%3 a=((e~=0)and a+((e<2)and n or-n)or a*n)%l return a end for o=1,26 do if d(5302,5336+o,3696)<1848 then if d(7650,5701+o,3180)>=1590 then if d(2847,6455+o,462)<=231 then else i=l;end else if d(2131,9877+o,2780)<1390 then n[c]=t;else n[e[l]]=f[e[x]];end end else if d(2348,9140+o,3644)<1822 then if d(9410,1482+o,2644)<=1322 then else end else t=e[x];if d(6652,7337+o,2682)<=1341 then else c=e[i];end end end end n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];local c;local t;local f;local a=0;local function d(e,n,l)e=(a+e)%3 a=((e~=0)and a+((1==e)and-n or n)or a*n)%l return a end for o=2,29 do if d(3803,4897+o,2522)<1261 then if d(7258,3652+o,1868)>934 then if d(3784,7060+o,1442)>=721 then else end else if d(9462,8247+o,3776)>1888 then else t=e[x];end end else if d(2685,6283+o,1608)>804 then if d(5438,5515+o,3074)>=1537 then c=l;else end else f=e[c];if d(3496,1677+o,1036)>518 then else n[f]=t;end end end end n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];local d=(_127);(function()n[e[l]]=e[x];e=e[o];end){};n[e[l]]=e[x];e=e[o];local d=(_41);(function()n[e[l]]=e[x];e=e[o];end){};e=e[o];end;elseif(d<=6)then n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];local t;local f;local i;local c=0;local function d(n,e,l)e=(c+e)%3 c=((e~=0)and c+((1==e)and n or-n)or c*n)%l return c end for o=0,30 do if d(7985,4772+o,2126)>=1063 then if d(5217,9716+o,1494)<747 then if d(1225,1469+o,2104)>=1052 then else n[e[l]]=e[x]-e[a];end else if d(2749,3877+o,3068)>1534 then else end end else t=l;if d(5968,6211+o,2160)<=1080 then f=e[x];if d(9936,9012+o,3044)<=1522 then i=e[t];else end else if d(3676,6702+o,3244)>1622 then else n[i]=f;end end end end n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];local t;local c;local f;local a=0;local function d(n,e,l)e=(a+e)%3 a=((e~=0)and a+((e<2)and n or-n)or a*n)%l return a end for o=0,32 do if d(6763,4797+o,1384)<692 then if d(1698,1515+o,3298)<=1649 then if d(3228,2863+o,3184)>=1592 then else t=l;end else if d(8102,3723+o,2224)<1112 then f=e[t];else end n[f]=c;end c=e[x];else if d(4762,6364+o,3392)>1696 then if d(3228,5259+o,2268)>=1134 then else end else if d(8500,7696+o,1640)>=820 then else end end end end n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];e=e[o];elseif(d>7)then local e=e[l];n[e]=n[e](n[e+1]);for e=e+1,t do n[e]=nil;end;elseif(d<8)then n[e[l]]=e[x];e=e[o];local d=(_147);(function()n[e[l]]=p(256);e=e[o];end){};local l=e[l];n[l](i(n,l+1,e[x]));for e=l+1,t do n[e]=nil;end;e=e[o];e=e[o];end;elseif(d<=12)then if(d<=10)then if(d>9)then n[e[l]]=f[e[x]];elseif(d<10)then n[e[l]]=p(e[x]);end;elseif(d>11)then n[e[l]]=p(e[x]);e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];local s;local r;local i;local t=0;local function d(n,e,l)e=(t+e)%3 t=((e~=0)and t+((e<2)and-n or n)or t*n)%l return t end for o=0,27 do if d(4862,9248+o,418)<=209 then if d(7857,4162+o,3280)>1640 then if d(8039,1022+o,3468)<=1734 then n[e[l]]=n[e[x]]+e[a];else end else if d(2795,4269+o,2844)<1422 then n[i]=r;else end end else if d(1625,8746+o,1924)<=962 then s=l;if d(1314,8610+o,2140)<1070 then n[e[l]]=f[e[x]];else r=e[x];end else if d(2889,3454+o,1956)>978 then c=e[x];else end end i=e[s];end end n[e[l]]=e[x];e=e[o];local r;local f;local i;local t=0;local function d(n,e,l)e=(t+e)%3 t=((e~=0)and t+((1==e)and-n or n)or t*n)%l return t end for o=1,30 do if d(4742,4341+o,2808)>1404 then if d(6060,9453+o,656)<=328 then if d(4368,3044+o,1806)>903 then else end else if d(4786,2673+o,2662)>=1331 then n[e[l]]=e[x]-e[a];else i=e[r];end end n[i]=f;else r=l;if d(6227,9167+o,3552)<1776 then if d(5664,4756+o,3632)<1816 then else f=e[x];end else if d(1362,8835+o,546)>273 then else end end end end n[e[l]]=e[x];e=e[o];local d=(_76);(function()n[e[l]]=e[x];e=e[o];end){};n[e[l]]=e[x];e=e[o];local i;local t;local f;local a=0;local function d(n,e,l)e=(a+e)%3 a=((e~=0)and a+((e<2)and-n or n)or a*n)%l return a end for o=1,33 do if d(4768,5516+o,3420)<1710 then i=l;if d(9085,7683+o,3014)>=1507 then if d(6875,8809+o,616)>308 then c=e[x];else t=e[x];end else if d(7860,6137+o,2210)>1105 then else end end else if d(5636,3958+o,1268)<634 then if d(6849,4690+o,1906)<953 then else f=e[i];end else if d(7777,1447+o,2438)>1219 then else n[f]=t;end end end end n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];local c;local f;local t;local a=0;local function d(e,n,l)e=(a+e)%3 a=((e~=0)and a+((e<2)and-n or n)or a*n)%l return a end for o=0,28 do if d(7903,1530+o,2484)>1242 then n[t]=f;if d(6873,9038+o,1892)<946 then if d(8011,9343+o,2996)<1498 then else end else if d(8602,8688+o,1834)<917 then else end end else if d(6033,4624+o,1082)>541 then c=l;if d(3796,2484+o,1254)>627 then f=e[x];else end else if d(7723,7694+o,2214)<1107 then n[e[l]]=n[e[x]];else end end t=e[c];end end local d=(_162);(function()n[e[l]]=e[x];e=e[o];end){};local f;local t;local c;local a=0;local function d(n,e,l)e=(a+e)%3 a=((e~=0)and a+((1==e)and-n or n)or a*n)%l return a end for o=2,34 do if d(7239,3805+o,980)>=490 then if d(8187,6066+o,1592)>796 then if d(5561,7782+o,2970)>=1485 then else end else if d(4355,8114+o,288)<144 then n[c]=t;else end end else if d(4054,3302+o,1436)>=718 then if d(4614,7880+o,1486)<743 then else end else f=l;if d(9759,9976+o,1030)>515 then t=e[x];else c=e[f];end end end end n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];local d=(_87);(function()n[e[l]]=e[x];e=e[o];end){};n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];e=e[o];elseif(d<12)then local e=e[l];n[e](n[1+e]);for e=e,t do n[e]=nil;end;end;elseif(d<=14)then if(d>13)then e=e[o];local x=e[l];r=x+s-1;for e=0,s do n[x+e]=h[e];end;for e=r+1,t do n[e]=nil;end;e=e[o];local l=e[l];do return i(n,l,r);end;e=e[o];e=e[o];elseif(d<14)then local l=e[l];n[l](i(n,l+1,e[x]));for e=l+1,t do n[e]=nil;end;end;elseif(d<=15)then n[e[l]]=p(256);elseif(d==16)then n[e[l]]=n[e[x]][n[e[a]]];elseif(d<=17)then n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];local t;local f;local c;local a=0;local function d(n,e,l)e=(a+e)%3 a=((e~=0)and a+((e<2)and n or-n)or a*n)%l return a end for o=1,33 do if d(8913,2613+o,3110)<1555 then c=e[t];if d(9091,7092+o,2390)<=1195 then if d(4958,3461+o,1096)<=548 then n[c]=f;else end else if d(3407,5728+o,3642)>1821 then else end end else if d(8638,6542+o,1704)<852 then if d(5644,7634+o,3576)>=1788 then else end else if d(5724,6313+o,348)>174 then else t=l;end f=e[x];end end end n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];local c;local t;local f;local a=0;local function d(e,n,l)e=(a+e)%3 a=((e~=0)and a+((e<2)and-n or n)or a*n)%l return a end for o=2,34 do if d(3555,9024+o,2934)>1467 then if d(1426,9167+o,1422)>=711 then if d(2248,7054+o,1970)<=985 then else end else if d(7647,2434+o,3320)<1660 then else end end else c=l;if d(6350,4741+o,2780)>=1390 then t=e[x];if d(5827,9795+o,3736)<=1868 then f=e[c];else end else if d(5252,1290+o,760)<=380 then else n[f]=t;end end end end n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];local t;local c;local f;local a=0;local function d(e,n,l)e=(a+e)%3 a=((e~=0)and a+((1==e)and n or-n)or a*n)%l return a end for o=0,26 do if d(2843,1724+o,1684)<842 then n[f]=c;if d(5998,9103+o,1448)>=724 then if d(6016,4203+o,3592)<=1796 then else n[e[l]]=#n[e[x]];end else if d(5784,8566+o,786)<=393 then else end end else t=l;if d(8254,4188+o,1864)<932 then if d(4404,9604+o,3518)<=1759 then c=e[x];else end f=e[t];else if d(1896,1617+o,454)<=227 then else end end end end n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];e=e[o];end;elseif(d<=26)then if(d<=21)then if(d<=19)then if(d==18)then if(n[e[l]]==e[a])then c=e[x];end;elseif(d<=19)then local l=e[l];local x=e[x];local d=50*(e[a]-1);local o=n[l];local e=0;for x=l+1,x do o[d+e+1]=n[l+(x-l)];e=e+1;end;end;elseif(d==20)then n[e[l]]=n[e[x]][e[a]];elseif(d<=21)then local e=e[l];do return i(n,e,r);end;end;elseif(d<=23)then if(d>22)then local l=e[l];r=l+s-1;for e=0,s do n[l+e]=h[e];end;for e=r+1,t do n[e]=nil;end;elseif(d<23)then n[e[l]]=#n[e[x]];end;elseif(d<=24)then n[e[l]]=e[x];elseif(d==25)then n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];local f;local t;local c;local a=0;local function d(e,n,l)e=(a+e)%3 a=((e~=0)and a+((e<2)and-n or n)or a*n)%l return a end for o=0,25 do if d(8454,9040+o,3506)>=1753 then if d(7971,8435+o,3714)>1857 then if d(4302,3196+o,1560)<780 then else end else if d(6881,1698+o,2058)<=1029 then else end end else f=l;if d(9196,8651+o,2842)>1421 then if d(4371,5200+o,2804)<1402 then else t=e[x];end else if d(2484,9198+o,858)>429 then n[c]=t;else c=e[f];end end end end n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];e=e[o];elseif(d<=26)then local l=e[l];local x=n[e[x]];n[l+1]=x;n[l]=x[e[a]];end;elseif(d<=30)then if(d<=28)then if(d==27)then n[e[l]]=n[e[x]];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=f[e[x]];e=e[o];n[e[l]]=f[e[x]];e=e[o];n[e[l]]=n[e[x]][e[a]];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=#n[e[x]];e=e[o];local d=e[l];n[d]=n[d](i(n,d+1,e[x]));for e=d+1,t do n[e]=nil;end;e=e[o];n[e[l]]=n[e[x]][n[e[a]]];e=e[o];local d=e[l];n[d]=n[d](n[d+1]);for e=d+1,t do n[e]=nil;end;e=e[o];n[e[l]]=e[x];e=e[o];local c=e[x];local d=n[c];for e=c+1,e[a]do d=d..n[e];end;n[e[l]]=d;e=e[o];local l=e[l];n[l](i(n,l+1,e[x]));for e=l+1,t do n[e]=nil;end;e=e[o];e=e[o];elseif(d<=28)then local o=e[x];local x=n[o];for e=o+1,e[a]do x=x..n[e];end;n[e[l]]=x;end;elseif(d==29)then n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];local i;local s;local r;local t=0;local function d(n,e,l)e=(t+e)%3 t=((e~=0)and t+((1==e)and n or-n)or t*n)%l return t end for o=1,30 do if d(3446,1133+o,1182)>591 then if d(2834,3952+o,3064)<1532 then if d(1422,9644+o,276)<138 then else end else if d(7302,1802+o,1990)<=995 then n[e[l]]=f[e[x]];else c=e[x];end end else i=l;if d(4360,7418+o,2078)>1039 then if d(8741,6677+o,1328)>664 then n[e[l]]=e[x]-e[a];else n[r]=s;end else if d(9330,6979+o,802)>401 then r=e[i];else s=e[x];end end end end n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];local r;local i;local f;local t=0;local function d(n,e,l)e=(t+e)%3 t=((e~=0)and t+((1==e)and-n or n)or t*n)%l return t end for o=1,25 do if d(5730,5565+o,2970)<=1485 then r=l;if d(4682,2340+o,2372)>1186 then if d(9871,9538+o,3246)>1623 then else local o=e[x];local x=n[o];for e=o+1,e[a]do x=x..n[e];end;n[e[l]]=x;end else i=e[x];if d(5510,3741+o,1152)>=576 then f=e[r];else end end else n[f]=i;if d(8705,6607+o,1600)>800 then if d(8355,5458+o,3234)>1617 then else c=e[x];end else if d(2629,8120+o,2674)>1337 then else end end end end local i;local t;local f;local c=0;local function d(n,e,l)e=(c+e)%3 c=((e~=0)and c+((e<2)and-n or n)or c*n)%l return c end for o=0,32 do if d(3393,8270+o,3824)<1912 then if d(2173,2768+o,1788)>894 then f=e[i];if d(6885,5165+o,2532)<1266 then n[f]=t;else end else if d(8864,9363+o,632)>316 then else end end else if d(2267,5668+o,2812)>1406 then if d(1227,8750+o,2192)<1096 then t=e[x];else end else if d(8246,7968+o,3404)<=1702 then else i=l;end end end end n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];local t;local i;local f;local c=0;local function d(n,e,l)e=(c+e)%3 c=((e~=0)and c+((1==e)and n or-n)or c*n)%l return c end for o=2,31 do if d(5192,2927+o,3178)<=1589 then if d(3390,3738+o,1506)<=753 then if d(3487,3184+o,776)<=388 then n[f]=i;else end else if d(6982,7158+o,1864)>=932 then i=e[x];else end end else if d(1355,1616+o,3826)<1913 then if d(4125,1909+o,2798)<=1399 then f=e[t];else t=l;end else if d(2051,9083+o,2590)<=1295 then else end end end end n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];local i;local t;local f;local c=0;local function d(e,n,l)e=(c+e)%3 c=((e~=0)and c+((e<2)and-n or n)or c*n)%l return c end for o=0,27 do if d(9075,8570+o,286)<=143 then i=l;if d(4283,5381+o,3566)>1783 then if d(7144,5396+o,2046)>=1023 then else t=e[x];end else if d(8193,7345+o,2876)<=1438 then else end end else f=e[i];if d(1809,9051+o,1376)>688 then if d(1968,1049+o,2110)<=1055 then else end else n[f]=t;if d(4448,1555+o,3194)>=1597 then else n[e[l]]=n[e[x]];end end end end n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];local i;local f;local t;local c=0;local function d(e,n,l)e=(c+e)%3 c=((e~=0)and c+((e<2)and n or-n)or c*n)%l return c end for o=1,30 do if d(8710,8461+o,1588)<794 then if d(8393,6076+o,3246)<=1623 then if d(2007,6683+o,3742)>1871 then n[e[l]]=e[x]-e[a];else i=l;end else if d(8378,1816+o,3408)>1704 then n[e[l]]=n[e[x]]+e[a];else t=e[i];end end f=e[x];else if d(6638,4632+o,2672)>1336 then if d(6151,7384+o,512)>256 then n[t]=f;else end else if d(9629,3836+o,3842)>=1921 then else end end end end n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];e=e[o];elseif(d<=30)then local l=e[l];n[l]=0+(n[l]);n[l+1]=0+(n[l+1]);n[l+2]=0+(n[l+2]);local o=n[l];local d=n[l+2];if(d>0)then if(o>n[l+1])then c=e[x];else n[l+3]=o;end;elseif(o<n[l+1])then c=e[x];else n[l+3]=o;end;end;elseif(d<=32)then if(d>31)then n[e[l]]=n[e[x]];e=e[o];n[e[l]]=e[x];e=e[o];local d=e[l];n[d](i(n,d+1,e[x]));for e=d+1,t do n[e]=nil;end;e=e[o];n[e[l]]=f[e[x]];e=e[o];n[e[l]]=e[x];e=e[o];e=e[o];elseif(d<32)then n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];local r;local i;local f;local t=0;local function d(n,e,l)e=(t+e)%3 t=((e~=0)and t+((e<2)and-n or n)or t*n)%l return t end for o=2,31 do if d(3924,6990+o,1438)>=719 then if d(6923,5254+o,2492)<1246 then if d(9157,6682+o,3186)>1593 then else end else if d(6782,3681+o,3858)>=1929 then r=l;else c=e[x];end end i=e[x];else if d(1861,1220+o,3896)>=1948 then if d(8934,3098+o,1570)>=785 then f=e[r];else end else if d(2669,2756+o,1314)<657 then else end end n[f]=i;end end n[e[l]]=e[x];e=e[o];local f;local i;local r;local t=0;local function d(n,e,l)e=(t+e)%3 t=((e~=0)and t+((1==e)and n or-n)or t*n)%l return t end for o=1,32 do if d(8064,9511+o,1488)>=744 then if d(7172,5792+o,2702)>1351 then if d(1242,9605+o,3830)>=1915 then else end else if d(1618,2470+o,2696)<1348 then f=l;else if(e[l]~=e[a])then c=c+1;else c=e[x];end;end end else i=e[x];if d(4155,5966+o,2352)<1176 then if d(2386,4595+o,286)>=143 then else end else r=e[f];if d(4465,2537+o,1520)>=760 then else n[r]=i;end end end end n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];local t;local f;local c;local a=0;local function d(e,n,l)e=(a+e)%3 a=((e~=0)and a+((e<2)and n or-n)or a*n)%l return a end for o=0,25 do if d(8223,8534+o,3746)>1873 then if d(7065,1201+o,1478)>739 then if d(5380,1595+o,742)<=371 then else end else if d(2384,7432+o,3624)<1812 then c=e[t];else end end else if d(6047,1956+o,954)<=477 then if d(1750,6711+o,3522)>=1761 then else end else if d(2362,5474+o,2138)>=1069 then t=l;else n[c]=f;end f=e[x];end end end n[e[l]]=e[x];e=e[o];local f;local t;local c;local a=0;local function d(e,n,l)e=(a+e)%3 a=((e~=0)and a+((e<2)and n or-n)or a*n)%l return a end for o=0,26 do if d(3736,4505+o,2386)>1193 then if d(7169,4658+o,2782)>1391 then f=l;if d(8919,9808+o,904)>452 then t=e[x];else end else if d(6177,9459+o,750)<375 then else end end else c=e[f];if d(9226,2327+o,1982)>991 then n[c]=t;if d(9227,1212+o,3024)>=1512 then else end else if d(2046,4460+o,658)>=329 then else end end end end local c;local t;local f;local a=0;local function d(e,n,l)e=(a+e)%3 a=((e~=0)and a+((e<2)and n or-n)or a*n)%l return a end for o=1,25 do if d(3145,8253+o,1122)<=561 then c=l;if d(2180,5811+o,2568)<1284 then t=e[x];if d(8636,2758+o,1598)>=799 then else f=e[c];end else if d(7089,8658+o,1264)<=632 then else end end else n[f]=t;if d(5077,1618+o,3026)<1513 then if d(9007,9890+o,704)<=352 then else end else if d(5954,2673+o,1394)>697 then else end end end end n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];e=e[o];end;elseif(d<=33)then n[e[l]]=e[x];e=e[o];local d=(_108);(function()n[e[l]]=e[x];e=e[o];end){};n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];local f;local t;local c;local a=0;local function d(e,n,l)e=(a+e)%3 a=((e~=0)and a+((e<2)and-n or n)or a*n)%l return a end for o=1,32 do if d(4864,4363+o,2210)>=1105 then if d(9381,4667+o,912)<456 then if d(1539,6853+o,3054)<=1527 then c=e[f];else end else if d(4612,9037+o,810)<=405 then else end end n[c]=t;else if d(4243,8546+o,3996)>1998 then if d(2311,6659+o,2704)<1352 then else f=l;end else if d(7558,4964+o,3774)<1887 then else end end t=e[x];end end n[e[l]]=e[x];e=e[o];local d=(_94);(function()n[e[l]]=e[x];e=e[o];end){};n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];local d=(_49);(function()n[e[l]]=e[x];e=e[o];end){};n[e[l]]=e[x];e=e[o];local d=(_143);(function()n[e[l]]=e[x];e=e[o];end){};n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];local d=(_17);(function()n[e[l]]=e[x];e=e[o];end){};n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];local c;local t;local f;local a=0;local function d(e,n,l)e=(a+e)%3 a=((e~=0)and a+((1==e)and n or-n)or a*n)%l return a end for o=1,30 do if d(4994,3645+o,3620)>=1810 then if d(2149,2281+o,872)<=436 then if d(8205,5814+o,2034)<=1017 then else end else if d(3821,8799+o,2926)>=1463 then n[f]=t;else c=l;end end else if d(1170,7014+o,1136)>568 then if d(6062,7040+o,712)>=356 then else end else if d(9153,1500+o,2658)<=1329 then else t=e[x];end end f=e[c];end end n[e[l]]=e[x];e=e[o];n[e[l]]=e[x];e=e[o];e=e[o];elseif(d>34)then n[e[l]]=n[e[x]];elseif(d<35)then local l=e[l];local d=n[l+2];local o=n[l]+d;n[l]=o;if(d>0)then if(o<=n[l+1])then c=e[x];n[l+3]=o;end;elseif(o>=n[l+1])then c=e[x];n[l+3]=o;end;end;until false end);end;return u(X(),{},H())(...);end)(({[((726709947-#("luraph is now down until further notice for an emergency major security update")))]=("\99");['RAW482pW']=(((582801833-#("luraph is now down until further notice for an emergency major security update"))));[((#{608;}+376340189))]=(((#{413;647;480;726;(function(...)return 392,...;end)(703)}+2041)));['Q6cX64C56v']=((824));[(752980701)]=((16777216));[(511835204)]=("\111");["Ix4ONoe"]=((90));["uPqEDA"]=(((#{(function(...)return 327,...;end)(193,10,928)}+252)));[(835090566)]=((978826994));[(503112279)]=("\98");[(931674298)]=((840402));[((#{624;535;515;(function(...)return 140,496,112;end)()}+128335422))]=((248));[((#{458;966;255;573;}+238930946))]=((6));[(466726703)]=((1));[((404337978-#("I hate this codebase so fucking bad! - notnoobmaster")))]=(((94577304-#("woooow u hooked an opcode, congratulations~ now suck my cock"))));["ecav3"]=((965332980));[(599516051)]=(((116884048-#("I'm not ignoring you, my DMs are full. Can't DM me? Shoot me a email: mem@mem.rip (Business enquiries only)"))));[(582801755)]=("\97");[((#{542;285;477;(function(...)return 538,930,...;end)(522)}+772095201))]=("\105");["jk5VsiX"]=((503112279));[((116883983-#("this isn't krnl support you bonehead moron")))]=("\114");[((618509486-#("Wally likes cock")))]=("\117");[(578527547)]=((199080));[((#{699;223;175;345;}+65890330))]=("\109");['U3JljS56OO']=(((528829664-#("If you see this, congrats you're gay"))));[((#{188;404;727;(function(...)return 950;end)()}+501754408))]=(((217-#("I hate this codebase so fucking bad! - notnoobmaster"))));[(586960471)]=(((#{}+367161486)));WHMj0F=("\116");["gk8BMuYC5W"]=((1023));[((40024503-#("concat was here")))]=((20));[(946840393)]=((964690219));[((#{257;578;638;290;}+617635309))]=(((#{386;179;(function(...)return 274,825,452,...;end)()}+423067)));[((849895087-#("When the exploiter is sus")))]=(((#{29;}+826)));jZGwvrCr=("\107");[(521429587)]=((3));[((#{312;265;789;(function(...)return 345,976,...;end)(926,984)}+5607280))]=(((210-#("why does psu.dev attract so many ddosing retards wtf"))));[((#{31;111;}+355743044))]=(((1715-#("guys someone play Among Us with memcorrupt he is so lonely :("))));[((#{}+568294571))]=(((941-#("psu premium chads winning (only joe biden supporters use the free version)"))));[(630475014)]=((2));[(148608376)]=((392));[((#{807;783;784;(function(...)return 651,761,158,...;end)(22,428,101,575)}+367161476))]=("\108");[(547305580)]=(((29618-#("guys someone play Among Us with memcorrupt he is so lonely :("))));bcCAp=("\112");[(532446733)]=(((81-#("woooow u hooked an opcode, congratulations~ now suck my cock"))));['jH18rVde7t']=(((#{698;550;836;}+24621)));["l1GA7Jqt8"]=(((65-#("Perth Was here impossible ikr"))));["B5brsQgFhV"]=("\51");[((#{273;878;563;695;(function(...)return 857,646,139,...;end)(428,646)}+978826985))]=("\50");[(898350527)]=((5));hVk0rR=("\103");[((#{266;86;496;118;(function(...)return 328,793,338,978;end)()}+528829620))]=("\104");[(964690219)]=("\35");[((#{605;504;336;(function(...)return 40,58,557,678,...;end)(895,250)}+854376259))]=(((#{307;10;}+7)));["aLMu3XbeF"]=(((#{429;773;(function(...)return 490,11,735,...;end)(395,480,375)}-1)));[(826966026)]=(((#{869;(function(...)return 248,292,390,127;end)()}+65531)));[(942548926)]=(((#{743;713;}+831)));['bPiSJi']=("\121");tm3a56UI=("\110");[((#{}+572167784))]=((32));[(945297115)]=((11919));[((#{}+73390856))]=((4));[(669292019)]=(((948-#("LuraphDeobfuscator.zip (oh god DMCA incoming everyone hide)"))));[((#{416;486;219;765;(function(...)return 629,141;end)()}+596530472))]=(((81-#("Perth Was here impossible ikr"))));[((#{846;854;}+119226620))]=((618509470));[(94577244)]=("\115");[((429467939-#("Wally likes cock")))]=(((#{23;}+45791)));["gRVCX1WY"]=(((358-#("oh Mr. Pools, thats a little close please dont touch me there... please Mr. Pools I am only eight years old please stop..."))));["O0X5TUt"]=(((#{553;872;314;}+28)));[(432652862)]=(((#{989;150;249;280;}+65890330)));kFBLrzcI=((637755));[(517825164)]=(((#{}+8)));xDM3C=("\102");['RWUVLRLl']=(((#{128;335;656;(function(...)return 570,225,220;end)()}+772095201)));[((965333075-#("uh oh everyone watch out pain exist coming in with the backspace method one dot two dot man dot")))]=("\101");[(694872820)]=("\100");[(133384641)]=(((#{48;260;51;(function(...)return 262;end)()}+149)));[(801379773)]=((441715));[(791244531)]=(((#{465;126;184;335;(function(...)return 406,252,767;end)()}-7)));l2fG9xB=(((#{(function(...)return 150,314,796;end)()}+694872817)));[(1781660)]=((1778));[((#{921;428;863;924;}+609405763))]=(((5067-#("i am not wally stop asking me for wally hub support please fuck off"))));WWzQu=(((726709894-#("When the exploiter is sus"))));[(524582611)]=(((511835389-#("Luraph: Probably considered the worst out of the three, Luraph is another Lua Obfuscator. It isnt remotely as secure as Ironbrew or Synapse Xen, and it isn't as fast as Ironbrew either."))));}),...)})do return e end;