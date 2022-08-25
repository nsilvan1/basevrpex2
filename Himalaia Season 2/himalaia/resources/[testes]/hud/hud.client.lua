-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

Zkrd = {}

local MaxHp = 300
local _currentHp = -1
local _currentArmor = -1
local _currentFuel = -1
local _engineStatus = -1
local _hasCinto = false
local _showRadar = true
local _isInCar = false
local _currentDate
local _currentTime
local _showHud = false
local _timeEnergetic = 0
local _timeEnergeticTotal = 0
local _energeticActive = false
local _otherPed = -1
local IsPlayerSpawned = true

local queue = {}

function math.round(num, numDecimalPlaces)
  if numDecimalPlaces and numDecimalPlaces>0 then
    local mult = 10^numDecimalPlaces
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

function Zkrd.Thread(callback, threadDelay)
  CreateThread(function()
      local delay = threadDelay or 0
      while true do
          delay = callback() or delay
          Wait(delay)
      end
  end)
end

--- Create a command and then a keymapping for the specified function
---@param callback function
---@param commandName string
---@param description string
---@param mapper string
---@param binding string
---@param restricted boolean
function Zkrd.KeyMapping(callback, commandName, description, mapper, binding, restricted)
  RegisterCommand(commandName, callback, restricted or false)
  RegisterKeyMapping(commandName, description, mapper or "keyboard", binding or "e")
end

function Zkrd.SendNuiMessage(functionName, functionParameters)
  SendNUIMessage({
      type = functionName,
      detail = functionParameters,
      content = functionParameters
  })
end

local function SetPopupIfood()
  local value = GetResourceKvpInt("ifood-start")
  if value ~= 1 then
    SetNuiFocus(true, true)
    Zkrd.SendNuiMessage("setShowIfoodPopup", true)
    SetResourceKvpInt("ifood-start", 1)
  end
end

AddEventHandler('onClientResourceStart', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
end)

RegisterNetEvent("progress")
AddEventHandler("progress", function(time,text)
  local teste = {}
  teste.Title = text
  teste.Seconds = time
  Zkrd.SendNuiMessage("startProgress", teste)
end)

RegisterNUICallback("progressResult", function (result, cb)
    local removed = table.remove(queue, 1)
    cb(true)
end)

RegisterNetEvent("hud:progress", function (jsonValue, onStart, onEnd)
  local progressConfig = json.decode(jsonValue)
  OnProgress(progressConfig, onStart, onEnd)
end)


local function OnSetConnected(connected)
  _showHud = connected
  _currentHp = -1
  _currentArmor = -1
  _currentFuel = -1
  _engineStatus = -1
  _hasCinto = false
  _currentDate = ""
  _currentTime = ""
  Zkrd.SendNuiMessage("setShow", connected)
end

RegisterCommand("hud", function ()
  IsPlayerSpawned = true
  OnSetConnected(not _showHud)
end, false)


local function GetMicDesc(mic)
  if mic == 1 then
    return "Sussurrando"
  elseif mic == 2 then
    return "Normal"
  elseif mic == 3 then
    return "Gritando"
  else
    return "Normal"
  end
end


RegisterNetEvent("hud:setShow", OnSetConnected)

RegisterNetEvent("hud:wanted",function (ms)
  Zkrd.SendNuiMessage("setWanted", ms)
end)


RegisterNetEvent("hud:setped", function (nped)
  _otherPed = nped
  _currentHp = -1
  _currentArmor = -1
end)

RegisterCommand("testeeeeee", function ()
  TriggerEvent("progress",5,"Teste")
end, false)

RegisterCommand("testeeeee", function ()
  TriggerEvent("cda:setThirst","100")
end, false)

RegisterCommand("testeeee", function ()
  TriggerEvent("cda:setHungry","100")
end, false)

RegisterCommand("testeee", function ()
  TriggerEvent("cda:setRadio","teste")
end, false)

RegisterCommand("testee", function ()
  TriggerEvent("hud:wanted",10000)
end, false)

RegisterCommand("teste", function ()
  TriggerEvent("Notify","success","Teste",5000,"Teste")
end, false)

RegisterNetEvent("notifyItem", function (type, mensagem, time, image, title)
  local teste2 = {}
  teste2.Description = mensagem or ""
  teste2.Image = "http://167.114.223.179/inventory/"..image..".png" or ""
  teste2.Type = type or "success"
  teste2.Title = title or ""
  teste2.Timeout = time or 5000
  Zkrd.SendNuiMessage("createNotification", teste2)
end)

RegisterNetEvent("Notify", function (type, mensagem, time, title)
  local teste2 = {}
  teste2.Description = mensagem
  teste2.Type = type or "success"
  teste2.Title = title or ""
  teste2.Timeout = time or 5000
  Zkrd.SendNuiMessage("createNotification", teste2)
end)

RegisterNetEvent("uprp:setMic", function (mic)
  Zkrd.SendNuiMessage("setMic", GetMicDesc(mic))
end)

RegisterNetEvent("cda:setRadio", function (radio)
  Zkrd.SendNuiMessage("setRadio", radio)
end)

RegisterNetEvent("cda:setTalking", function (talking)
  Zkrd.SendNuiMessage("setTalking", talking)
end)

RegisterNetEvent("cda:cinto", function (hasCintoSeguranca)
  if (_hasCinto ~= hasCintoSeguranca) then  
    _hasCinto = hasCintoSeguranca
    Zkrd.SendNuiMessage("setCinto", hasCintoSeguranca)
  end
end)

RegisterNetEvent("isEletricVehicle", function (isEletric)
  Zkrd.SendNuiMessage("setVehEletric", isEletric)
end)

RegisterNetEvent("cda:energetic", function (timeInMileSeconds)
  _energeticActive = true
  _timeEnergeticTotal = timeInMileSeconds / 1000
  _timeEnergetic = timeInMileSeconds / 1000
  SetRunSprintMultiplierForPlayer(PlayerId(), 1.2)
end)

RegisterNetEvent("cda:setHungry", function (hungry)
  Zkrd.SendNuiMessage("setHungry", hungry)
end)

RegisterNetEvent("cda:setThirst", function (thirst)
  Zkrd.SendNuiMessage("setThirsty", thirst)
end)


RegisterNetEvent("cda:showradar", function (value)
  _showRadar = value
end)

RegisterNetEvent("cda:setDisplayHud", function (value)
  Zkrd.SendNuiMessage("setDisplayHud", value)
end)


RegisterNetEvent("hud:specracemod", function (value)
    Zkrd.SendNuiMessage("setShowHungerThirst", value)
    Zkrd.SendNuiMessage("setShowInfo", value)
end)

Zkrd.Thread(function ()
  if (_timeEnergeticTotal == 0 or _timeEnergetic == 0) then
      Zkrd.SendNuiMessage("setEnergetic", 0)
      _timeEnergetic = -1
      _timeEnergeticTotal = -1
      if(_energeticActive) then
          _energeticActive = false
          SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
      end
  end
  if (_timeEnergetic > 0) then
      RestorePlayerStamina(PlayerId(), 1.0)
      local percent = _timeEnergetic * 100 / _timeEnergeticTotal
      Zkrd.SendNuiMessage("setEnergetic", percent)
      _timeEnergetic = _timeEnergetic - 1
      return 1000
  else
      return 500
  end
end, 500)

function Zkrd.Position()
  return table.unpack(GetEntityCoords(PlayerPedId()))
end

function string.lpad(str, len, char)
  if char == nil then char = ' ' end
  return string.rep(char, len - #str)..str
end

Zkrd.Thread(function ()
  if (IsPlayerSpawned) then
      local x,y,z = Zkrd.Position()
      local street, _ = GetStreetNameAtCoord(x,y,z)
      local formattedDate = GetStreetNameFromHashKey(street)
      if (formattedDate ~= _currentDate) then
          _currentDate = formattedDate
          Zkrd.SendNuiMessage("setDate", _currentDate)
      end
      local hours = tostring(GetClockHours())
      local minutes = tostring(GetClockMinutes())

      local formattedTime = string.lpad(hours, 2, "0")..":"..string.lpad(minutes, 2, "0")
      if (formattedTime ~= _currentTime) then
          _currentTime = formattedTime
          Zkrd.SendNuiMessage("setTime", _currentTime)
      end
  end
end, 1000)



Zkrd.Thread(function ()
  local delay = 500
  local ped = 0 
  if _otherPed ~= -1 then
    ped = _otherPed
  else 
    ped = PlayerPedId()
  end
  if (IsPlayerSpawned and IsPedInAnyVehicle(ped, false)) then
      delay = 50
      local vehicle = GetVehiclePedIsIn(ped, false)
      local isLocked = GetVehicleDoorsLockedForPlayer(vehicle,ped) == 1
      local totalSpeed = GetEntitySpeed(vehicle)
      local currentSpeed = math.ceil(totalSpeed * 3.6)
      local rpm = GetVehicleCurrentRpm(vehicle) * 100
      local fuel = math.ceil(math.round(GetVehicleFuelLevel(vehicle), 1))
      local currentEngineStatus = GetVehicleEngineHealth(vehicle)

      if (_currentFuel ~= fuel) then
          _currentFuel = fuel
          Zkrd.SendNuiMessage("setFuelLevel", fuel)
      end
      if (currentEngineStatus ~=_engineStatus) then
          _engineStatus = currentEngineStatus
          local percent = ((_engineStatus - 100) * 100) / 900
          Zkrd.SendNuiMessage("setEngineLevel", percent)
      end
      local gear = GetVehicleCurrentGear(vehicle)
      Zkrd.SendNuiMessage("setSpeed", currentSpeed)
      Zkrd.SendNuiMessage("setRpm", rpm > 100 and 100 or rpm)
      local shift = tostring(gear)
      if currentSpeed == 0 then
        shift = "N"
      end
      if gear == 0 then
        shift = "R"
      end
      Zkrd.SendNuiMessage("setShift", shift)
      Zkrd.SendNuiMessage("setLocked", isLocked)
  end
  return delay
end, 500)

Zkrd.Thread(function ()
  local delay = 500

  if (IsPlayerSpawned) then
      delay = 50
      local ped = 0 
      if _otherPed ~= -1 then
        ped = _otherPed
      else 
        ped = PlayerPedId()
      end
      local health = GetEntityHealth(ped)
      local armour = GetPedArmour(ped)

      if (_currentHp ~= health) then
          _currentHp = health
          local percentValue = ((_currentHp - 100) * 100) / (MaxHp)
          Zkrd.SendNuiMessage("setHp", percentValue)
      end

      if (_currentArmor ~= armour) then
          _currentArmor = armour
          local percentValue = _currentArmor > 100 and 100 or _currentArmor
          Zkrd.SendNuiMessage("setArmor", percentValue)
      end
  end
  return delay
end, 500)


Zkrd.Thread(function ()
  if (IsPlayerSpawned) then
    local ped = 0 
    if _otherPed ~= -1 then
      ped = _otherPed
    else 
      ped = PlayerPedId()
    end
    if (IsPedInAnyVehicle(ped, false)) then
        SetRadarZoom(1000)
        DisplayRadar(_showRadar)
        if (not _isInCar) then
            _isInCar = true
            Zkrd.SendNuiMessage("setInCar", true)
        end
    else
        if (_isInCar) then
            _isInCar = false
            Zkrd.SendNuiMessage("setInCar", false)
        end
        DisplayRadar(false)
    end
  else
      DisplayRadar(false)
  end
end, 500)

RegisterNetEvent("hud:setCupom", function (jsonCupom)
  if jsonCupom then
    jsonCupom = json.decode(jsonCupom)
  end
  Zkrd.SendNuiMessage("setCupom", jsonCupom)
end)

RegisterNUICallback("close", function(_,cb) 
  SetNuiFocus(false, false)
  Zkrd.SendNuiMessage("setShowIfoodPopup", false)
  cb()
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local sBuffer = {}
local vBuffer = {}
local CintoSeguranca = false
local ExNoCarro = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		NetworkClearVoiceChannel()
		NetworkSetTalkerProximity(1)
	end
end)

IsCar = function(veh)
	local vc = GetVehicleClass(veh)
	return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
end	

Fwv = function (entity)
	local hr = GetEntityHeading(entity) + 90.0
	if hr < 0.0 then
		hr = 360.0 + hr
	end
	hr = hr * 0.0174533
	return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end


RegisterNetEvent("vrp_carhud:seatBelt")
AddEventHandler("vrp_carhud:seatBelt", function()
	if CintoSeguranca then
		return
	end

	CintoSeguranca = true
	TriggerEvent("cda:cinto", CintoSeguranca)
end)

Citizen.CreateThread(function()
	local lastVeh = nil
	local hash = nil
	while true do
		local ped = PlayerPedId()
		local car = GetVehiclePedIsIn(ped)

		local idle = 500

		if car ~= 0 and (ExNoCarro or IsCar(car)) then
			idle = 5
			ExNoCarro = true
			if CintoSeguranca then
				DisableControlAction(0,75)
			end

			sBuffer[2] = sBuffer[1]
			sBuffer[1] = GetEntitySpeed(car)

			if sBuffer[2] ~= nil and not CintoSeguranca and GetEntitySpeedVector(car,true).y > 1.0 and sBuffer[1] > 10.25 and (sBuffer[2] - sBuffer[1]) > (sBuffer[1] * 0.255) then
				local co = GetEntityCoords(ped)
				local fw = Fwv(ped)
				SetEntityHealth(ped,GetEntityHealth(ped)-100)
				SetEntityCoords(ped,co.x+fw.x,co.y+fw.y,co.z-0.47,true,true,true)
				SetEntityVelocity(ped,vBuffer[2].x,vBuffer[2].y,vBuffer[2].z)
			end

			vBuffer[2] = vBuffer[1]
			vBuffer[1] = GetEntityVelocity(car)

			if IsControlJustReleased(1,105) then
				if CintoSeguranca then
					CintoSeguranca = false					
				else
					CintoSeguranca = true
				end
				TriggerEvent("cda:cinto", CintoSeguranca);
			end
		elseif ExNoCarro then
			ExNoCarro = false
			CintoSeguranca = false
			TriggerEvent("cda:cinto", CintoSeguranca);
			sBuffer[1],sBuffer[2] = 0.0,0.0
		end
		Citizen.Wait(idle)
	end
end)
