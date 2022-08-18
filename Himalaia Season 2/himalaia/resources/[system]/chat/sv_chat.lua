local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')

AddEventHandler('_chat:messageEntered',function(author,color,message)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
    if not message or not author or not identity then
        return
    end
    if not WasEventCanceled() then
    	--TriggerClientEvent('chatMessageProximity',-1,source,identity.name,identity.firstname,message)
    end
end)

AddEventHandler('__cfx_internal:commandFallback',function(command)
	local name = GetPlayerName(source)
    if not command or not name then
        return
    end
	if not WasEventCanceled() then
		TriggerEvent('chatMessage',source,name,'/'..command)
	end
	CancelEvent()
end)

-- Comandos CHAT

RegisterCommand('ilegal', function(source, args, rawCommand)
	local message = rawCommand:sub(8)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	fal = identity.name.. " " .. identity.firstname
	if user_id ~= nil then
		for k, v in pairs(vRP.getUsers()) do
			TriggerClientEvent('chat:addMessage', v, {
				template = '<div style="padding: 0.2vw; margin: 0.2vw; border-radius: 15px 50px 30px 5px;background-image: linear-gradient(to right, rgba(0, 0, 0,0.3) 7%, rgba(0, 0, 0,0) 100%)">👤 <a style="color:#696969;font-weight: bold">Ilegal</a>: {1}</div>',
				args = { fal, message }
			})
		end
		
	end
end)

RegisterCommand('twt', function(source, args, rawCommand)
	local message = rawCommand:sub(4)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	fal = identity.name.. " " .. identity.firstname
	TriggerClientEvent('chat:addMessage', -1, {
	template = '<div style="padding: 0.2vw; margin: 0.2vw; border-radius: 15px 50px 30px 5px;background-image: linear-gradient(to right, rgba(0, 0, 0,0.3) 7%, rgba(0, 0, 0,0) 100%)">🐦 <a style="color:#00BAFF;font-weight: bold">Twitter - {0}</a>: {1}</div>',
	args = { fal, message }
	})
end)

RegisterCommand('190', function(source, args, rawCommand)
        local message = rawCommand:sub(4)
        local user_id = vRP.getUserId(source)
        local identity = vRP.getUserIdentity(user_id)
        fal = identity.name.. " " .. identity.firstname
    
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-image: linear-gradient(to right, rgba(35, 142, 219,0.9) 3%, rgba(0, 0, 0,0) 95%); border-radius: 15px 50px 30px 5px;"><img style="width: 18px" src="https://image.flaticon.com/icons/svg/1022/1022484.svg"> @{0}: {1}</div>',
            args = { fal, message }
        })
    end, false)

RegisterCommand('190a', function(source, args, rawCommand)
	local message = rawCommand:sub(5)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	fal = identity.name.. " " .. identity.firstname
	TriggerClientEvent('chat:addMessage', -1, {
		template = '<div style="padding: 0.2vw; margin: 0.2vw; border-radius: 15px 50px 30px 5px;background-image: linear-gradient(to right, rgba(0, 0, 0,0.3) 7%, rgba(0, 0, 0,0) 100%)">🔫 <a style="color:#4169E1;font-weight: bold">190 - Bandido</a>: {1}</div>',
		args = { fal, message }
	})
	SendWebhookMessage(webhookchatpolicia,"```prolog\n[ID]: "..user_id.." "..fal.." \n[MENSAGEM]: "..message..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
end, false)

RegisterCommand('192', function(source, args, rawCommand)
	local message = rawCommand:sub(4)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	fal = identity.name.. " " .. identity.firstname
	TriggerClientEvent('chat:addMessage', -1, {
		template = '<div style="padding: 0.2vw; margin: 0.2vw; border-radius: 15px 50px 30px 5px;background-image: linear-gradient(to right, rgba(0, 0, 0,0.3) 7%, rgba(0, 0, 0,0) 100%)">👨‍⚕️ <a style="color:#CD5C5C;font-weight: bold">192 - {0}</a>: {1}</div>',
		args = { fal, message }
	})
end, false)

RegisterCommand('olx', function(source, args, rawCommand)
	vRP.antiflood(source,"/olx",3)
	local message = rawCommand:sub(4)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	fal = identity.name.. " " .. identity.firstname
	TriggerClientEvent('chat:addMessage', -1, {
		template = '<div style="padding: 0.2vw; margin: 0.2vw; border-radius: 15px 50px 30px 5px;background-image: linear-gradient(to right, rgba(0, 0, 0,0.3) 7%, rgba(0, 0, 0,0) 100%)">💸 <a style="color:#FFD700;font-weight: bold">OLX - {0}</a>: {1}</div>',
		args = { fal, message }
	})
end, false)

-- command suggestions for clients
local function refreshCommands(player)
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()

        local suggestions = {}

        for _, command in ipairs(registeredCommands) do
            if IsPlayerAceAllowed(player, ('command.%s'):format(command.name)) then
                table.insert(suggestions, {
                    name = '/' .. command.name,
                    help = ''
                })
            end
        end

        TriggerClientEvent('chat:addSuggestions', player, suggestions)
    end
end

AddEventHandler('chat:init', function()
    refreshCommands(source)
end)

AddEventHandler('onServerResourceStart', function(resName)
    Wait(500)

    for _, player in ipairs(GetPlayers()) do
        refreshCommands(player)
    end
end)