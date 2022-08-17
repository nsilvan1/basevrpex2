-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
vRP = Proxy.getInterface("vRP")
vRPNserver = Tunnel.getInterface("vrp_identidade")
-----------------------------------------------------------------------------------------------------------------------------------------
-- IDENTIDADE
-----------------------------------------------------------------------------------------------------------------------------------------
local css = [[
	.clear {
		clear: both;
	}
	.div_registro {
		background: rgba(15,15,15,0.7);
		color: #999;
		bottom: 15%;
		right: 2.2%;
		position: absolute;
		padding: 20px 30px;
		font-family: Arial;
		line-height: 30px;
		border-right: 3px solid #FF0000;
		letter-spacing: 1.7px;
		border-radius: 10px;
	}
	.div_registro b {
		color: #FF0000;
		padding: 0 4px 0 0;
	}
]]

local identity = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustPressed(0,344) and GetEntityHealth(PlayerPedId()) > 101 then
			if identity then
				vRP._removeDiv("registro")
				identity = false
			else
				local carteira,banco,nome,sobrenome,idade,user_id,identidade,telefone,job,jobdois,vip,multas = vRPNserver.Identidade()
				local bjob = ""
				local bjobdois = ""
				local bvip = ""
				local bmultas = ""

				if job ~= "" then
					bjob = "<br><b>Emprego:</b> "..job
				end

				if jobdois ~= "" then
					bjobdois = "<br><b>Emprego2:</b> "..jobdois
				end

				if vip ~= "" then
					bvip = "<br><b>VIP:</b> "..vip
				end

				if parseInt(multas) > 0 then
					bmultas = "<br><b>Multas Pendentes:</b> " .. multas
				end
				
				vRP._setDiv("registro",css,nome.." "..sobrenome.." <b>#"..user_id.."</b><br><b>Identidade:</b> "..identidade.."<br><b>Telefone:</b> "..telefone..bjob..bjobdois..bvip.."<br><b>Carteira:</b> "..carteira.."<br><b>Banco:</b> "..banco..bmultas)
				identity = true
			end
		end
	end
end)