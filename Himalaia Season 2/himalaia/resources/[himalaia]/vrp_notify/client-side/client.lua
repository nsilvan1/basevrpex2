-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY CSS,MENSAGEM,TEMPO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Notify")
AddEventHandler("Notify",function(css,message,delay)
	if not delay then delay = 9000 end
	SendNUIMessage({ css = css,  message = message, delay = delay })
end)

RegisterCommand("teste",function(source,args)
	TriggerEvent('Notify', 'sucesso', 'Sucesso',"Sucesso")
	TriggerEvent('Notify', 'negado', 'Negado',"Negado")
	TriggerEvent('Notify', 'importante','Importante', "Importante")	
	TriggerEvent('Notify', 'aviso', 'Aviso',"Aviso")	
	TriggerEvent('Notify', 'ferimento',"Ferimento","Ferimento")	
end)