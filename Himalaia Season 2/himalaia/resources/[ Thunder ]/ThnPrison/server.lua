local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
func = {}
Tunnel.bindInterface(GetCurrentResourceName(),func)

local webhookprender = "https://discord.com/api/webhooks//LMoFcqp7a-n6uu9mMy7lDWtMxFjI4pl64kt9ukg_3NiScqRvYSg6VgQVV9GBIKvkyI3i"

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

function func.receberLanche()
	local source = source
	local user_id = vRP.getUserId(source)
	vRP.giveInventoryItem(user_id,'donut',2)
	vRP.giveInventoryItem(user_id,'agua',2)
end

local celas = {
	{ ['x'] = 1761.21, ['y'] = 2475.15, ['z'] = 45.82, ["cela"] = 1, ['lock'] = true},
}

RegisterServerEvent("openCela")
AddEventHandler("openCela",function(cela)
	print(cela)
	local cela2 = false
	for k,v in pairs(celas) do
		if v.cela == cela then
			v.lock = false
			cela2 = true
		end
	end
	if cela2 == true then
		print('A cela: '..cela..' foi liberada')
	end
end)

function obtercela()
	for k,v in pairs(celas) do
		if v.lock == false then
			v.lock = true
			return {["x"] = v.x, ["y"] = v.y, ["z"] = v.z, ['cela'] = v.cela}
		end
	end
	return {["x"] = 1786.7604980469, ["y"] = 2569.3186035156, ["z"] = 45.708374023438, ["cela"] = 1}
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ PRENDER ]------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('prender',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"mindmasater.permissao") or vRP.hasPermission(user_id,"administrador.permissao") or vRP.hasPermission(user_id,"policia.permissao") then
		local crimes = vRP.prompt(source,"Crimes:","")
		if crimes == "" then
			return
		end

		local player = vRP.getUserSource(parseInt(args[1]))
		if player then
			local value = vRP.getUData(parseInt(target_id),"vRP:prisao")
			local tempo = json.decode(value) or 0
			if tempo == 0 then
				vRP.setUData(parseInt(args[1]),"vRP:prisao",json.encode(parseInt(args[2])))
				vRPclient.setHandcuffed(player,false)
				local coordenada = obtercela()
				TriggerClientEvent('prisioneiro',player,true,coordenada)
				local old_custom = vRPclient.getCustomization(player)
				local custom = {
					[1885233650] = {
						[1] = { -1,0 }, -- máscara
						[3] = { 0,0 }, -- maos
						[4] = { 5,7 }, -- calça
						[5] = { -1,0 }, -- mochila
						[6] = { 5,2 }, -- sapato
						[7] = { -1,0 },  -- acessorios
						[8] = { -1,0 }, -- blusa
						[9] = { -1,0 }, -- colete
						[10] = { -1,0 }, -- adesivo
						[11] = { 22,0 }, -- jaqueta	
						["p0"] = { -1,0 }, -- chapeu
						["p1"] = { -1,0 },
						["p2"] = { -1,0 },
						["p6"] = { -1,0 },
						["p7"] = { -1,0 }
					},
					[-1667301416] = {
						[1] = { -1,0 },
						[3] = { 14,0 },
						[4] = { 66,6 },
						[5] = { -1,0 },
						[6] = { 5,0 },
						[7] = { -1,0 },
						[8] = { 6,0 },
						[9] = { -1,0 },
						[10] = { -1,0 },
						[11] = { 73,0 },
						["p0"] = { -1,0 },
						["p1"] = { -1,0 },
						["p2"] = { -1,0 },
						["p6"] = { -1,0 },
						["p7"] = { -1,0 }
					}
				}

				local idle_copy = {}
				idle_copy.modelhash = nil
				for l,w in pairs(custom[old_custom.modelhash]) do
					idle_copy[l] = w
				end
				vRPclient._setCustomization(player, idle_copy)
				prison_lock(parseInt(args[1]))
				TriggerClientEvent('removealgemas',player)
				TriggerClientEvent("vrp_sound:source",player,'jaildoor',0.7)
				TriggerClientEvent("vrp_sound:source",source,'jaildoor',0.7)
				local oficialid = vRP.getUserIdentity(user_id)
				local identity = vRP.getUserIdentity(parseInt(args[1]))
				local nplayer = vRP.getUserSource(parseInt(args[1]))
				SendWebhookMessage(webhookprender,"```prolog\n[OFICIAL]: "..user_id.." "..oficialid.name.." "..oficialid.firstname.." \n[==============PRENDEU==============] \n[PASSAPORTE]: "..(args[1]).." "..identity.name.." "..identity.firstname.." \n[TEMPO]: "..vRP.format(parseInt(args[2])).." Meses \n[CRIMES]: "..crimes.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				randmoney = math.random(4000,8000)
				vRP.giveMoney(user_id,parseInt(randmoney))
				TriggerClientEvent("Notify",source,"sucesso","Prisão efetuada com sucesso.")
				TriggerClientEvent("Notify",source,"importante","Você recebeu <b>$"..vRP.format(parseInt(randmoney)).." dólares</b> de bonificação.")
				TriggerClientEvent("Notify",nplayer,"importante","Você foi preso por <b>"..vRP.format(parseInt(args[2])).." meses</b>.<br><b>Motivo:</b> "..crimes..".")
				vRPclient.playSound(source,"Hack_Success","DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
			else
				TriggerClientEvent("Notify",source,"sucesso","O cidadão já está preso.")
			end
		end 
	end
end)

RegisterServerEvent("wjdiwjdiwdjiwdjwidjwidjwid")
AddEventHandler("wjdiwjdiwdjiwdjwidjwidjwid",function()
	local source = source
	local user_id = vRP.getUserId(source)
	local value = vRP.getUData(parseInt(user_id),"vRP:prisao")
	local tempo = json.decode(value) or 0
	if tempo >= 5 then
		vRP.setUData(parseInt(user_id),"vRP:prisao",json.encode(parseInt(tempo)-3))
		TriggerClientEvent("Notify",source,"importante","Sua pena foi reduzida em <b>3 meses</b>, continue o trabalho.")
	else
		TriggerClientEvent("Notify",source,"importante","Atingiu o limite da redução de pena, não precisa mais trabalhar.")
	end
end)

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	local player = vRP.getUserSource(parseInt(user_id))
	if player then
		SetTimeout(30000,function()
			local value = vRP.getUData(parseInt(user_id),"vRP:prisao")
			local tempo = json.decode(value) or -1
			if tempo == -1 then
				return
			end
			if tempo > 0 then
				local coordenada = obtercela()
				TriggerClientEvent('prisioneiro',player,true,coordenada)
				vRPclient.teleport(player,1680.1,2513.0,46.5)
				prison_lock(parseInt(user_id))
			end
		end)
	end
end)


function prison_lock(target_id)
	local player = vRP.getUserSource(parseInt(target_id))
	if player then
		SetTimeout(60000,function()
			local value = vRP.getUData(parseInt(target_id),"vRP:prisao")
			local tempo = json.decode(value) or 0
			if parseInt(tempo) >= 1 then
				TriggerClientEvent("Notify",player,"importante","Ainda vai passar <b>"..parseInt(tempo).." meses</b> preso.")
				vRP.setUData(parseInt(target_id),"vRP:prisao",json.encode(parseInt(tempo)-1))
				prison_lock(parseInt(target_id))
			elseif parseInt(tempo) == 0 then
				TriggerClientEvent('prisioneiro',player,false)
				vRPclient.teleport(player,1850.5,2604.0,45.5)
				vRP.setUData(parseInt(target_id),"vRP:prisao",json.encode(-1))
				TriggerClientEvent("Notify",player,"importante","Sua sentença terminou, esperamos não ve-lo novamente.")
			end
			vRPclient.PrisionGod(player)
		end)
	end
end
