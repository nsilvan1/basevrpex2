-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
faR = {}
Tunnel.bindInterface("farm_coleta",faR)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSAO 
-----------------------------------------------------------------------------------------------------------------------------------------
function faR.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"thelost.permissao") or vRP.hasPermission(user_id,"mafia.permissao") 
		or vRP.hasPermission(user_id,"bahamas.permissao") or vRP.hasPermission(user_id,"vanilla.permissao") 
		or vRP.hasPermission(user_id,"verdes.permissao") or vRP.hasPermission(user_id,"vermelhos.permissao") 
		or vRP.hasPermission(user_id,"azuis.permissao") or vRP.hasPermission(user_id,"roxos.permissao") 
		or vRP.hasPermission(user_id,"laranjas.permissao") or vRP.hasPermission(user_id,"hells.permissao") 
		or vRP.hasPermission(user_id,"anonymous.permissao") or vRP.hasPermission(user_id,"cartel.permissao")
		or vRP.hasPermission(user_id,"vagos.permissao") then
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Você não tem acesso.")
			return false
		end						
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK PAGAMENTO 
-----------------------------------------------------------------------------------------------------------------------------------------
function faR.checkPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"vagos.permissao") then
			local itens = math.random(100)
			local quantidade = math.random(2,3)
			if itens <= 100 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("dietilamina")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(2,3)
					vRP.giveInventoryItem( user_id,"dietilamina",quantidade)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x dietilamina.</b>")
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end	

		elseif vRP.hasPermission(user_id,"cartel.permissao") then
			local itens = math.random(100)
			local quantidade = math.random(2,3)
			if itens <= 100 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("fibra")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(5,10)
					vRP.giveInventoryItem( user_id,"fibra",quantidade)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x fibras.</b>")
					quantidade = math.random(5,10)
					vRP.giveInventoryItem( user_id,"aco",quantidade)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x aços.</b>")
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end			

		elseif vRP.hasPermission(user_id,"laranjas.permissao") then
			local itens = math.random(100)
			local quantidade = math.random(2,3)
			if itens <= 100 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("aco")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(5,10)
					vRP.giveInventoryItem( user_id,"aco",quantidade)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x aços.</b>")
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end	

		elseif vRP.hasPermission(user_id,"thelost.permissao") then
			local itens = math.random(100)
			local quantidade = math.random(2,4)
			local pagamento = math.random(2000,5000)
			if itens <= 100 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("aco")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(2,4)
					vRP.giveInventoryItem( user_id,"aco",quantidade)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x aços.</b>")
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end	

		elseif vRP.hasPermission(user_id,"mafia.permissao") then
			local itens = math.random(100)
			local quantidade = math.random(2,4)
			local pagamento = math.random(2000,5000)
			if itens <= 100 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("polvora")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(5,10)
					vRP.giveInventoryItem( user_id,"polvora",quantidade)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x polvora de Arma.</b>")
					if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("capsula")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
						quantidade = math.random(0,2)
					   vRP.giveInventoryItem( user_id,"capsula",quantidade)
					   TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x capsula de Arma.</b>")
					end	
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end	

		-- elseif vRP.hasPermission(user_id,"triade.permissao") then
		-- 	local itens = math.random(100)
		-- 	local quantidade = math.random(5,6)
		-- 	local pagamento = math.random(2000,5000)
		-- 	if itens <= 100 then
		-- 		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("polvora")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
		-- 			quantidade = math.random(5,6)
		-- 			vRP.giveInventoryItem( user_id,"polvora",quantidade)
		-- 			TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Polvora.</b>")
		-- 		else
		-- 			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
		-- 		end
		-- 	end

		-- elseif vRP.hasPermission(user_id,"native.permissao") then
		-- 	local itens = math.random(100)
		-- 	local quantidade = math.random(5,6)
		-- 	local pagamento = math.random(2000,5000)
		-- 	if itens <= 100 then
		-- 		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("polvora")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
		-- 			quantidade = math.random(5,6)
		-- 			vRP.giveInventoryItem( user_id,"polvora",quantidade)
		-- 			TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Polvora.</b>")
		-- 		else
		-- 			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
		-- 		end
		-- 	end

		-- elseif vRP.hasPermission(user_id,"contrabando.permissao") then
		-- 	local itens = math.random(100)
		-- 	local quantidade = math.random(1,6)
		-- 	local pagamento = math.random(2000,5000)
		-- 	if itens <= 100 then
		-- 		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("algemas")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
		-- 			quantidade = math.random(0,3)
		-- 			vRP.giveInventoryItem( user_id,"algemas",quantidade)
		-- 			TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Algemas.</b>")
		-- 		else
		-- 			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
		-- 		end
		-- 	end

		-- 	if itens > 26 and itens <= 100 then
		-- 		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("capuz")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
		-- 			quantidade = math.random(0,3)
		-- 			vRP.giveInventoryItem( user_id,"capuz",quantidade)
		-- 			TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Capuz.</b>")
		-- 		else
		-- 			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
		-- 		end
		-- 	end


		-- elseif vRP.hasPermission(user_id,"lavagem.permissao") then
		-- 	local itens = math.random(100)
		-- 	local quantidade = math.random(1,6)
		-- 	if itens <= 29 then
		-- 		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("detergenteneutro")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
		-- 			quantidade = math.random(0,6)
		-- 			vRP.giveInventoryItem( user_id,"detergenteneutro",quantidade)
		-- 			TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Detergente Neutro.</b>")
		-- 		else
		-- 			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
		-- 		end
		-- 	end

		-- if itens > 26 and itens <= 100 then
		-- 		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("agua")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
		-- 			quantidade = math.random(5,6)
		-- 			vRP.giveInventoryItem( user_id,"agua",quantidade)
		-- 			TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Agua.</b>")
		-- 		else
		-- 			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
		-- 		end
		-- 	end

		-- 	if itens > 26 and itens <= 100 then
		-- 		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("bicarbonatodesodio")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
		-- 			quantidade = math.random(5,6)
		-- 			vRP.giveInventoryItem( user_id,"bicarbonatodesodio",quantidade)
		-- 			TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Bicarbonato De Sodio.</b>")
		-- 		else
		-- 			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
		-- 		end
		-- 	end	

		-- 	if itens > 26 and itens <= 100 then
		-- 		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("vinagre")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
		-- 			quantidade = math.random(5,6)
		-- 			vRP.giveInventoryItem( user_id,"vinagre",quantidade)
		-- 			TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Vinagre.</b>")
		-- 		else
		-- 			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
		-- 		end
		-- 	end		
			
			
		-- elseif vRP.hasPermission(user_id,"lifeinvader.permissao") then
		-- 	local itens = math.random(100)
		-- 	local quantidade = math.random(5,6)
		-- 	if itens <= 29 then
		-- 		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("detergenteneutro")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
		-- 			quantidade = math.random(5,6)
		-- 			vRP.giveInventoryItem( user_id,"detergenteneutro",quantidade)
		-- 			TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Detergente Neutro.</b>")
		-- 		else
		-- 			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
		-- 		end
		-- 	end

		-- 	if itens > 26 and itens <= 100 then
		-- 		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("agua")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
		-- 			quantidade = math.random(5,6)
		-- 			vRP.giveInventoryItem( user_id,"agua",quantidade)
		-- 			TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Agua.</b>")
		-- 		else
		-- 			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
		-- 		end
		-- 	end

		-- 	if itens > 26 and itens <= 100 then
		-- 		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("bicarbonatodesodio")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
		-- 			quantidade = math.random(5,6)
		-- 			vRP.giveInventoryItem( user_id,"bicarbonatodesodio",quantidade)
		-- 			TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Bicarbonato De Sodio.</b>")
		-- 		else
		-- 			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
		-- 		end
		-- 	end	
			
		end
		return true			
	end
end