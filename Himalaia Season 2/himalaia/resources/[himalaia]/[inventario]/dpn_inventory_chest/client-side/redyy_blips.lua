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
			DrawMarker(21, blipCoords[1], blipCoords[2], blipCoords[3]-0.6,0,0,0,0.0,0,0,0.6,0.6,0.6,255,255,255,150,0,0,0,1)
			Citizen.Wait(0)
		end
	end)
end