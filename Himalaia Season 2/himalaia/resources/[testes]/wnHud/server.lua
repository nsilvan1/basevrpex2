local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
src = {}
Tunnel.bindInterface("vrp_hud",src)

function src.getStats()
    local source = source
    local user_id = vRP.getUserId(source)
    return vRP.getThirst(user_id),vRP.getHunger(user_id)
end

local vhunger = 0
local vthirst = 0

RegisterCommand('morfina',function(source,args,rawCommand)
	local source = source
    local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"admin.permissao") then
		vthirst = -100
		vRP.varyThirst(user_id,vthirst)
		vhunger = -100
		vRP.varyHunger(user_id,vhunger)
	end
end)

RegisterCommand('morfina2',function(source,args,rawCommand)
	local source = source
    local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"admin.permissao") then
		vthirst = 50
		vRP.varyThirst(user_id,vthirst)
		vhunger = 50
		vRP.varyHunger(user_id,vhunger)
	end
end)

RegisterCommand('morfina3',function(source,args,rawCommand)
	local source = source
    local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"admin.permissao") then
		vthirst = 50
		vRP.varyThirst(user_id,vthirst)
	end
end)