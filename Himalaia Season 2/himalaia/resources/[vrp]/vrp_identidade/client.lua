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
local identity = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		--if IsControlJustPressed(0,344) and GetEntityHealth(PlayerPedId()) > 101 then
		if IsControlJustPressed(0,344) then
			local pedid = PlayerPedId();
			GetEntityHealth(pedid);
			print(pedid);
			if identity then
				identity = false
				SendNUIMessage({ type = 'close' })
			else
				local carteira,
					  banco,
					  paypal,
					  nome,
					  sobrenome,
					  idade,
					  user_id,
					  identidade,
					  telefone,
					  job,cargo,
					  vip,
					  multas,
					  faturas,
					  porte, 
					  aero, 
		            --   cnh2,
					--   cnh,
					  pontos2,
					  telefone = vRPNserver.Identidade()
				SendNUIMessage({
					type = 'open',
					nome = nome,
					sobrenome = sobrenome,
					carteira = carteira,
					banco = banco,
					vip = vip,
					emprego = job,
					cargo = cargo,
					id = user_id,
					documento = identidade,
					idade = idade,
					paypal = paypal,
					telefone = telefone,
					multas = multas,
					porte = porte, 
					aero = aero, 
					-- cnh2 = cnh2,
					-- cnh = cnh,
					pontos2 = pontos2
				})
				identity = true
			end
		end
	end
end)