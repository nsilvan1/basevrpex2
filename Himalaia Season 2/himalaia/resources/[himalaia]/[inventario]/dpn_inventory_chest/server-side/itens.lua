local Tools = module("vrp","lib/Tools")
local idgens = Tools.newIDGenerator()
local actived = {}
local bandagem = {}
local pick = {}


function recarregarArma(source,user_id,item,amount,slot)
    local uweapons = vRPclient.getWeapons(source)
    local weaponuse = string.gsub(item,"wammo|","")
    local weaponusename = "wammo|"..weaponuse
    local identity = vRP.getUserIdentity(user_id)
    if uweapons[weaponuse] then
        local itemAmount = 0
        local inventory = getPlayerInventory(user_id)
        for k,v in pairs(inventory) do
            if weaponusename == v.item then
                if v.amount > 250 then
                v.amount = 250
                end

                itemAmount = v.amount
        
			    if vRP.tryGetInventoryItem(user_id,weaponusename,parseInt(amount),slot) then
				    local weapons = {}
				    weapons[weaponuse] = { ammo = amount }
				    itemAmount = amount
                    dPNclient._giveWeapons(source,weapons,false)
                    
				    SendWebhookMessage(ConfigServer['webhook'].equip,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RECARREGOU]: "..item.." \n[MUNICAO]: "..amount.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			    end
            end
        end
    end
end

function equipWeapon(source, user_id,item,amount,slot)
    if vRP.tryGetInventoryItem(user_id,item,1,slot) then
        local weapons = {}
        local identity = getUserIdentity(user_id)
        weapons[string.gsub(item,"wbody|","")] = { ammo = 0 }
        dPNclient._giveWeapons(source,weapons,false)
        SendWebhookMessage(ConfigServer['webhook'].equip,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[EQUIPOU]: "..item.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
    end
end

function itensUse(source, user_id, item, amount, type, slot)
    if amount > 0 and not actived[user_id] and actived[user_id] == nil then
        if item == "bandagem" then
            if vRPclient.getHealth(source) > 101 and vRPclient.getHealth(source) < 250 then
                if bandagem[user_id] == 0 or not bandagem[user_id] then
                    if vRP.tryGetInventoryItem(user_id,"bandagem",1,slot) then
                        bandagem[user_id] = 120
                        actived[user_id] = true
                        dPNclient._CarregarObjeto(source,"amb@world_human_clipboard@male@idle_a","idle_c","v_ret_ta_firstaid",49,60309)
                        dPNclient.updateInventory(source)
                        TriggerClientEvent('cancelando',source,true)
                        TriggerClientEvent("progress",source,20000,"bandagem")
                        SetTimeout(20000,function()
                            actived[user_id] = nil
                            TriggerClientEvent('bandagem',source)
                            TriggerClientEvent('cancelando',source,false)
                            dPNclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Bandagem utilizada com sucesso.",8000)
                            Citizen.Wait(10000)
                            TriggerEvent('resetWarfarina')
                            TriggerEvent('resetBleeding')
                            TriggerEvent('resetDiagnostic')
                        end)
                    end
                else
                    TriggerClientEvent("Notify",source,"importante","Aguarde "..vRPclient.getTimeFunction(source,parseInt(bandagem[user_id]))..".",8000)
                end
            else
            TriggerClientEvent("Notify",source,"aviso","Você não pode utilizar de vida cheia ou nocauteado.",8000)
        end
        elseif item == "analgetico" then
            if vRP.tryGetInventoryItem(user_id,"analgetico",1,slot) then
                dPNclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_cs_pills",49,28422)     
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                TriggerClientEvent("progress",source,20500,"tomando")
                SetTimeout(20500,function()
                    TriggerClientEvent('cancelando',source,false)
                    TriggerClientEvent("resetBleeding",source)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Analgetico utilizado com sucesso",8000)
                end)
            end
        elseif item == "adrenalina" then
            if vRP.tryGetInventoryItem(user_id,"adrenalina",1,slot) then
                dPNclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_cs_pills",49,28422) 
                dPNclient.updateInventory(source)	
                TriggerClientEvent('cancelando',source,true)
                TriggerClientEvent("progress",source,20500,"coumadin")
                SetTimeout(20500,function()
                    TriggerClientEvent('cancelando',source,false)
                    TriggerClientEvent("resetBleeding",source)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Adrenalina utilizado com sucesso",8000)
                end)
            end

            
        elseif item == "radio" then
           -- if vRP.tryGetInventoryItem(user_id,"nill",1) then
                TriggerClientEvent("progress",source,2000,"ligando Radio")
                SetTimeout(2000,function()
                    TriggerClientEvent('cancelando',source,false)
                    TriggerClientEvent("vrp_radio:toggleNui",source,true)
                    TriggerClientEvent("Notify",source,"sucesso","Conecte uma Frequência..",8000)
                end)
        elseif item == "ibuprofeno" then
            if vRP.tryGetInventoryItem(user_id,"ibuprofeno",1,slot) then
                dPNclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_cs_pills",49,28422) 
                dPNclient.updateInventory(source)	
                TriggerClientEvent('cancelando',source,true)
                TriggerClientEvent("progress",source,20500,"coumadin")
                SetTimeout(20500,function()
                    TriggerClientEvent('cancelando',source,false)
                    TriggerClientEvent("resetBleeding",source)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Ibuprofeno utilizado com sucesso",8000)
                end)
            end
        elseif item == "paracetamol" then
            if vRP.tryGetInventoryItem(user_id,"paracetamol",1,slot) then
                dPNclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_cs_pills",49,28422) 
                dPNclient.updateInventory(source)	
                TriggerClientEvent('cancelando',source,true)
                TriggerClientEvent("progress",source,20500,"coumadin")
                SetTimeout(20500,function()
                    TriggerClientEvent('cancelando',source,false)
                    TriggerClientEvent("resetBleeding",source)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Paracetamol utilizado com sucesso",8000)
                end)
            end
        --------------------------------------------------------   
        elseif item == "mochila" then
            if vRP.tryGetInventoryItem(user_id,"mochila",1,slot) then
                dPNclient.updateInventory(source)
                vRP.varyExp(user_id,"physical","strength",650)
                TriggerClientEvent("Notify",source,"sucesso","Mochila utilizada com sucesso.",8000)
            end

        elseif item == "dima" then
            if vRP.tryGetInventoryItem(user_id,"dima",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                TriggerClientEvent("progress",source,2000,"Guardando")
                SetTimeout(2000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.execute("hzin/add_dima",{ id = user_id, coins = "1"})
                    TriggerClientEvent("Notify",source,"sucesso","Você guardou seus Diamantes!",8000)
                end)
            end

         -----[vips]
        elseif item == "vipgold" then
            if vRP.tryGetInventoryItem(user_id,"vipgold",1,slot) then
                dPNclient.updateInventory(source)
                vRP.varyExp(user_id,"physical","strength",1000)
                vRP.giveInventoryItem(user_id,"dinheiro",50000)
                vRP.execute("creative/add_vehicle",{ user_id = user_id, vehicle = "c7", ipva = parseInt(os.time()) })
                TriggerClientEvent("Notify",source,"sucesso","Você ultilizou a Pulseira Gold com Sucesso!",8000)
            end   
        --------------------------------------------------------   
        elseif item == "agua" then
            if vRP.tryGetInventoryItem(user_id,"agua",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
				dPNclient._CarregarObjeto(source,"mp_player_intdrink","loop_bottle","prop_ld_flow_bottle",49,60309)
                TriggerClientEvent("progress",source,10000,"bebendo")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.upgradeThirst(user_id,35)
                    vRP.giveInventoryItem(user_id,"garrafa-vazia",1)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Água utilizada com sucesso",8000)
                end)
            end	
        elseif item == "garrafa-vazia" then
            if vRP.tryGetInventoryItem(user_id,"garrafa-vazia",1,slot) then
                actived[user_id] = true
                TriggerClientEvent('cancelando',source,true)
                TriggerClientEvent('watercooler:use',source)
                TriggerClientEvent("progress",source,6000,"enchendo")
                SetTimeout(6000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
                    dPNclient.updateInventory(source)
                end)
            end	
        elseif item == "cafe" then
            if vRP.tryGetInventoryItem(user_id,"cafe",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@world_human_aa_coffee@idle_a", "idle_a","p_amb_coffeecup_01",49,28422)
                TriggerClientEvent("progress",source,10000,"bebendo")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.upgradeThirst(user_id,35)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Cafe utilizada com sucesso",8000)
                end)
            end	
        elseif item == "cola" then
            if vRP.tryGetInventoryItem(user_id,"cola",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"mp_player_intdrink","loop_bottle","prop_ecola_can",49,60309)       
                TriggerClientEvent("progress",source,10000,"bebendo")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.upgradeThirst(user_id,35)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Cola utilizada com sucesso",8000)
                end)
            end	
        elseif item == "sprunk" then
            if vRP.tryGetInventoryItem(user_id,"sprunk",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"mp_player_intdrink","loop_bottle","ng_proc_sodacan_01b",49,60309)          
                TriggerClientEvent("progress",source,10000,"bebendo")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.upgradeThirst(user_id,35)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Sprunk utilizada com sucesso",8000)
                end)
            end	
        elseif item == "cerveja" then
            if vRP.tryGetInventoryItem(user_id,"cerveja",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
                TriggerClientEvent("progress",source,30000,"bebendo")
                SetTimeout(30000,function()
                    actived[user_id] = nil
                    dPNclient.playScreenEffect(source,"RaceTurbo",180)
                    dPNclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
                    TriggerClientEvent('cancelando',source,false)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Cerveja utilizada com sucesso",8000)
                end)
            end
        elseif item == "tequila" then
            if vRP.tryGetInventoryItem(user_id,"tequila",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
                TriggerClientEvent("progress",source,30000,"bebendo")
                SetTimeout(30000,function()
                    actived[user_id] = nil
                    dPNclient.playScreenEffect(source,"RaceTurbo",180)
                    dPNclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
                    TriggerClientEvent('cancelando',source,false)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Tequila utilizada com sucesso",8000)
                end)
            end
        elseif item == "vodka" then
            if vRP.tryGetInventoryItem(user_id,"vodka",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
                TriggerClientEvent("progress",source,30000,"bebendo")
                SetTimeout(30000,function()
                    actived[user_id] = nil
                    dPNclient.playScreenEffect(source,"RaceTurbo",180)
                    dPNclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
                    TriggerClientEvent('cancelando',source,false)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Vodka utilizada com sucesso",8000)
                end)
            end
        elseif item == "whisky" then
            if vRP.tryGetInventoryItem(user_id,"whisky",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","p_whiskey_notop",49,28422)
                TriggerClientEvent("progress",source,30000,"bebendo")
                SetTimeout(30000,function()
                    actived[user_id] = nil
                    dPNclient.playScreenEffect(source,"RaceTurbo",180)
                    dPNclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
                    TriggerClientEvent('cancelando',source,false)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Whisky utilizado com sucesso",8000)
                end)
            end
        elseif item == "conhaque" then
            if vRP.tryGetInventoryItem(user_id,"conhaque",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
                TriggerClientEvent("progress",source,30000,"bebendo")
                SetTimeout(30000,function()
                    actived[user_id] = nil
                    dPNclient.playScreenEffect(source,"RaceTurbo",180)
                    dPNclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
                    TriggerClientEvent('cancelando',source,false)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Conhaque utilizado com sucesso",8000)
                end)
            end
        elseif item == "absinto" then
            if vRP.tryGetInventoryItem(user_id,"absinto",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
                TriggerClientEvent("progress",source,30000,"bebendo")
                SetTimeout(30000,function()
                    actived[user_id] = nil
                    dPNclient.playScreenEffect(source,"RaceTurbo",180)
                    dPNclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
                    TriggerClientEvent('cancelando',source,false)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Absinto utilizado com sucesso",8000)
                end)
            end
        --------------------------------------------------------    
        elseif item == "batataf" then
            if vRP.tryGetInventoryItem(user_id,"batataf",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_food_bs_chips",49,18905) 
                TriggerClientEvent("progress",source,10000,"comendo")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
                    vRP.downgradeStress(user_id,25)
					vRP.upgradeHunger(user_id,23)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Você comeu batatinha",8000)
                end)
            end	   
        elseif item == "bchocolate" then
            if vRP.tryGetInventoryItem(user_id,"bchocolate",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_choc_ego",49,60309)  
                TriggerClientEvent("progress",source,10000,"comendo")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.upgradeHunger(user_id,23)
                    vRP.downgradeStress(user_id,25)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Você comeu chocolate",8000)
                end)
            end	   
        elseif item == "frango" then
            if vRP.tryGetInventoryItem(user_id,"frango",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_choc_ego",49,60309)   
                TriggerClientEvent("progress",source,10000,"comendo")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.upgradeHunger(user_id,23)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Você comeu frango",8000)
                end)
            end	   
        elseif item == "hotdog" then
            if vRP.tryGetInventoryItem(user_id,"hotdog",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","prop_cs_hotdog_01",49,28422)
                TriggerClientEvent("progress",source,10000,"comendo")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.upgradeHunger(user_id,23)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Você comeu hotdog",8000)
                end)
            end	   
        elseif item == "pizza" then
            if vRP.tryGetInventoryItem(user_id,"pizza",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","v_res_tt_pizzaplate",49,28422)
                TriggerClientEvent("progress",source,10000,"comendo")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.upgradeHunger(user_id,23)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Você comeu pizza",8000)
                end)
            end	   
        elseif item == "taco" then
            if vRP.tryGetInventoryItem(user_id,"taco",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","prop_taco_01",49,28422)
                TriggerClientEvent("progress",source,10000,"comendo")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.upgradeHunger(user_id,23)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Você comeu taco",8000)
                end)
            end	   
        elseif item == "xburguer" then
            if vRP.tryGetInventoryItem(user_id,"xburguer",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_cs_burger_01",49,60309)
                TriggerClientEvent("progress",source,10000,"comendo")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.upgradeHunger(user_id,23)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Você comeu xburguer",8000)
                end)
            end	   
        --------------------------------------------------------                              	            
        elseif item == "maconha" then
            if vRP.tryGetInventoryItem(user_id,"maconha",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                vRPclient._playAnim(source,true,{{"mp_player_int_uppersmoke","mp_player_int_smoke"}},true)
                TriggerClientEvent("progress",source,10000,"fumando")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    vRPclient._stopAnim(source,false)
                    dPNclient.playScreenEffect(source,"RaceTurbo",180)
                    dPNclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
                    TriggerClientEvent("Notify",source,"sucesso","Maconha utilizada com sucesso",8000)
                end)
            end
        elseif item == "cocaina" then
            if vRP.tryGetInventoryItem(user_id,"cocaina",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                vRPclient._playAnim(source,true,{{"mp_player_int_uppersmoke","mp_player_int_smoke"}},true)
                TriggerClientEvent('cancelando',source,true)
                TriggerClientEvent("progress",source,10000,"cheirando")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    vRPclient._stopAnim(source,false)
                    TriggerClientEvent('cancelando',source,false)
                    dPNclient.playScreenEffect(source,"RaceTurbo",120)
                    dPNclient.playScreenEffect(source,"DrugsTrevorClownsFight",120)
                    TriggerClientEvent("Notify",source,"sucesso","Cocaína utilizada com sucesso",8000)
                end)
            end
        elseif item == "metanfetamina" then
            if vRP.tryGetInventoryItem(user_id,"metanfetamina",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                vRPclient._playAnim(source,true,{{"mp_player_int_uppersmoke","mp_player_int_smoke"}},true)
                TriggerClientEvent("progress",source,10000,"fumando")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    vRPclient._stopAnim(source,false)
                    dPNclient.playScreenEffect(source,"RaceTurbo",180)
                    dPNclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
                    TriggerClientEvent("Notify",source,"sucesso","Metanfetamina utilizada com sucesso",8000)
                end)
            end	
        elseif item == "ecstasy" then
            if vRP.tryGetInventoryItem(user_id,"ecstasy",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                vRPclient._playAnim(source,true,{{"mp_player_int_uppersmoke","mp_player_int_smoke"}},true)
                TriggerClientEvent("progress",source,10000,"tomando")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    vRPclient._stopAnim(source,false)
                    dPNclient.playScreenEffect(source,"RaceTurbo",180)
                    dPNclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
                    TriggerClientEvent("Notify",source,"sucesso","Ecstasy utilizado com sucesso",8000)
                end)
            end	
        --------------------------------------------------------
        elseif item == "skate" then
            if vRP.tryGetInventoryItem(user_id,"skate",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent("progress",source,2000,"equipando")
                actived[user_id] = nil
                TriggerClientEvent("skate", source)
            end	     
        elseif item == "capuz" then
            if vRP.getInventoryItemAmount(user_id,"capuz") >= 1 then
                local nplayer = vRPclient.getNearestPlayer(source,2)
                if nplayer then
                    vRPclient.setCapuz(nplayer)
                    vRP.closeMenu(nplayer)
                    TriggerClientEvent("Notify",source,"sucesso","Capuz utilizado com sucesso.",8000)
                end
            end

        elseif item == "energetico" then
            if vRP.tryGetInventoryItem(user_id,"energetico",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_energy_drink",49,28422)
                TriggerClientEvent("progress",source,20000,"bebendo")
                SetTimeout(20000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('energeticos',source,true)
                    TriggerClientEvent('cancelando',source,false)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Energético utilizado com sucesso",8000)
                end)
                SetTimeout(60000,function()
                    TriggerClientEvent('energeticos',source,false)
                    TriggerClientEvent("Notify",source,"aviso","O efeito do energético passou e o coração voltou a bater normalmente",8000)
                end)
            end


        elseif item == "lockpick" then
            local vehicle,vnetid,placa,vname,lock,banned,trunk,model,street = vRPclient.vehList(source,7)
            local policia = vRP.getUsersByPermission(ConfigServer['policiaPermissao'])
            if #policia < 0 then
                TriggerClientEvent("Notify",source,"aviso","Número insuficiente de policiais no momento para iniciar o roubo")
                return true
            end
            if hasPermission(user_id,ConfigServer['policiaPermissao']) then
                TriggerEvent("setPlateEveryone",placa)
                vGARAGE.vehicleClientLock(-1,vnetid,lock)
                TriggerClientEvent("vrp_sound:source",source,'lock',0.5)
                return
            end
            if vRP.getInventoryItemAmount(user_id,"lockpick") >= 1 and vRP.tryGetInventoryItem(user_id,"lockpick",1,slot) and vehicle then
                actived[user_id] = true
                if hasPermission(user_id,ConfigServer['policiaPermissao']) then
                    actived[user_id] = nil
                    TriggerEvent("setPlateEveryone",placa)
                    vGARAGE.vehicleClientLock(-1,vnetid,lock)
                    return
                end
    
                TriggerClientEvent('cancelando',source,true)
                vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
                TriggerClientEvent("progress",source,5000,"Arrombando o veiculo...")
                SetTimeout(5000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
                    vRPclient._stopAnim(source,false)

                    if math.random(100) >= 50 then
                        TriggerEvent("setPlateEveryone",placa)
                        vGARAGE.vehicleClientLock(-1,vnetid,lock)
                        TriggerClientEvent("vrp_sound:source",source,'lock',0.5)
                        TriggerClientEvent("Notify",source,"sucesso","Você conseguiu destrancar o veículo",8000)
                    else
                        TriggerClientEvent("Notify",source,"negado","Sua Lockpick quebrou tentando roubar o veículo e as autoridades foram acionadas",8000)
                        local policia = vRP.getUsersByPermission(ConfigServer['policiaPermissao'])
                        local x,y,z = vRPclient.getPosition(source)
                        for k,v in pairs(policia) do
                            local player = vRP.getUserSource(parseInt(v))
                            if player then
                                async(function()
                                end)
                            end
                        end
                    end
                end)
            end
        elseif item == "repairkit" then
            if not vRPclient.isInVehicle(source) then
                local vehicle = vRPclient.getNearestVehicle(source,3.5)
                if vehicle then
                    if hasPermission(user_id,"mecanico.permissao") then
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
                        if vRP.tryGetInventoryItem(user_id,"repairkit",1,slot) then
                            actived[user_id] = true
                            dPNclient.updateInventory(source)
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
        elseif item == "pneu" then
            if not vRPclient.isInVehicle(source) then
                local vehicle = vRPclient.getNearestVehicle(source,3)
                if vehicle then
                    if hasPermission(user_id,"mecanico.permissao") then
                        actived[user_id] = true
                        TriggerClientEvent('cancelando',source,true)
                        vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
                        TriggerClientEvent("progress",source,30000,"reparando pneus")
                        SetTimeout(30000,function()
                            actived[user_id] = nil
                            TriggerClientEvent('cancelando',source,false)
                            TriggerClientEvent('repararpneus',source,vehicle)
                            vRPclient._stopAnim(source,false)
                        end)
                    else
                        if vRP.tryGetInventoryItem(user_id,"pneus",1,slot) then
                            actived[user_id] = true
                            dPNclient.updateInventory(source)
                            TriggerClientEvent('cancelando',source,true)
                            vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
                            TriggerClientEvent("progress",source,30000,"reparando pneus")
                            SetTimeout(30000,function()
                                actived[user_id] = nil
                                TriggerClientEvent('cancelando',source,false)
                                TriggerClientEvent('repararpneus',source,vehicle)
                                vRPclient._stopAnim(source,false)
                            end)
                        end
                    end
                end
            end	

        elseif item == "mapacorridas" then
            -- if vRP.tryGetInventoryItem(user_id,"agua",1,slot) then
                 actived[user_id] = true
                 TriggerClientEvent("progress",source,10000,"Lendo Mapa")
                 SetTimeout(10000,function()
                     actived[user_id] = nil
                     TriggerClientEvent('hzin:AdicionarCDS',source,true)
                     TriggerClientEvent('cancelando',source,false)
                     TriggerClientEvent("Notify",source,"sucesso","Leu o mapa e memorizou as corridas!",8000)
                 end)
           --  end	


         elseif item == "raspadinha" then
            local src = source
            if vRP.tryGetInventoryItem(user_id,"raspadinha",1) then


                TriggerClientEvent("progress",source,10000,"raspando")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
                    TriggerClientEvent('raspa:usar', source)
                    TriggerClientEvent("itensNotify",source,"usar","Comendo",""..item.."")
                end)

                
            end

           elseif item == "farda-recruta" then
            if vRP.tryGetInventoryItem(user_id,"nill",1) then
                --TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
                else
                    TriggerClientEvent("inventory:farda1on",source)
                    TriggerClientEvent("itensNotify",source,"usar","Equipou",""..item.."")
                    vRP.tryGetInventoryItem(user_id,"farda-recruta",1)
                    vRP.giveInventoryItem(user_id,"fardaoff1",1)
                end

            elseif item == "farda-soldado" then
              if vRP.tryGetInventoryItem(user_id,"nil",1) then
                --TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
                else
                    TriggerClientEvent("inventory:farda2on",source)
                    TriggerClientEvent("itensNotify",source,"usar","Equipou",""..item.."")
                    vRP.tryGetInventoryItem(user_id,"farda-soldado",1)
                    vRP.giveInventoryItem(user_id,"fardaoff2",1)
                end
            elseif item == "farda-cabo" then
                if vRP.tryGetInventoryItem(user_id,"nil",1) then
                    --TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
                else
                    TriggerClientEvent("inventory:farda3on",source)
                    TriggerClientEvent("itensNotify",source,"usar","Equipou",""..item.."")
                    vRP.tryGetInventoryItem(user_id,"farda-cabo",1)
                    vRP.giveInventoryItem(user_id,"fardaoff3",1)
                end
    
            elseif item == "farda-sargento" then
               if vRP.tryGetInventoryItem(user_id,"nil",1) then
                        --TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
                else
                    TriggerClientEvent("inventory:farda4on",source)
                    TriggerClientEvent("itensNotify",source,"usar","Equipou",""..item.."")
                    vRP.tryGetInventoryItem(user_id,"farda-sargento",1)
                    vRP.giveInventoryItem(user_id,"fardaoff4",1)
                end	
            elseif item == "farda-tenente" then
                if vRP.tryGetInventoryItem(user_id,"nil",1) then
                         --TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
                 else
                     TriggerClientEvent("inventory:farda5on",source)
                     TriggerClientEvent("itensNotify",source,"usar","Equipou",""..item.."")
                     vRP.tryGetInventoryItem(user_id,"farda-tenente",1)
                     vRP.giveInventoryItem(user_id,"fardaoff5",1)
                 end	
             elseif item == "farda-speed" then
                 if vRP.tryGetInventoryItem(user_id,"nil",1) then
                             --TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
                 else
                   TriggerClientEvent("inventory:farda6on",source)
                   TriggerClientEvent("itensNotify",source,"usar","Equipou",""..item.."")
                   vRP.tryGetInventoryItem(user_id,"farda-speed",1)
                   vRP.giveInventoryItem(user_id,"fardaoff6",1)
                 end 
            elseif item == "farda-gtm" then
                  if vRP.tryGetInventoryItem(user_id,"nil",1) then
                                --TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
                 else
                  TriggerClientEvent("inventory:farda7on",source)
                  TriggerClientEvent("itensNotify",source,"usar","Equipou",""..item.."")
                  vRP.tryGetInventoryItem(user_id,"farda-gtm",1)
                  vRP.giveInventoryItem(user_id,"fardaoff7",1)
               end   
            elseif item == "farda-graer" then
                if vRP.tryGetInventoryItem(user_id,"nil",1) then
                              --TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
               else
                TriggerClientEvent("inventory:farda8on",source)
                TriggerClientEvent("itensNotify",source,"usar","Equipou",""..item.."")
                vRP.tryGetInventoryItem(user_id,"farda-graer",1)
                vRP.giveInventoryItem(user_id,"fardaoff8",1)
             end 
            elseif item == "farda-got" then
                if vRP.tryGetInventoryItem(user_id,"nil",1) then
                              --TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
               else
                TriggerClientEvent("inventory:farda9on",source)
                TriggerClientEvent("itensNotify",source,"usar","Equipou",""..item.."")
                vRP.tryGetInventoryItem(user_id,"farda-got",1)
                vRP.giveInventoryItem(user_id,"fardaoff9",1)
             end     
            
            elseif item == "farda-medico" then
                if vRP.tryGetInventoryItem(user_id,"nil",1) then
                              --TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
               else
                TriggerClientEvent("inventory:farda10on",source)
                TriggerClientEvent("itensNotify",source,"usar","Equipou",""..item.."")
                vRP.tryGetInventoryItem(user_id,"farda-medico",1)
                vRP.giveInventoryItem(user_id,"fardaoff10",1)
             end      
            elseif item == "farda-enfermeiro" then
                if vRP.tryGetInventoryItem(user_id,"nil",1) then
                              --TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
               else
                TriggerClientEvent("inventory:farda11on",source)
                TriggerClientEvent("itensNotify",source,"usar","Equipou",""..item.."")
                vRP.tryGetInventoryItem(user_id,"farda-enfermeiro",1)
                vRP.giveInventoryItem(user_id,"fardaoff11",1)
             end    



            elseif item == "fardaoff1" then
              if vRP.tryGetInventoryItem(user_id,"nill",1) then
                
                        --TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
                else
                    TriggerClientEvent("inventory:fardaoff",source)
                    TriggerClientEvent("itensNotify",source,"usar","Equipou",""..item.."")
                    vRP.tryGetInventoryItem(user_id,"fardaoff1",1)
                    vRP.giveInventoryItem(user_id,"farda-recruta",1)
                end	

            elseif item == "fardaoff2" then
                if vRP.tryGetInventoryItem(user_id,"nill",1) then
                    
                            --TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
                    else
                        TriggerClientEvent("inventory:fardaoff",source)
                        TriggerClientEvent("itensNotify",source,"usar","Equipou",""..item.."")
                        vRP.tryGetInventoryItem(user_id,"fardaoff2",1)
                        vRP.giveInventoryItem(user_id,"farda-soldado",1)
                    end
        
            elseif item == "fardaoff3" then
                    if vRP.tryGetInventoryItem(user_id,"nill",1) then
                        
                                --TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
                        else
                            TriggerClientEvent("inventory:fardaoff",source)
                            TriggerClientEvent("itensNotify",source,"usar","Equipou",""..item.."")
                            vRP.tryGetInventoryItem(user_id,"fardaoff3",1)
                            vRP.giveInventoryItem(user_id,"farda-cabo",1)
                        end

            elseif item == "fardaoff4" then
                        if vRP.tryGetInventoryItem(user_id,"nill",1) then
                            
                                    --TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
                            else
                                TriggerClientEvent("inventory:fardaoff",source)
                                TriggerClientEvent("itensNotify",source,"usar","Equipou",""..item.."")
                                vRP.tryGetInventoryItem(user_id,"fardaoff4",1)
                                vRP.giveInventoryItem(user_id,"farda-sargento",1)
                            end
            elseif item == "fardaoff5" then
                         if vRP.tryGetInventoryItem(user_id,"nill",1) then
                                
                                        --TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
                             else
                               TriggerClientEvent("inventory:fardaoff",source)
                               TriggerClientEvent("itensNotify",source,"usar","Equipou",""..item.."")
                               vRP.tryGetInventoryItem(user_id,"fardaoff5",1)
                               vRP.giveInventoryItem(user_id,"farda-tenente",1)
                            end
            elseif item == "fardaoff6" then
                      if vRP.tryGetInventoryItem(user_id,"nill",1) then
                                   
                                           --TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
                       else
                            TriggerClientEvent("inventory:fardaoff",source)
                            TriggerClientEvent("itensNotify",source,"usar","Equipou",""..item.."")
                            vRP.tryGetInventoryItem(user_id,"fardaoff6",1)
                            vRP.giveInventoryItem(user_id,"farda-speed",1)
                         end        
             elseif item == "fardaoff7" then
                       if vRP.tryGetInventoryItem(user_id,"nill",1) then
                                         
                                                 --TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
                       else
                          TriggerClientEvent("inventory:fardaoff",source)
                          TriggerClientEvent("itensNotify",source,"usar","Equipou",""..item.."")
                          vRP.tryGetInventoryItem(user_id,"fardaoff7",1)
                          vRP.giveInventoryItem(user_id,"farda-gtm",1)
                       end    
             elseif item == "fardaoff8" then
                   if vRP.tryGetInventoryItem(user_id,"nill",1) then
                                          
                                                  --TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
                      else
                        TriggerClientEvent("inventory:fardaoff",source)
                        TriggerClientEvent("itensNotify",source,"usar","Equipou",""..item.."")
                        vRP.tryGetInventoryItem(user_id,"fardaoff8",1)
                        vRP.giveInventoryItem(user_id,"farda-graer",1)
                     end       
             elseif item == "fardaoff9" then
                   if vRP.tryGetInventoryItem(user_id,"nill",1) then
                                               
                                                       --TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
                     else
                      TriggerClientEvent("inventory:fardaoff",source)
                      TriggerClientEvent("itensNotify",source,"usar","Equipou",""..item.."")
                      vRP.tryGetInventoryItem(user_id,"fardaoff9",1)
                      vRP.giveInventoryItem(user_id,"farda-got",1)
                   end  
            elseif item == "fardaoff10" then
                  if vRP.tryGetInventoryItem(user_id,"nill",1) then
                                                
                                                        --TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
                     else
                      TriggerClientEvent("inventory:fardaoff",source)
                      TriggerClientEvent("itensNotify",source,"usar","Equipou",""..item.."")
                      vRP.tryGetInventoryItem(user_id,"fardaoff10",1)
                      vRP.giveInventoryItem(user_id,"farda-medico",1)
                 end   
             elseif item == "fardaoff11" then
                   if vRP.tryGetInventoryItem(user_id,"nill",1) then
                                                  
                                                          --TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
                  else
                      TriggerClientEvent("inventory:fardaoff",source)
                      TriggerClientEvent("itensNotify",source,"usar","Equipou",""..item.."")
                      vRP.tryGetInventoryItem(user_id,"fardaoff11",1)
                      vRP.giveInventoryItem(user_id,"farda-enfermeiro",1)
                end                                     

  --   fardaoff8

            elseif item == "cordas" then
                           if vRP.tryGetInventoryItem(user_id,"nill",1) then
                                                    
                            --TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
                            else
                                   TriggerClientEvent("carregarcomcordas",source)
                           end
           


        elseif item == "notebook" then
            if vRPclient.isInVehicle(source) then
                local vehicle,vnetid,placa,vname,lock,banned = vRPclient.vehList(source,7)
                if vehicle and placa then
                    actived[user_id] = true
                    vGARAGE.freezeVehicleNotebook(source,vehicle)
                    TriggerClientEvent('cancelando',source,true)
                    TriggerClientEvent("progress",source,59500,"removendo rastreador")
                    SetTimeout(60000,function()
                        actived[user_id] = nil
                        TriggerClientEvent('cancelando',source,false)
                        local placa_user_id = vRP.getUserByRegistration(placa)
                        if placa_user_id then
                            local player = vRP.getUserSource(placa_user_id)
                            if player then
                                vGARAGE.removeGpsVehicle(player,vname)
                            end
                        end
                    end)
                end
            end
        elseif item == "placa" then
            if vRPclient.GetVehicleSeat(source) then
                if vRP.tryGetInventoryItem(user_id,"placa",1,slot) then
                    local placa = vRP.generatePlate()
                    dPNclient.updateInventory(source)
                    TriggerClientEvent('cancelando',source,true)
                    TriggerClientEvent("vehicleanchor",source)
                    TriggerClientEvent("progress",source,59500,"clonando")
                    SetTimeout(60000,function()
                        TriggerClientEvent('cancelando',source,false)
                        TriggerClientEvent("cloneplates",source,placa)
                        TriggerClientEvent("Notify",source,"sucesso","Placa clonada com sucesso.",8000)
                    end)
                end
            end    
        elseif item == "colete" then
            if vRP.tryGetInventoryItem(user_id,"colete",1,slot) then
                vRPclient.setArmour(source,200)
                dPNclient.updateInventory(source)
            end	
        end    
    end        
end