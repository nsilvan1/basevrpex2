local showBlip = false
local blipCoords = {}

Citizen.CreateThread(function()
	while true do
		local idle = 2000
		local playerCoords = GetEntityCoords(PlayerPedId())
		if not showBlip then
			local stop = false
			for shopType, typeData in pairs(ConfigClient.lojas) do
				if stop then break end
				for _, shopLocs in pairs(typeData.locs) do
					if GetDistanceBetweenCoords(shopLocs[1], shopLocs[2], shopLocs[3], playerCoords, true) <= ConfigClient.distance then
						showBlip = true
						stop = true
						blipCoords = shopLocs
						idle = 500
						startBlipThread()
						break
					end
				end
			end

			for chest, chestData in pairs(ConfigClient.chestFac) do
				if stop then break end

				chestData = chestData.loc
				if GetDistanceBetweenCoords(chestData[1], chestData[2], chestData[3], playerCoords, true) <= ConfigClient.distance then
					showBlip = true
					stop = true
					blipCoords = chestData
					blipCoords[4] = true
					idle = 500
					startBlipThread()
					break
				end
			end
		else
			idle = 500
			if GetDistanceBetweenCoords(blipCoords[1], blipCoords[2], blipCoords[3], playerCoords, true) > ConfigClient.distance then
				showBlip = false
			end
		end
		Citizen.Wait(idle)
	end
end)

function startBlipThread()
	Citizen.CreateThread(function()
		while showBlip do
			DrawTextEmoji(blipCoords[1], blipCoords[2], blipCoords[3]-0.3,"📦") -- COLOCAR SEU EMOJI DENTRO DA STRING
			Citizen.Wait(0)
		end
	end)
end




-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAW TEXT EM 3D
-----------------------------------------------------------------------------------------------------------------------------------------

function DrawTextEmoji(x,y,z,text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    SetTextFont(4)
    SetTextScale(0.35,0.35)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end