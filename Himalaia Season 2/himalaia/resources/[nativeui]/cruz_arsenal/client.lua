local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
src = Tunnel.getInterface("cruz_arsenal")
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION
-----------------------------------------------------------------------------------------------------------------------------------------
local menuactive = false
function ToggleActionMenu()
	menuactive = not menuactive
	if menuactive then
		SetNuiFocus(true,true)
		SendNUIMessage({ showmenu = true })
	else
		SetNuiFocus(false)
		SendNUIMessage({ hidemenu = true })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ButtonClick",function(data,cb)
	local ped = PlayerPedId()
	if data == "kit" then
		TriggerServerEvent("vrp_arsenal:KIT",user_id)
	elseif data == "radio" then
		TriggerServerEvent("vrp_arsenal:Radio",user_id)
	elseif data == "glock" then
		TriggerServerEvent("vrp_arsenal:GLOCK",user_id)
	elseif data == "five" then
		TriggerServerEvent("vrp_arsenal:five",user_id)
	elseif data == "sigsauer" then
		TriggerServerEvent("vrp_arsenal:SIG",user_id)
	elseif data == "remington" then
		TriggerServerEvent("vrp_arsenal:DOZE",user_id)
	elseif data == "mp5" then
		TriggerServerEvent("vrp_arsenal:MP5",user_id)
	elseif data == "m4a1" then
		TriggerServerEvent("vrp_arsenal:M4A1",user_id)
	elseif data == "mpx" then
		TriggerServerEvent("vrp_arsenal:MPX",user_id)
	elseif data == "limpar" then
		RemoveAllPedWeapons(ped,true)
	elseif data == "fechar" then
		ToggleActionMenu()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRABALHAR
-----------------------------------------------------------------------------------------------------------------------------------------
local marcacoes = {
	{ 603.72, -52.19, 75.21 }
}

RegisterCommand('arsenal',function(source,args)
	for _,mark in pairs(marcacoes) do
		local x,y,z = table.unpack(mark)
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
		if distance <= 3 then
			if src.checkPermissao() then
				ToggleActionMenu()
			else
				TriggerEvent("Notify","negado","Negado","Você não tem permissão para acessar o arsenal.")
			end
		end
	end
end)