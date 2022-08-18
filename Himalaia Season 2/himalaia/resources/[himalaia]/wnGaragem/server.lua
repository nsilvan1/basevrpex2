local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
--[ CONEXÃO ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("wnGaragem",src)
vCLIENT = Tunnel.getInterface("wnGaragem")
local inventory = module("vrp","cfg/inventory")
local idgens = Tools.newIDGenerator()
-----------------------------------------------------------------------------------------------------------------------------------------
--[ PREPARE ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
vRP._prepare("creative/get_vehicle","SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id")
vRP._prepare("creative/rem_vehicle","DELETE FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("creative/get_vehicles","SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("creative/set_update_vehicles","UPDATE vrp_user_vehicles SET engine = @engine, body = @body, fuel = @fuel WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("creative/set_detido","UPDATE vrp_user_vehicles SET detido = @detido, time = @time WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("creative/set_ipva","UPDATE vrp_user_vehicles SET ipva = @ipva WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("creative/move_vehicle","UPDATE vrp_user_vehicles SET user_id = @nuser_id WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("creative/add_vehicle","INSERT IGNORE INTO vrp_user_vehicles(user_id,vehicle,ipva) VALUES(@user_id,@vehicle,@ipva)")
vRP._prepare("creative/con_maxvehs","SELECT COUNT(vehicle) as qtd FROM vrp_user_vehicles WHERE user_id = @user_id")
vRP._prepare("creative/rem_srv_data","DELETE FROM vrp_srv_data WHERE dkey = @dkey")
vRP._prepare("creative/get_estoque","SELECT * FROM vrp_estoque WHERE vehicle = @vehicle")
vRP._prepare("creative/set_estoque","UPDATE vrp_estoque SET quantidade = @quantidade WHERE vehicle = @vehicle")
vRP._prepare("creative/get_users","SELECT * FROM vrp_users WHERE id = @user_id") 
vRP._prepare("homes/get_caruser","SELECT * FROM vrp_user_vehicles WHERE vehicle = @vehicle AND user_id = @user_id AND permissao = 1")
-----------------------------------------------------------------------------------------------------------------------------------------
--[ WEBHOOK ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookadmin = ""
local webhookvehs = ""
local webhookdesmanche = ""

-----------------------------------------------------------------------------------------------------------------------------------------
--[ VARIAVEIS ]--------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local police = {}
local vehlist = {}
local trydoors = {}
trydoors["CLONADOS"] = true
trydoors["CREATIVE"] = true
-----------------------------------------------------------------------------------------------------------------------------------------
--[ RETURNVEHICLESEVERYONE ]-------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function src.returnVehicleEveryone(placa)
	return trydoors[placa]
end

function src.addTrust(id,veiculoId)
    local source = source
    local user_id = vRP.getUserId(source)
    local idEmprestado = id
    local vehiclEmprestado = veiculoId
    if vRP.vehicleRental(veiculoId) ~= "aluguel" and vRP.vehicleType(veiculoId) ~= "work" then
        vRP.query("warn/set_key",{ emprestado = idEmprestado, vehicle = vehiclEmprestado, user_id = user_id })
    else
        return false
    end
end

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
--[ SETPLATEEVERYONE ]-------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("setPlateEveryone")
AddEventHandler("setPlateEveryone",function(placa)
	trydoors[placa] = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ MYVEHICLES ]-------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function src.myVehicles(work)
	local source = source
	local user_id = vRP.getUserId(source)
	local myvehicles = {}
	local ipva = ""
	local status = ""
	if user_id then
		if workgarage[work] then
			for k,v in pairs(workgarage) do
				if k == work then
					for k2,v2 in pairs(v) do
						status = "<span class=\"green\">"..k.."</span>"
						ipva = "<span class=\"green\">Pago</span>"
						table.insert(myvehicles,{ name = v2, name2 = vRP.vehicleName(v2), engine = 100, body = 100, fuel = 100, status = status, ipva = ipva })
					end
				end
			end
			return myvehicles
		else
			local vehicle = vRP.query("creative/get_vehicle",{ user_id = parseInt(user_id) })
			local address = vRP.query("homes/get_homeuserid",{ user_id = parseInt(user_id) })
			if #address > 0 then
				for k,v in pairs(address) do
					if v.home == work then
						for k2,v2 in pairs(vehicle) do
							if parseInt(os.time()) <= parseInt(vehicle[k2].time+24*60*60) then
								status = "<span class=\"red\">$"..vRP.format(parseInt(vRP.vehiclePrice(vehicle[k2].vehicle)*0.5)).."</span>"
							elseif vehicle[k2].detido == 1 then
								status = "<span class=\"orange\">$"..vRP.format(parseInt(vRP.vehiclePrice(vehicle[k2].vehicle)*0.1)).."</span>"
							else
								status = "<span class=\"green\">Gratuita</span>"
							end

							if parseInt(os.time()) >= parseInt(vehicle[k2].ipva+24*15*60*60) then
								ipva = "<span class=\"red\">Atrasado</span>"
							else
								ipva = "<span class=\"green\">Pago</span>"
							end
							table.insert(myvehicles,{ name = vehicle[k2].vehicle, name2 = vRP.vehicleName(vehicle[k2].vehicle), engine = parseInt(vehicle[k2].engine*0.1), body = parseInt(vehicle[k2].body*0.1), fuel = parseInt(vehicle[k2].fuel), status = status, ipva = ipva })
						end
						return myvehicles
					else
						for k2,v2 in pairs(vehicle) do
							if parseInt(os.time()) <= parseInt(vehicle[k2].time+24*60*60) then
								status = "<span class=\"red\">$"..vRP.format(parseInt(vRP.vehiclePrice(vehicle[k2].vehicle)*0.5)).."</span>"
							elseif vehicle[k2].detido == 1 then
								status = "<span class=\"orange\">$"..vRP.format(parseInt(vRP.vehiclePrice(vehicle[k2].vehicle)*0.1)).."</span>"
							else
								status = "<span class=\"green\">$"..vRP.format(parseInt(vRP.vehiclePrice(vehicle[k2].vehicle)*0.005)).."</span>"
							end

							if parseInt(os.time()) >= parseInt(vehicle[k2].ipva+24*15*60*60) then
								ipva = "<span class=\"red\">Atrasado</span>"
							else
								ipva = "<span class=\"green\">Pago</span>"
							end
							table.insert(myvehicles,{ name = vehicle[k2].vehicle, name2 = vRP.vehicleName(vehicle[k2].vehicle), engine = parseInt(vehicle[k2].engine*0.1), body = parseInt(vehicle[k2].body*0.1), fuel = parseInt(vehicle[k2].fuel), status = status, ipva = ipva })
						end
						return myvehicles
					end
				end
			else
				for k,v in pairs(vehicle) do
					if parseInt(os.time()) <= parseInt(vehicle[k].time+24*60*60) then
						status = "<span class=\"red\">$"..vRP.format(parseInt(vRP.vehiclePrice(vehicle[k].vehicle)*0.5)).."</span>"
					elseif vehicle[k].detido == 1 then
						status = "<span class=\"orange\">$"..vRP.format(parseInt(vRP.vehiclePrice(vehicle[k].vehicle)*0.1)).."</span>"
					else
						status = "<span class=\"green\">$"..vRP.format(parseInt(vRP.vehiclePrice(vehicle[k].vehicle)*0.005)).."</span>"
					end

					if parseInt(os.time()) >= parseInt(vehicle[k].ipva+24*15*60*60) then
						ipva = "<span class=\"red\">Atrasado</span>"
					else
						ipva = "<span class=\"green\">Pago</span>"
					end
					table.insert(myvehicles,{ name = vehicle[k].vehicle, name2 = vRP.vehicleName(vehicle[k].vehicle), engine = parseInt(vehicle[k].engine*0.1), body = parseInt(vehicle[k].body*0.1), fuel = parseInt(vehicle[k].fuel), status = status, ipva = ipva })
				end
				return myvehicles
			end
		end
	end
end

RegisterServerEvent("desmancheVehicles")
AddEventHandler("desmancheVehicles",function()
	local source = source
	local user_id = vRP.getUserId(source)

	
	if user_id then
	
		local vehicle,vnetid,placa,vname,lock,banned = vRPclient.vehList(source,7)
		
		print(vehicle,vnetid,placa,vname,lock,banned)
		if vehicle and placa then
		
			local puser_id = vRP.getUserByRegistration(placa)
		
			if puser_id then
			
				vRP.execute("creative/set_detido",{ user_id = parseInt(puser_id), vehicle = vname, detido = 1, time = parseInt(os.time()) })
				vRP.giveInventoryItem(user_id,"dinheirosujo",parseInt(vRP.vehiclePrice(vname)*0.10))
				vCLIENT.deleteVehicle(source,vehicle)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ SPAWNVEHICLES ]----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function src.spawnVehicles(name,use)
	if name then
		local source = source
		local user_id = vRP.getUserId(source)
		if user_id then
			local identity = vRP.getUserIdentity(user_id)
			local value = vRP.getUData(parseInt(user_id),"vRP:multas")
			local multas = json.decode(value) or 0
			if multas >= 10000 then
				TriggerClientEvent("Notify",source,"negado","Você tem multas pendentes.",10000)
				return true
			end
			if not vCLIENT.returnVehicle(source,name) then
				local vehicle = vRP.query("creative/get_vehicles",{ user_id = parseInt(user_id), vehicle = name })
				local tuning = vRP.getSData("custom:u"..user_id.."veh_"..name) or {}
				local custom = json.decode(tuning) or {}
				if vehicle[1] ~= nil then
					if parseInt(os.time()) <= parseInt(vehicle[1].time+24*60*60) then
						local ok = vRP.request(source,"Veículo na retenção, deseja acionar o seguro pagando <b>$"..vRP.format(parseInt(vRP.vehiclePrice(name)*0.2)).."</b> dólares ?",60)
						if ok then
							if vRP.tryFullPayment(user_id,parseInt(vRP.vehiclePrice(name)*0.2)) then
								vRP.execute("creative/set_detido",{ user_id = parseInt(user_id), vehicle = name, detido = 0, time = 0 })
								TriggerClientEvent("Notify",source,"sucesso","Veículo liberado.",10000)
							else
								TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",10000)
							end
						end
					elseif parseInt(vehicle[1].detido) >= 1 then
						local ok = vRP.request(source,"Veículo na detenção, deseja acionar o seguro pagando <b>$"..vRP.format(parseInt(vRP.vehiclePrice(name)*0.1)).."</b> dólares ?",60)
						if ok then
							if vRP.tryFullPayment(user_id,parseInt(vRP.vehiclePrice(name)*0.1)) then
								vRP.execute("creative/set_detido",{ user_id = parseInt(user_id), vehicle = name, detido = 0, time = 0 })
								TriggerClientEvent("Notify",source,"sucesso","Veículo liberado.",10000)
							else
								TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",10000)
							end
						end
					else
						if parseInt(os.time()) <= parseInt(vehicle[1].ipva+24*15*60*60) then
							if garages[use].payment then
								if vRP.vehicleType(tostring(name)) == "exclusive" or vRP.vehicleType(tostring(name)) == "rental" then
									local spawnveh,vehid = vCLIENT.spawnVehicle(source,name,vehicle[1].engine,vehicle[1].body,vehicle[1].fuel,custom)
									vehlist[vehid] = { parseInt(user_id),name }
									TriggerEvent("setPlateEveryone",identity.registration)
									TriggerClientEvent("Notify",source,"sucesso","Veículo <b>Exclusivo ou Alugado</b>, Não será cobrado a taxa de liberação.",10000)
								end
								if (vRP.getBankMoney(user_id)+vRP.getMoney(user_id)) >= parseInt(vRP.vehiclePrice(name)*0.005 and not vRP.vehicleType(tostring(name)) == "exclusive" or vRP.vehicleType(tostring(name)) == "rental") then
									local spawnveh,vehid = vCLIENT.spawnVehicle(source,name,vehicle[1].engine,vehicle[1].body,vehicle[1].fuel,custom)
									if spawnveh and vRP.tryFullPayment(user_id,parseInt(vRP.vehiclePrice(name)*0.005)) then
										vehlist[vehid] = { parseInt(user_id),name }
										TriggerEvent("setPlateEveryone",identity.registration)
									end
								else
									TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",10000)
								end
							else
								local spawnveh,vehid = vCLIENT.spawnVehicle(source,name,vehicle[1].engine,vehicle[1].body,vehicle[1].fuel,custom,parseInt(vehicle[1].colorR),parseInt(vehicle[1].colorG),parseInt(vehicle[1].colorB),parseInt(vehicle[1].color2R),parseInt(vehicle[1].color2G),parseInt(vehicle[1].color2B),false)
								if spawnveh then
									vehlist[vehid] = { user_id,name }
									TriggerEvent("setPlateEveryone",identity.registration)
								end
							end
						else
							if vRP.vehicleType(tostring(name)) == "exclusive" or vRP.vehicleType(tostring(name)) == "rental" then
								local ok = vRP.request(source,"Deseja pagar o <b>Vehicle Tax</b> do veículo <b>"..vRP.vehicleName(name).."</b> por <b>$"..vRP.format(parseInt(vRP.vehiclePrice(name)*0.00)).."</b> dólares?",60)
								if ok then
									if vRP.tryFullPayment(user_id,parseInt(vRP.vehiclePrice(name)*0.00)) then
										vRP.execute("creative/set_ipva",{ user_id = parseInt(user_id), vehicle = name, ipva = parseInt(os.time()) })
										TriggerClientEvent("Notify",source,"sucesso","Pagamento do <b>Vehicle Tax</b> conclúido com sucesso.",10000)
									else
										TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",10000)
									end
								end
							else
								local price_tax = parseInt(vRP.vehiclePrice(name)*0.10)
								if price_tax > 100000 then
									price_tax = 100000
								end
								local ok = vRP.request(source,"Deseja pagar o <b>Vehicle Tax</b> do veículo <b>"..vRP.vehicleName(name).."</b> por <b>$"..vRP.format(price_tax).."</b> dólares?",60)
								if ok then
									if vRP.tryFullPayment(user_id,price_tax) then
										vRP.execute("creative/set_ipva",{ user_id = parseInt(user_id), vehicle = name, ipva = parseInt(os.time()) })
										TriggerClientEvent("Notify",source,"sucesso","Pagamento do <b>Vehicle Tax</b> conclúido com sucesso.",10000)
									else
										TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",10000)
									end
								end
							end
						end
					end
				else
					local spawnveh,vehid = vCLIENT.spawnVehicle(source,name,1000,1000,100,custom,0,0,0,0,0,0,true)
					if spawnveh then
						vehlist[vehid] = { user_id,name }
						TriggerEvent("setPlateEveryone",identity.registration)
					end
				end
			else
				TriggerClientEvent("Notify",source,"aviso","Já possui um veículo deste modelo fora da garagem.",10000)
			end
		end
	end
end

function src.registerSubSolo(name,spawnveh,vehid)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.getUserIdentity(user_id)
		if spawnveh then
			vehlist[vehid] = { user_id,name }
			TriggerEvent("setPlateEveryone",identity.registration)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
--[ DELETEVEHICLES ]---------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function src.deleteVehicles()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle = vRPclient.getNearestVehicle(source,30)
		if vehicle then
			vCLIENT.deleteVehicle(source,vehicle)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
--[ VEHPRICE ]---------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function src.Desmanchar()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle,vnetid,placa,vname,lock,banned = vRPclient.vehList(source,7)
		if vehicle and placa then
			local puser_id = vRP.getUserByRegistration(placa)
			if puser_id then
				vRP.execute("creative/set_detido",{ user_id = parseInt(puser_id), vehicle = vname, detido = 1, time = parseInt(os.time()) })
				vRP.giveInventoryItem(user_id,"dinheirosujo",parseInt(vRP.vehiclePrice(vname)*0.1))
				vCLIENT.deleteVehicle(source,vehicle)
				local identity = vRP.getUserIdentity(user_id)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
--[ DV ]---------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('dv',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"suporte.permissao") or vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"yts.permissao") or vRP.hasPermission(user_id,"polpar.permissao") or vRP.hasPermission(user_id,"hawaii.permissao") or vRP.hasPermission(user_id,"mecanico.permissao") or vRP.hasPermission(user_id,"ouro.permissao") or vRP.hasPermission(user_id,"platina.permissao") then
		local vehicle = vRPclient.getNearestVehicle(source,7)
		if vehicle then
			vCLIENT.deleteVehicle(source,vehicle)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLELOCK
-----------------------------------------------------------------------------------------------------------------------------------------

local carkeys = {}
local webhookchaves = "" -- webhook quando alguem adiciona/remove chaves

function src.vehicleLock()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		
		local vehicle,vnetid,placa,vname,lock,banned = vRPclient.vehList(source,7)
		local placa_user = vRP.getUserByRegistration(placa)
		
		if vehicle and placa_user then
						
			if (user_id == placa_user) or (user_id == carkeys[vnetid]) then
				
				vCLIENT.vehicleClientLock(-1,vnetid,lock)
				
				TriggerClientEvent("vrp_sound:source",source,'lock',0.5)
				vRPclient.playAnim(source,true,{{"anim@mp_player_intmenu@key_fob@","fob_click"}},false)
				
				if lock == 1 then
					TriggerClientEvent("Notify",source,"importante","Veículo <b>trancado</b> com sucesso.",8000)
				else
					TriggerClientEvent("Notify",source,"importante","Veículo <b>destrancado</b> com sucesso.",8000)
				end
				
			end
		end
	end
end

RegisterCommand('darchaves',function(source,args,rawCMD)
	local source = source
	local user_id = vRP.getUserId(source)
	local idt = vRP.getUserIdentity(nuser_id)

	local vehicle,vnetid,placa,vname,lock,banned = vRPclient.vehList(source,3)	
	local nsrc = vRPclient.getNearestPlayer(source,2)
	local placa_user = vRP.getUserByRegistration(placa)

	if nsrc then
		local nuser_id = vRP.getUserId(nsrc)	
		if (placa_user == user_id) then
			local idt2 = vRP.getUserIdentity(nuser_id)
			local ok = vRP.request(source,"Dar a Chave Reserva do veiculo <b>"..vRP.vehicleName(vname).."</b> para <b>"..idt2.name.." "..idt2.firstname.."</b> ?",20)
			if ok then
				carkeys[vnetid] = nuser_id
				TriggerClientEvent("Notify",source,"importante","Deu a Chave Reserva do veiculo <b>"..vRP.vehicleName(vname).."</b> para <b>"..idt2.name.." "..idt2.firstname.."</b>.",8000)
				TriggerClientEvent("Notify",nsrc,"importante","Recebeu a Chave Reserva do veiculo <b>"..vRP.vehicleName(vname).."</b> de <b>"..idt.name.." "..idt.firstname.."</b>.",8000)
				SendWebhookMessage(webhookchaves,"```prolog\n[ID]: "..user_id.." "..idt.name.." "..idt.firstname.." \n[EMPRESTOU CHAVE RESERVA]: "..vRP.vehicleName(vname).." \n[PARA]: "..nuser_id.." "..idt2.name.." "..idt2.firstname..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
	end
end)

RegisterCommand('removerchaves',function(source,args,rawCMD)
	local source = source
	local user_id = vRP.getUserId(source)
	local idt = vRP.getUserIdentity(nuser_id)

	local vehicle,vnetid,placa,vname,lock,banned = vRPclient.vehList(source,3)	
	local nsrc = vRPclient.getNearestPlayer(source,2)
	local placa_user = vRP.getUserByRegistration(placa)

	if nsrc then
		local nuser_id = vRP.getUserId(nsrc)	
		if (placa_user == user_id) then
			if (nuser_id == carkeys[vnetid]) then
				local idt2 = vRP.getUserIdentity(nuser_id)
				carkeys[vnetid] = nil
				TriggerClientEvent("Notify",source,"importante","Removeu a Chave Reserva do veiculo <b>"..vRP.vehicleName(vname).."</b> de <b>"..idt2.name.." "..idt2.firstname.."</b>.",8000)
				TriggerClientEvent("Notify",nsrc,"importante","Perdeu a Chave Reserva do veiculo <b>"..vRP.vehicleName(vname).."</b> de <b>"..idt.name.." "..idt.firstname.."</b>.",8000)
				SendWebhookMessage(webhookchaves,"```prolog\n[ID]: "..user_id.." "..idt.name.." "..idt.firstname.." \n[RECOLHEU CHAVE RESERVA]: "..vRP.vehicleName(vname).." \n[PARA]: "..nuser_id.." "..idt2.name.." "..idt2.firstname.."" ..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ TRYDELETE ]--------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function src.tryDelete(vehid,vehengine,vehbody,vehfuel)
	if vehlist[vehid] and vehid ~= 0 then
		local user_id = vehlist[vehid][1]
		local vehname = vehlist[vehid][2]
		local player = vRP.getUserSource(user_id)
		if player then
			vCLIENT.syncNameDelete(player,vehname)
		end

		if vehengine <= 100 then
			vehengine = 100
		end

		if vehbody <= 100 then
			vehbody = 100
		end

		if vehfuel >= 100 then
			vehfuel = 100
		end

		local vehicle = vRP.query("creative/get_vehicles",{ user_id = parseInt(user_id), vehicle = vehname })
		if vehicle[1] ~= nil then
			vRP.execute("creative/set_update_vehicles",{ user_id = parseInt(user_id), vehicle = vehname, engine = parseInt(vehengine), body = parseInt(vehbody), fuel = parseInt(vehfuel) })
		end
	end
	vCLIENT.syncVehicle(-1,vehid)
end
-----------------------------------------------------------------------------------------------------------------------------------------
--[ TRYDELETEVEH ]-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trydeleteveh")
AddEventHandler("trydeleteveh",function(vehid)
	vCLIENT.syncVehicle(-1,vehid)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ RETURNHOUSES ]-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function src.returnHouses(nome,garage)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.searchReturn(source,user_id) then
			local address = vRP.query("homes/get_homeuserid",{ user_id = parseInt(user_id) })
			if #address > 0 then
				for k,v in pairs(address) do
					if v.home == garages[garage].name then
						if parseInt(v.garage) == 1 then
							local resultOwner = vRP.query("homes/get_homeuseridowner",{ home = tostring(nome) })
							if resultOwner[1] then
								if parseInt(os.time()) >= parseInt(resultOwner[1].tax+24*15*60*60) then
									TriggerClientEvent("Notify",source,"aviso","A <b>Property Tax</b> da residência está atrasada.",10000)
									return false
								else
									vCLIENT.openGarage(source,nome,garage)
								end
							end
						end
					end
				end
			end
			if garages[garage].perm == "livre" then
				return vCLIENT.openGarage(source,nome,garage)
			elseif garages[garage].perm then
				if vRP.hasPermission (user_id,garages[garage].perm) then
					return vCLIENT.openGarage(source,nome,garage)
				end
			elseif garages[garage].public then
				return vCLIENT.openGarage(source,nome,garage)
			end
		end
		return false
	end
end




-----------------------------------------------------------------------------------------------------------------------------------------
--[ VEHICLE ANCORAR ]--------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('travar',function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission (user_id,"bcso.permissao") then
			if vRPclient.isInVehicle(source) then
				local vehicle,vnetid,placa,vname,lock,banned = vRPclient.vehList(source,7)
				if vehicle then
					TriggerClientEvent("progress",source,5000,"travar/destravar")
					SetTimeout(5000,function()
						vCLIENT.vehicleAnchor(source,vehicle)
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ BOAT ANCORAR ]-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ancorar',function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRPclient.isInVehicle(source) then
			local vehicle,vnetid,placa,vname,lock,banned = vRPclient.vehList(source,7)
			if vehicle then
				vCLIENT.boatAnchor(source,vehicle)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ POLICEALERT ]------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function src.policeAlert()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle,vnetid,placa,vname,lock,banned,trunk,model,street = vRPclient.vehList(source,7)
		if vehicle then
			if math.random(100) >= 50 then
				local policia = vRP.ObterUsuariosPorPermissao("bcso.permissao")
				local x,y,z = vRPclient.getPosition(source)
				for k,v in pairs(policia) do
					local player = vRP.getUserSource(parseInt(v))
					if player then
						async(function()
							local id = idgens:gen()
							TriggerClientEvent('chatMessage',player,"473",{64,64,255},"Roubo na ^1"..street.."^0 do veículo ^1"..model.."^0 de placa ^1"..placa.."^0 verifique o ocorrido.")
							police[id] = vRPclient.addBlip(player,x,y,z,304,3,"Ocorrência",0.6,false)
							SetTimeout(60000,function() vRPclient.removeBlip(player,police[id]) idgens:free(id) end)
						end)
					end
				end
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
--[ CAR ]--------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------


RegisterCommand('car',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.getUserIdentity(user_id)
		if vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"blips.permissao") or vRP.hasPermission(user_id,"yts.permissao") then
			if args[1] then
				TriggerClientEvent('spawnarveiculo',source,args[1])
				TriggerEvent("setPlateEveryone",identity.registration)
				SendWebhookMessage(webhookspawncar,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SPAWNOU]: "..args[1].."  "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ VEHS ]-------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('vehs',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if args[1] and parseInt(args[2]) > 0 then
			local nplayer = vRP.getUserSource(parseInt(args[2]))
			local myvehicles = vRP.query("creative/get_vehicles",{ user_id = parseInt(user_id), vehicle = tostring(args[1]) })
			if myvehicles[1] then
				if vRP.vehicleType(tostring(args[1])) == "exclusive" or vRP.vehicleType(tostring(args[1])) == "rental" and not vRP.hasPermission (user_id,"admin.permissao") then
					TriggerClientEvent("Notify",source,"negado","<b>"..vRP.vehicleName(tostring(args[1])).."</b> não pode ser transferido por ser um veículo <b>Exclusivo ou Alugado</b>.",10000)
				else
					local identity = vRP.getUserIdentity(parseInt(args[2]))
					local identity2 = vRP.getUserIdentity(user_id)
					local price = tonumber(sanitizeString(vRP.prompt(source,"Valor:",""),"\"[]{}+=?!_()#@%/\\|,.",false))			
					if vRP.request(source,"Deseja vender um <b>"..vRP.vehicleName(tostring(args[1])).."</b> para <b>"..identity.name.." "..identity.firstname.."</b> por <b>$"..vRP.format(parseInt(price)).."</b> dólares ?",30) then	
						if vRP.request(nplayer,"Aceita comprar um <b>"..vRP.vehicleName(tostring(args[1])).."</b> de <b>"..identity2.name.." "..identity2.firstname.."</b> por <b>$"..vRP.format(parseInt(price)).."</b> dólares ?",30) then
							local vehicle = vRP.query("creative/get_vehicles",{ user_id = parseInt(args[2]), vehicle = tostring(args[1]) })
							if parseInt(price) > 0 then
								if vRP.tryFullPayment(parseInt(args[2]),parseInt(price)) then
									if vehicle[1] then
										TriggerClientEvent("Notify",source,"negado","<b>"..identity.name.." "..identity.firstname.."</b> já possui este modelo de veículo.",10000)
									else
										vRP.execute("creative/move_vehicle",{ user_id = parseInt(user_id), nuser_id = parseInt(args[2]), vehicle = tostring(args[1]) })

										local custom = vRP.getSData("custom:u"..parseInt(user_id).."veh_"..tostring(args[1]))
										local custom2 = json.decode(custom)
										if custom2 then
											vRP.setSData("custom:u"..parseInt(args[2]).."veh_"..tostring(args[1]),json.encode(custom2))
											vRP.execute("creative/rem_srv_data",{ dkey = "custom:u"..parseInt(user_id).."veh_"..tostring(args[1]) })
										end

										local chest = vRP.getSData("chest:u"..parseInt(user_id).."veh_"..tostring(args[1]))
										local chest2 = json.decode(chest)
										if chest2 then
											vRP.setSData("chest:u"..parseInt(args[2]).."veh_"..tostring(args[1]),json.encode(chest2))
											vRP.execute("creative/rem_srv_data",{ dkey = "chest:u"..parseInt(user_id).."veh_"..tostring(args[1]) })
										end

										TriggerClientEvent("Notify",source,"sucesso","Você Vendeu <b>"..vRP.vehicleName(tostring(args[1])).."</b> e Recebeu <b>$"..vRP.format(parseInt(price)).."</b> dólares.",20000)
										TriggerClientEvent("Notify",nplayer,"importante","Você recebeu as chaves do veículo <b>"..vRP.vehicleName(tostring(args[1])).."</b> de <b>"..identity2.name.." "..identity2.firstname.."</b> e pagou <b>$"..vRP.format(parseInt(price)).."</b> dólares.",40000)
											vRPclient.playSound(source,"Hack_Success","DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
											vRPclient.playSound(nplayer,"Hack_Success","DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
											-- local consulta = vRP.getUData(user_id,"vRP:paypal")
											-- local resultado = json.decode(consulta) or 0
											vRP.GivarDinheiro(user_id,parseInt(price))
											-- vRP.setUData(user_id,"vRP:paypal",json.encode(parseInt(resultado + price)))
											SendWebhookMessage(webhookvehs,"```prolog\n[ID]: "..user_id.." "..identity2.name.." "..identity2.firstname.." \n[VENDEU]: "..vRP.vehicleName(tostring(args[1])).." \n[PARA]: "..(args[2]).." "..identity.name.." "..identity.firstname.." \n[VALOR]: $"..vRP.format(parseInt(price)).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
										end
									else
										TriggerClientEvent("Notify",nplayer,"negado","Dinheiro insuficiente.",8000)
										TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",8000)
									end
								end	
							end
						end
					end
				end
			else
				local vehicle = vRP.query("creative/get_vehicle",{ user_id = parseInt(user_id) })
				if #vehicle > 0 then 
	                local car_names = {}
	                for k,v in pairs(vehicle) do
	                	table.insert(car_names, "<b>" .. vRP.vehicleName(v.vehicle) .. "</b> ("..v.vehicle..")")
	                    --TriggerClientEvent("Notify",source,"importante","<b>Modelo:</b> "..v.vehicle,10000)
	                end
	                car_names = table.concat(car_names, ", ")
	                TriggerClientEvent("Notify",source,"importante","Seus veículos: " .. car_names, 20000)
				else 
					TriggerClientEvent("Notify",source,"importante","Você não possui nenhum veículo.",20000)
				end
			end
		end
	end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ REPARAR ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("tryreparar")
AddEventHandler("tryreparar",function(nveh)
	TriggerClientEvent("syncreparar",-1,nveh)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ MOTOR ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trymotor")
AddEventHandler("trymotor",function(nveh)
	TriggerClientEvent("syncmotor",-1,nveh)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ SAVELIVERY ]-------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('savelivery',function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission (user_id,"owner.permissao") or vRP.hasPermission (user_id,"admin.permissao") then
		local vehicle,vnetid,placa,vname = vRPclient.vehList(source,7)
		if vehicle and placa then
			local puser_id = vRP.getUserByRegistration(placa)
			if puser_id then
				local custom = json.decode(vRP.getSData("custom:u"..parseInt(puser_id).."veh_"..vname))
				local livery = vCLIENT.returnlivery(source,livery)
				custom.liveries = livery
				print(json.encode(custom))
				vRP.setSData("custom:u"..parseInt(puser_id).."veh_"..vname,json.encode(custom))	
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ CHECK LIVERY PERMISSION ]------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function src.CheckLiveryPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission (user_id,"admin.permissao") 
end
-----------------------------------------------------------------------------------------------------------------------------------------
--[ HASH ]-------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('hash',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission (user_id,"hash.permissao") or vRP.hasPermission (user_id,"admin.permissao") then
        local vehassh = vCLIENT.getHash(source,vehiclehash)
        vRP.prompt(source,"Hash:",""..vehassh)
    end
end)