local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")


vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
local multa = 0 

open = false
vSERVER = Tunnel.getInterface("tablet_policia")

RegisterCommand('tblpolicia', function()
   if vSERVER.validaPolicial() then 
    open = true
    SetNuiFocus(true,true)
    SendNUIMessage({ action = "tblpolicia" })
   end;
end)  


RegisterNUICallback("closeTablet", function(data, cb)
	  if data.action == "fecharTbl" then
        open = false
        SetNuiFocus(false, false)
        SendNUIMessage({type = 'fecharTbl'})
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNUICallback('requestPassport' , function (data, cb)
  local passport = vSERVER.getPass(data.user_id)
  if passport then
     cb({ passport = passport})
  end
end)

RegisterNUICallback("addPolicial",function(data,cb)
  local passport = vSERVER.addPolicial(data.user_id, data.cargo_id)
end)

RegisterNUICallback("updateCargo",function(data,cb)
  if data.id == 0 then
    local policial = vSERVER.addCargo(data.cargo)
  else 
    local policial = vSERVER.updCargo(data.cargo, data.id)
  end
end)


RegisterNUICallback("buscaPolicial",function(data,cb)
  local policial = vSERVER.getPolicial()
  if policial then
     cb({ policial = policial})
  end
end)

RegisterNUICallback("buscaCargos",function(data,cb)
  local cargos = vSERVER.getCargos()
  if cargos then
     cb({ cargos = cargos})
  end
end)

RegisterNUICallback("Multas",function(data,cb)
    local id = data.id
     vSERVER.multas(data.id, data.valor)
end)

RegisterNUICallback("detido",function(data,cb)
   vSERVER.detido()
   vSERVER.multas(data.id, data.valor)
end)

RegisterNUICallback("addProcurado",function(data,cb)
  local procurado = vSERVER.addProcurado(data.user_id)
end)

RegisterNUICallback("getProcurados",function(data,cb)
  local procurados = vSERVER.getProcurado()
  print(procurados);
  if procurados then
     cb({ procurados = procurados})
  end
end)

RegisterNUICallback("dellProcurados",function(data,cb)
  local procurados = vSERVER.dellPRocurado(data.user_id)
end)

RegisterNUICallback("addLeis",function(data,cb)
 vSERVER.addLeis(data.artigo, data.crime, data.servico)
end)

RegisterNUICallback("getAllLeis",function(data,cb)
  local leis = vSERVER.getAllLeis()
  if leis then
     cb({ leis = leis})
  end
end)

RegisterNUICallback("getLeis",function(data,cb)
  local leis = vSERVER.getLeis()
  if leis then
     cb({ leis = leis})
  end
end)

RegisterNUICallback("delLeis",function(data,cb)
   vSERVER.delLeis(data.id)
end)

RegisterNUICallback("getAllRelatorios",function(data,cb)
  local relatorios = vSERVER.getAllRelatorios()
  if relatorios then
     cb({ relatorios = relatorios})
  end
end)

RegisterNUICallback("updRelatorio",function(data,cb)
   if data.id_relatorio == 0 then
    vSERVER.addRelatorio(data.lei_id, data.descricao)
   else 
    vSERVER.updRelatorio( data.id_relatorio,data.descricao)
   end
end)

RegisterNUICallback("updatePolicia",function(data,cb)
    vSERVER.updatePolicia(data.id,data.ativo,data.cargo, data.cria_lei)  
end)

RegisterNUICallback("getUserData",function(data,cb)
  local userData = vSERVER.getPolicialData()
  if userData then
     cb({ userData = userData})
  end
end)

RegisterNUICallback("prender",function(data,cb)
  vSERVER.prender(data.user_id, data.tempo)  
end)