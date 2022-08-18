local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
emP = {}
Tunnel.bindInterface("vDrogas",emP)
local idgens = Tools.newIDGenerator()
local blipsOcorrencias = {}
local quantidade = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUANTIDADE
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.Quantidade()
	local source = source
	if quantidade[source] == nil then
	   quantidade[source] = math.random(4,6)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkItens()
	emP.Quantidade()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then	
        return vRP.getInventoryItemAmount(user_id,"sacodecocaina") >= quantidade[source] or vRP.getInventoryItemAmount(user_id,"sacodemaconha") >= quantidade[source]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAGAMENTO
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPayment()
    local source = source
    local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
    if user_id then
        local policia = vRP.getUsersByPermission(permissao_policia)
        local amount_drugs = quantidade[source]
		print('teste')
        local value = math.random(valor_minimo,valor_maximo)
		for k,v in pairs(drogas) do
			print(k)
			if vRP.tryGetInventoryItem(user_id,v,quantidade[source]) then
				local valor_total = value * amount_drugs
				vRP.giveInventoryItem(user_id,item_dinheiro_sujo, valor_total)
				TriggerClientEvent('Notify',source,"aviso","Voce ganhou "..valor_total.." de Dinheiro Sujo ")
				PerformHttpRequest(webhook_vdrogas, function(err, text, headers) end, 'POST', json.encode({
					embeds = {
						{     ------------------------------------------------------------
							title = "Vendeu Droga",
							thumbnail = {
								url = "https://cdn.discordapp.com/attachments/755933469955195015/951639146357735464/gardencity.png"
							}, 
							fields = {
								{ 
									name = "Player\n",
									value = "Nome: "..identity.name.." "..identity.firstname.." ["..user_id.."]"
								},
								{ 
									name = "Quantidade\n",
									value = " "..quantidade[source].." "
								},
								{ 
									name = "Valor Ganho\n",
									value = " "..valor_total.." "
								}
							}, 
							footer = { 
								text = "Data e hora: " ..os.date("%d/%m/%Y | %H:%M:%S"),
								icon_url = "https://www.autoriafacil.com/wp-content/uploads/2019/01/icone-data-hora.png"
							},
							color = 15914080
						}
					}
				}), { ['Content-Type'] = 'application/json' })
				vRPclient._playAnim(source,true,{{"mp_common","givetake1_a"}},false)
				quantidade[source] = nil
			end
		end
    end
end
--------------------------------------------------------------------------------------------------------------------------------------------
--POLICIA
--------------------------------------------------------------------------------------------------------------------------------------------
function emP.OcorrenciaDrogas()
	local source = source
	local user_id = vRP.getUserId(source)
	local x,y,z = vRPclient.getPosition(source)
	if user_id then
		local identity = vRP.getUserIdentity(user_id)
		local soldado = vRP.getUsersByPermission(permissao_policia)
		for l,w in pairs(soldado) do
			local player = vRP.getUserSource(parseInt(w))
			if player then
				async(function()
					local id = idgens:gen()
					blipsOcorrencias[id] = vRPclient.addBlip(player,x,y,z,10,84,"Ocorrência",0.5,false)
					vRPclient._playSound(player,"CONFIRM_BEEP","HUD_MINI_GAME_SOUNDSET")
					TriggerClientEvent('chatMessage',player,"911",{64,64,255},"Recebemos uma denuncia de tráfico, verifique o ocorrido.")
					SetTimeout(10000,function() vRPclient.removeBlip(player,blipsOcorrencias[id]) idgens:free(id) end)
				end)
			end
		end
		PerformHttpRequest(webhook_vdrogas, function(err, text, headers) end, 'POST', json.encode({
			embeds = {
				{     ------------------------------------------------------------
					title = "Denuncia Venda de Drogas",
					thumbnail = {
						url = "https://cdn.discordapp.com/attachments/755933469955195015/951639146357735464/gardencity.png"
					}, 
					fields = {
						{ 
							name = "Foi denunciado, vendendo droga\n",
							value = "Nome: "..identity.name.." "..identity.firstname.." ["..user_id.."]"
						}
					}, 
					footer = { 
						text = "Data e hora: " ..os.date("%d/%m/%Y | %H:%M:%S"),
						icon_url = "https://www.autoriafacil.com/wp-content/uploads/2019/01/icone-data-hora.png"
					},
					color = 15914080
				}
			}
		}), { ['Content-Type'] = 'application/json' })
	end
end