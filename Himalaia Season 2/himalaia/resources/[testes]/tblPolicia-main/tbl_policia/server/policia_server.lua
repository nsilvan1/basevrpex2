local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp", "lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
fclient = Tunnel.getInterface("nation_garages")

cnTP = {}
Tunnel.bindInterface("tablet_policia",cnTP)

---------------------------------------------------------------------------------------------------
vRP.prepare("queryPassport",
             "SELECT * FROM vrp_user_identities WHERE user_id = @user_id")	
vRP.prepare("queryCargo",
             " SELECT * FROM tbl_policia_cargo")            
vRP.prepare("queryPolicial",
             " SELECT * FROM vw_policial")	
vRP.prepare("validaPolicial",
             " SELECT * FROM vw_policial where user_id = @user_id and ativo = 'S'")	 
vRP.prepare("queryProcurado",
             "SELECT vui.user_id, vui.name FROM vrp_user_identities vui inner join tbl_policia_procurado tpp on tpp.user_id = vui.user_id")	             
vRP.prepare("queryAllLeis",
             "SELECT id, artigo, crime, servico FROM tbl_juiz_leis")	                          
vRP.prepare("queryLeis",
             "SELECT id, artigo, crime, servico FROM tbl_juiz_leis where artigo = @artigo")	                          
vRP.prepare("queryAllRelatorios",
             "SELECT * FROM vw_policia_relatorios" )	                          

vRP.prepare("insertPolicial",
             "INSERT INTO  tbl_policia_user(user_id, cargo_id, ativo, cria_lei) VALUES (@user_id , @cargo_id , 'S', 'N') ")
vRP.prepare("insertCargo",
             " INSERT INTO tbl_policia_cargo(cargo) VALUES (@cargo) ")	
vRP.prepare("insertProcurado",
             " INSERT INTO tbl_policia_procurado(user_id) VALUES (@user_id) ")	             
vRP.prepare("insertLeis",                           
            " INSERT INTO tbl_juiz_leis(artigo, crime, servico) VALUES (@artigo, @crime, @servico) ")	             
vRP.prepare("insertRelatorio",                           
            " INSERT INTO tbl_policia_relatorio(user_id, lei_id, descricao) VALUES (@user_id, @lei_id, @descricao) ")	                          

vRP.prepare("updateCargo",
             "UPDATE tbl_policia_cargo SET cargo = @cargo where id = @id ")	  
vRP.prepare("updatePolicia",
             "UPDATE tbl_policia_user SET ativo = @ativo, cargo_id = @cargo_id, cria_lei = @cria_lei  where id = @id ")	   
vRP.prepare("updateRelatorio",
             "UPDATE tbl_policia_relatorio SET descricao = @descricao where id = @id ")	 

vRP.prepare("dellProcurado",
             "DELETE FROM tbl_policia_procurado WHERE user_id = @user_id ")	               
vRP.prepare("delLeis",
             "DELETE FROM tbl_juiz_leis WHERE id = @id ")	                            
                          
---------------------------------------------------------------------------------------------------             

function cnTP.getPass(user_id)
    return vRP.query("queryPassport", {user_id = user_id})    
end

function cnTP.getCargos(user_id)
	return vRP.query("queryCargo", {})
end	

function cnTP.addPolicial(user_id, cargo_id)
    vRP.execute('insertPolicial', {user_id = user_id, cargo_id = cargo_id})
   return     
end


function cnTP.getPolicial()
	return vRP.query("queryPolicial", {})
end	

function cnTP.addCargo(cargo)
    vRP.execute('insertCargo', {cargo = cargo})
   return     
end

function cnTP.updCargo(cargo, id)
    vRP.execute('updateCargo', {cargo = cargo, id = id})
   return     
end

function cnTP.validaPolicial()
    local validado = false
    local source = source
    local user_id = vRP.getUserId(source)
	local rows,affected = vRP.query("validaPolicial",{ user_id = user_id })
    if #rows > 0 then
        validado = true
    else 
        TriggerClientEvent("Notify",source,"error","Você não pode utilizar esta ação.")
    end

   return validado     
end

function cnTP.multas (id,valor)
    local source = source
    local value = vRP.getUData(parseInt(id), "vRP:multas")
    local multas = json.decode(value) or 0
    vRP.setUData(parseInt(id), "vRP:multas",
                  json.encode(parseInt(multas) + parseInt(valor))) 
    TriggerClientEvent("Notify",source,"sucess","Multa aplicada com sucesso.")
end

function cnTP.detido ()
    local source = source
    local vehicle, vnetid, placa, vname, lock, banned =
    vRPclient.vehList(source, 7)
    local puser_id = vRP.getUserByRegistration(placa)
    local rows = vRP.query("creative/get_vehicles", {
        user_id = parseInt(puser_id),
        vehicle = vname
    })
    if rows[1] then
        vRP.execute("creative/set_detido", {
            user_id = parseInt(puser_id),
            vehicle = vname,
            detido = 1,
            time = parseInt(os.time())
        })
    end
    local deletedVehicle = fclient.tryDeleteNearestVehicle(source)
    TriggerClientEvent("Notify",source,"sucess","Carro apreendido com sucesso.")
end

function cnTP.addProcurado(user_id)
    vRP.execute('insertProcurado', {user_id = user_id})
   return     
end

function cnTP.getProcurado()
    return vRP.query('queryProcurado', {})        
end

function cnTP.dellPRocurado(user_id)
    return vRP.query('dellProcurado', {user_id = user_id})        
end

function cnTP.addLeis(artigo,crime,servico )
    vRP.execute('insertLeis', {artigo = artigo, crime = crime, servico=servico })
   return     
end

function cnTP.getAllLeis()
    return vRP.query('queryAllLeis', {})        
end


function cnTP.getLeis(artigo)
    return vRP.query('queryLeis', {artigo = artigo})        
end

function cnTP.delLeis(id)
     vRP.execute('delLeis', {id = id})        
     return
end

function cnTP.addRelatorio(lei_id,descricao)
    local source = source
    local user_id = vRP.getUserId(source)
    vRP.execute('insertRelatorio', {user_id = user_id, lei_id = lei_id, descricao = descricao})
   return     
end

function cnTP.getAllRelatorios()
    return vRP.query('queryAllRelatorios', {})        
end


function cnTP.updRelatorio(id, descricao)
    vRP.execute('updateRelatorio', {id = id, descricao = descricao})        
end

function cnTP.updatePolicia(id, ativo, cargo, criaLei)
     vRP.execute('updatePolicia', {ativo = ativo, cargo_id = cargo, cria_lei = criaLei, id = id})
end

function cnTP.prender(user_id, tempo)
    local player = vRP.getUserSource(parseInt(user_id))
    if player then
        vRP.setUData(parseInt(user_id), "vRP:prisao",
                     json.encode(parseInt(tempo)))
        vRPclient.setHandcuffed(player, false)
        TriggerClientEvent('prisioneiro', player, true)
        vRPclient.teleport(player, 1680.1, 2513.0, 45.5)
        prison_lock(parseInt(user_id))
        TriggerClientEvent('removealgemas', player)
        TriggerClientEvent("vrp_sound:source", player, 'jaildoor', 0.7)
    end
end

function prison_lock(target_id)
    local player = vRP.getUserSource(parseInt(target_id))
    if player then
        SetTimeout(60000, function()
            local value = vRP.getUData(parseInt(target_id), "vRP:prisao")
            local tempo = json.decode(value) or 0
            if parseInt(tempo) >= 1 then
                TriggerClientEvent("Notify", player, "importante",
                                   "Ainda vai passar <b>" .. parseInt(tempo) ..
                                       " meses</b> preso.")
                vRP.setUData(parseInt(target_id), "vRP:prisao",
                             json.encode(parseInt(tempo) - 1))
                prison_lock(parseInt(target_id))
            elseif parseInt(tempo) == 0 then
                TriggerClientEvent('prisioneiro', player, false)
                vRPclient.teleport(player, 1850.5, 2604.0, 45.5)
                vRP.setUData(parseInt(target_id), "vRP:prisao", json.encode(-1))
                TriggerClientEvent("Notify", player, "importante",
                                   "Sua sentença terminou, esperamos não ve-lo novamente.")
            end
            vRPclient.PrisionGod(player)
        end)
    end
end

function cnTP.getPolicialData()
    local source = source
    local user_id = vRP.getUserId(source)
	return vRP.query("validaPolicial",{ user_id = user_id })

end
