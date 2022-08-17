-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY CSS,MENSAGEM,TEMPO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Notify")
AddEventHandler("Notify", function(css, message, delay)
    if not delay then
        delay = 13000
    end
    SendNUIMessage({ css = css, message = message, delay = delay })
end)


RegisterCommand('notify',function(source,args,rawCommand)
    TriggerEvent("Notify","sucesso","Testado com sucesso!",5000)
    TriggerEvent("Notify","negado","Testado com sucesso!",5000)
    TriggerEvent("Notify","aviso","Testado com sucesso!",5000)
    TriggerEvent("Notify","importante","Testado com sucesso!",5000)
    
    TriggerEvent("itensNotify",{ "RECEBEU","colete",1,"Colete" })
    TriggerEvent("itensNotify",{ "REMOVIDO","colete",1,"Colete" })

    -- TriggerEvent("NotifyPush",{ code = 20, title = "Tráfico", text = "Venda de drogas", x = x ,y = y , z = z , rgba = {140,35,35} })

end)