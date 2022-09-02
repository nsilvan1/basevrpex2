local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

emP = {}
Tunnel.bindInterface("drugs_sell",emP)
local idgens = Tools.newIDGenerator()
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookdrugs = "https://discord.com/api/webhooks/895817268372570122/SEqckQG4EGBC9ePdwz1x_ebwlF4afuwglM3iXuemqykloCyAFuK0m2bLNmi95wfl-BYs"

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local pagamento = {}
local total = 0

local quantidade = {}

function emP.Quantidade()
	local source = source

	if quantidade[source] == nil then
	   quantidade[source] = math.random(10,15)	
	end

	TriggerClientEvent("quantidade-drogas",source,parseInt(quantidade[source]))
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryItemAmount(user_id, 'maconha') <= 0 and vRP.getInventoryItemAmount(user_id, 'cocaina') <= 0 
		and vRP.getInventoryItemAmount(user_id, 'metanfetamina') <= 0 and vRP.getInventoryItemAmount(user_id, 'heroin') <= 0 
		and vRP.getInventoryItemAmount(user_id, 'lancaperfume') <= 0 then
			TriggerClientEvent("Notify",source,"negado","Número insuficiente de <b>Drogas</b>.")
		else
			local policia = vRP.getUsersByPermission("policia.permissao")
			local valorDroga = math.random(300,410) 
				if #policia < 2 then 
					valorDroga = math.random(300,410) 
				elseif #policia >= 2 then
					valorDroga = math.random(400,510) 
				elseif #policia >= 4 then
					valorDroga = math.random(600,750) 
				elseif #policia >= 6 then
					valorDroga = math.random(800,950)
				elseif #policia >= 8 then
					valorDroga = math.random(1000,1200)
				end 

			local totalPagamento = 0
			if vRP.getInventoryItemAmount(user_id, 'maconha') >= quantidade[source] then
				if vRP.tryGetInventoryItem(user_id,"maconha",quantidade[source]) then
					total = parseInt(quantidade[source])
					pagamento[source] = valorDroga * total
					totalPagamento = totalPagamento + pagamento[source]
					TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
					vRPclient._playAnim(source, true, {{"mp_common","givetake1_a"}}, false)
				end
			end
			if vRP.getInventoryItemAmount(user_id, 'cocaina') >= quantidade[source] then
				if vRP.tryGetInventoryItem(user_id,"cocaina",quantidade[source]) then
					total = parseInt(quantidade[source])
					pagamento[source] = valorDroga * total
					totalPagamento = totalPagamento + pagamento[source]
					TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
					vRPclient._playAnim(source, true, {{"mp_common","givetake1_a"}}, false)
				end
			end
			if vRP.getInventoryItemAmount(user_id, 'metanfetamina') >= quantidade[source] then
				if vRP.tryGetInventoryItem(user_id,"metanfetamina",quantidade[source]) then
					total = parseInt(quantidade[source])
					pagamento[source] = valorDroga * total
					totalPagamento = totalPagamento + pagamento[source]
					TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
					vRPclient._playAnim(source, true, {{"mp_common","givetake1_a"}}, false)
				end
			end
			if vRP.getInventoryItemAmount(user_id, 'heroin') >= quantidade[source] then
				if vRP.tryGetInventoryItem(user_id,"heroin",quantidade[source]) then
					total = parseInt(quantidade[source])
					pagamento[source] = valorDroga * total
					totalPagamento = totalPagamento + pagamento[source]
					TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
					vRPclient._playAnim(source, true, {{"mp_common","givetake1_a"}}, false)
				end
			end
			if vRP.getInventoryItemAmount(user_id, 'lancaperfume') >= quantidade[source] then
				if vRP.tryGetInventoryItem(user_id,"lancaperfume",quantidade[source]) then
					total = parseInt(quantidade[source])
					pagamento[source] = valorDroga * total					
					totalPagamento = totalPagamento + pagamento[source]
					TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
					vRPclient._playAnim(source, true, {{"mp_common","givetake1_a"}}, false)
				end
			end
			if totalPagamento > 0 then
				vRP.giveInventoryItem(user_id, "dinheirosujo", totalPagamento)
				quantidade[source] = math.random(10,15)
				TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..totalPagamento.." rupia</b>.")
				return true
			end			
		end
	end
	return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICIA
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = {}
function emP.MarcarOcorrencia()
	local source = source
	local user_id = vRP.getUserId(source)
	local x,y,z = vRPclient.getPosition(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		local soldado = vRP.getUsersByPermission("policia.permissao")
		for l,w in pairs(soldado) do
			local player = vRP.getUserSource(parseInt(w))
			if player then
				async(function()
					local id = idgens:gen()
					blips[id] = vRPclient.addBlip(player,x,y,z,10,84,"Ocorrência",0.5,false)
					vRPclient._playSound(player,"CONFIRM_BEEP","HUD_MINI_GAME_SOUNDSET")
					TriggerClientEvent('chatMessage',player,"911 - ",{64,64,255},"Recebemos uma denuncia de tráfico, verifique o ocorrido.")
					SetTimeout(20000,function() vRPclient.removeBlip(player,blips[id]) idgens:free(id) end)
				end)
			end
		end
		PerformHttpRequest(webhookdrugs, function(err, text, headers) end, 'POST', json.encode({
			embeds = {
				{ 
					title = "REGISTRO DE DROGAS",
					thumbnail = {
					url = "LOGO DO SEU SERVIDOR"
					}, 
					fields = {
						{ 
							name = "**QUEM FOI DENUNCIADO:**", 
							value = "` "..identity.name.." "..identity.firstname.." ["..user_id.."] `"
						}
					}, 
					footer = { 
						text = os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"), 
						icon_url = "LOGO DO SEU SERVIDOR" 
					},
					color = 15914080 
				}
			}
		}), { ['Content-Type'] = 'application/json' })
	end
end