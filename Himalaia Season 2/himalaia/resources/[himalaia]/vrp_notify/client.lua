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

RegisterCommand("tes",function(source,args)
	TriggerEvent('Notify', 'sucesso',"Testada com sucesso!")
	TriggerEvent('Notify', 'negado',"Testada com sucesso!")
	TriggerEvent('Notify', 'importante',"Testada com sucesso!")	
	TriggerEvent('Notify', 'aviso',"Testada com sucesso!")	
	TriggerEvent('Notify', 'financeiro',"Testada com sucesso!")	
	TriggerEvent('Notify', 'vtuning',"Testada com sucesso!")	
end)
