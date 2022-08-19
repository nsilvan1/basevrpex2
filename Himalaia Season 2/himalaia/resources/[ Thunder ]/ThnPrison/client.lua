local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
func = Tunnel.getInterface(GetCurrentResourceName())

local prisioneiro = false
local reducaopenal = false

local coord = {}

function trancasAbertas()
	hour = GetClockHours()
	local aberto = (hour > 12 and hour < 21)
	local aberto2 = (hour > 2 and hour < 9)
	if aberto == false then
		return aberto2
	else
		return aberto
	end
	return false
end

local doors = {
	[1] = { text = true, hash = -1612152164, ['x'] = 1782.76, ['y'] = 2570.09, ['z'] = 45.72, lock = true},
	[2] = { text = true, hash = -1612152164, ['x'] = 1782.77, ['y'] = 2573.9, ['z'] = 45.72, lock = true},
	[3] = { text = true, hash = -1612152164, ['x'] = 1782.7, ['y'] = 2577.89, ['z'] = 45.72, lock = true},
	[4] = { text = true, hash = -1612152164, ['x'] = 1782.74, ['y'] = 2582.16, ['z'] = 45.71, lock = true},
	[5] = { text = true, hash = -1612152164, ['x'] = 1782.8, ['y'] = 2586.23, ['z'] = 45.71, lock = true},
	[6] = { text = true, hash = -1612152164, ['x'] = 1782.66, ['y'] = 2569.76, ['z'] = 49.72, lock = true},
	[7] = { text = true, hash = -1612152164, ['x'] = 1782.72, ['y'] = 2573.78, ['z'] = 49.72, lock = true},
	[8] = { text = true, hash = -1612152164, ['x'] = 1782.7, ['y'] = 2577.98, ['z'] = 49.72, lock = true},
	[9] = { text = true, hash = -1612152164, ['x'] = 1782.74, ['y'] = 2582.12, ['z'] = 49.72, lock = true},
	[10] = { text = true, hash = -1612152164, ['x'] = 1782.76, ['y'] = 2586.23, ['z'] = 49.72, lock = true},
}

function TeleportCela()
	local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),coord['x'], coord['y'], coord['z'],true)
	if distance > 8 then
		TriggerEvent("vrp_sound:source",'jaildoor',0.7)
		DoScreenFadeOut(1000)
		Wait(3000)
		DoScreenFadeIn(1000)
		SetEntityCoords(PlayerPedId(), coord['x'], coord['y'], coord['z'])
	end
end

local cooldown = 0


Citizen.CreateThread(function()
	while true do
		if cooldown > 0 then
			cooldown = cooldown - 1
		end
		Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
	while true do
		local idle = 500
		local ped = PlayerPedId()
		local playercoords = GetEntityCoords(ped)
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),1779.82,2558.96,45.68,true)
		if distance < 10 and prisioneiro then
			idle = 5
			if distance <= 2 then
				DrawText3Ds(1779.82,2558.96,45.68+0.5,"Pressione ~p~E~s~ para pegar o seu ~p~Lanche.")
				if IsControlJustPressed(0, 51) then
					if cooldown == 0 then
						cooldown = 2000
						func.receberLanche()
						TriggerEvent("Notify","sucesso","Você pegou o seu lanche!")
					else
						TriggerEvent("Notify","negado","Você pode pegar o seu proximo lanche em "..cooldown..' segundos')
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.55, 0.55)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 270
    DrawRect(_x,_y+0.0185, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

Citizen.CreateThread(function()
	while true do
		local timing = 500
		if prisioneiro then
			timing = 5
			local ui = GetMinimapAnchor()
			if trancasAbertas() then
				drawTxt2(ui.right_x-0.120,ui.bottom_y-0.030,1.3,1.0,0.40,"O patio encerra as ~r~20:00 ~s~e as ~r~08:00",255,255,255,200)
			else
				drawTxt2(ui.right_x-0.120,ui.bottom_y-0.030,1.3,1.0,0.40,"O patio abre as ~r~13:00 ~s~e as ~r~03:00",255,255,255,200)
			end
		end
		Citizen.Wait(timing)
	end
end)

Citizen.CreateThread(function()
	while true do
		local timing = 300
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
		for k,v in pairs(doors) do
			if GetDistanceBetweenCoords(x,y,z,v.x,v.y,v.z,true) <= 5 then
				timing = 1
				local door = GetClosestObjectOfType(v.x,v.y,v.z,5.0,v.hash,false,false,false)
				if door ~= 0 then
					SetEntityCanBeDamaged(door,false)
					if trancasAbertas() then
						DrawText3Ds(v.x,v.y,v.z+0.2,"~g~PORTA ABERTA")
						NetworkRequestControlOfEntity(door)
						FreezeEntityPosition(door,false)
					else
						local lock,heading = GetStateOfClosestDoorOfType(v.hash,v.x,v.y,v.z,lock,heading)
						if heading > -0.02 and heading < 0.02 then
							DrawText3Ds(v.x,v.y,v.z+0.2,"~g~PORTA FECHADA")
							NetworkRequestControlOfEntity(door)
							FreezeEntityPosition(door,true)
						end
					end
				end
			end
		end
		Citizen.Wait(timing)
	end
end)

RegisterNetEvent('prisioneiro')
AddEventHandler('prisioneiro',function(status,coordenada)
	if status == true then
		prisioneiro = true
		coord = coordenada
		reducaopenal = false
		local ped = PlayerPedId()
		TriggerEvent("Notify","aviso","Você foi preso e está na cela de numero "..coord['cela'])
		TriggerEvent("vrp_sound:source",'jaildoor',0.7)
		DoScreenFadeOut(1000)
		Wait(3000)
		DoScreenFadeIn(1000)
		SetEntityCoords(PlayerPedId(), coord['x'], coord['y'], coord['z'])
		if prisioneiro then
			FreezeEntityPosition(ped,true)
			SetTimeout(3000,function()
				FreezeEntityPosition(ped,false)
			end)
		end
	else
		prisioneiro = false
		TriggerServerEvent('openCela', coord['cela'])
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		if prisioneiro then
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),1700.5,2605.2,45.5,true)
			local distance2 = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),coord['x'], coord['y'], coord['z'],true)
			print(distance)
			if distance >= 150 then
				TriggerEvent("vrp_sound:source",'jaildoor',0.7)
				DoScreenFadeOut(1000)
				Wait(3000)
				DoScreenFadeIn(1000)
				SetEntityCoords(PlayerPedId(), coord['x'], coord['y'], coord['z'])
				TriggerEvent("Notify","aviso","O agente penitenciário encontrou você tentando escapar.")
			end
			if distance2 > 10 and trancasAbertas() == false then
				TriggerEvent("vrp_sound:source",'jaildoor',0.7)
				DoScreenFadeOut(1000)
				Wait(3000)
				DoScreenFadeIn(1000)
				SetEntityCoords(PlayerPedId(), coord['x'], coord['y'], coord['z'])
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if prisioneiro then
			local distance1 = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),1691.59,2566.05,45.56,true)
			local distance2 = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),1625.49,2490.96,45.64,true)
			if GetEntityHealth(PlayerPedId()) <= 100 then
				reducaopenal = false
				vRP._DeletarObjeto()
			end
			if distance1 <= 100 and not reducaopenal and trancasAbertas() then
				DrawMarker(21,1691.59,2566.05,45.56,0,0,0,0,180.0,130.0,1.0,1.0,0.5,255,0,0,100,1,0,0,1)
				if distance1 <= 1.2 then
					drawTxt("PRESSIONE  ~r~E~w~  PARA PEGAR A CAIXA",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) then
						reducaopenal = true
			
						vRP._CarregarObjeto("anim@heists@box_carry@","idle","hei_prop_heist_box",50,28422)
					end
				end
			end

			if distance2 <= 100 and reducaopenal and trancasAbertas() then
				DrawMarker(21,1625.49,2490.96,45.64,0,0,0,0,180.0,130.0,1.0,1.0,0.5,255,0,0,100,1,0,0,1)
				if distance2 <= 1.2 then
					drawTxt("PRESSIONE  ~r~E~w~  PARA ENTREGAR A CAIXA",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) then
						reducaopenal = false
						TriggerServerEvent("wjdiwjdiwdjiwdjwidjwidjwid")
						vRP._DeletarObjeto()
					end
				end
			end
			if not trancasAbertas then
				reducaopenal = false
				vRP._DeletarObjeto()
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if reducaopenal and trancasAbertas() then
			BlockWeaponWheelThisFrame()
		end
	end
end)

function GetMinimapAnchor()
    local safezone = GetSafeZoneSize()
    local safezone_x = 1.0 / 20.0
    local safezone_y = 1.0 / 20.0
    local aspect_ratio = GetAspectRatio(0)
    local res_x, res_y = GetActiveScreenResolution()
    local xscale = 1.0 / res_x
    local yscale = 1.0 / res_y
    local Minimap = {}
    Minimap.width = xscale * (res_x / (4 * aspect_ratio))
    Minimap.height = yscale * (res_y / 5.674)
    Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.right_x = Minimap.left_x + Minimap.width
    Minimap.top_y = Minimap.bottom_y - Minimap.height
    Minimap.x = Minimap.left_x
    Minimap.y = Minimap.top_y
    Minimap.xunit = xscale
    Minimap.yunit = yscale
    return Minimap
end

function drawTxt2(x,y,width,height,scale,text,r,g,b,a)
    SetTextFont(4)
    SetTextScale(scale,scale)
    SetTextColour(r,g,b,a)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x,y)
end

function DrawText3Ds(x,y,z,text)
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

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end