local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

local webhookcl = "https://discord.com/api/webhooks/1014302271510687764/mrgqMXNK85Lzdx-X83MlouQb_Uso5eNLX3_b4UyOSQULB0pn0w-LwtUXNuG7TS4dU4jv"    ------ SEU WEBHOOK AQUI --- 



RegisterCommand("cl", function(source, args, rawcmd)
    TriggerClientEvent("yaga_antcl:show", source)
end)

AddEventHandler("playerDropped", function(reason)
    local user_id = vRP.getUserId(source)
    local crds = GetEntityCoords(GetPlayerPed(source))
    local identifier = ""
    if Config.UseSteam then
        identifier = GetPlayerIdentifier(source, 0)
    else
        identifier = GetPlayerIdentifier(source, 1)
    end
    TriggerClientEvent("yaga_antcl", -1, user_id, crds, identifier, reason)
    if Config.LogSystem then
        SendLog(user_id, source, crds, identifier, reason)
    end
end)

function SendLog(user_id, source, crds, identifier, reason)
    local name = GetPlayerName(source)
    local date = os.date('*t')
    if date.month < 10 then date.month = '0' .. tostring(date.month) end
    if date.day < 10 then date.day = '0' .. tostring(date.day) end
    if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
    if date.min < 10 then date.min = '0' .. tostring(date.min) end
    if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
    local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
    local embeds = {
        {
            ["title"] = "Desconectado",
            ["type"]="rich",
            ["color"] = 4777493,
            ["fields"] = {
                {
                    ["name"] = "Steam Hex",
                    ["value"] = identifier,
                    ["inline"] = true,
                },{
                    ["name"] = "Nome",
                    ["value"] = name,
                    ["inline"] = true,
                },{
                    ["name"] = "ID",
                    ["value"] = user_id,
                    ["inline"] = true,
                },{
                    ["name"] = "Cordenadas",
                    ["value"] = "X: "..crds.x..", Y: "..crds.y..", Z: "..crds.z,
                    ["inline"] = true,
                },{
                    ["name"] = "Motivo",
                    ["value"] = reason,
                    ["inline"] = true,
                },
            },
            ["footer"]=  {
                ["icon_url"] = "https://forum.fivem.net/uploads/default/original/4X/7/5/e/75ef9fcabc1abea8fce0ebd0236a4132710fcb2e.png",
                ["text"]= "Data/Hora: " ..date.."",
            },
        }
    }
    PerformHttpRequest(webhookcl, function(err, text, headers) end, 'POST', json.encode({ username = Config.LogBotName,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end