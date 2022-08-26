var leisRelatoios
var id_relatorio = 0
var Policiatbl = {}
var lei = 'N';
$(() => {
	$("body").hide()
	window.addEventListener("message", function (event) {
		switch (event.data.action) {
			case "tblpolicia":
				$("body").show()
				Policiatbl.init();
				break;
		}
	});

});

Policiatbl = {
	init: function () {
		document.onkeyup = function (data) {
			if (data.which == 27) {
				$("body").hide()
				closeTablet();
			}
		}
	}
}

function closeTablet() {
	$.post("http://tbl_policia/closeTablet", JSON.stringify({ action: "fecharTbl" }));
}

function openDiv(div) {
	cleanDiv()
	switch (div) {
		case 'policial':
			$("#policial").show()
			getPoliciais()
			break;
		case 'cargo':
			$("#cargo").show()
			getCargos()
			break;
		case 'multas':
			$("#multas").show()
			break
		case 'detido':
			$("#detido").show()
			break
		case 'procurado':
			$("#procurado").show()
			getProcurados()
			break
		case 'leis':
			$("#leis").show()
			getAllLeis()
			break
		case 'relatorios':
			$("#relatorios").show()
			getAllRelatorios()
			break
		case 'prender':
			$("#prender").show()
			break		
	}
}

function cleanDiv() {
	$("#policial").hide()
	$("#cargo").hide()
	$("#multas").hide()
	$("#multaPassValid").hide()
	$("#multaValorValid").hide()
	$("#detido").hide()
	$("#procurado").hide()
	$("#leis").hide()
	$("#relatorios").hide()
	$("#prender").hide()
}

function modalDinamicAddUser() {
	$(".modal-content").empty();

	let header = `<div class="modal-header"> 
    <h4 class="modal-title modal-text">Adicionar pessoa</h4> </div>
    <div class="modal-body">
    <div class='row'>
        <div class="col-6">
             <input class="modal-text" id="txtPass" type="text" placeholder="Informe o passaporte">
         
        </div>
		<div class="col-6">
	    	<button type="button" class="badge btn-outline-info" onclick="pesquisarPessoa()">procurar</button>
	   </div>
	   <div class="col-12">
		 <div id='dvPass' class='row'>
		 </div>
		</div>
	</div>
    <div class="modal-footer">      

       <button type="button" class="badge btn-light" data-dismiss="modal">Close</button>
    </div>`;

	$(".modal-content").append(header)

	$("#myModal").modal({
		show: true
	});
}

function modalDinamicCargo(id, name) {
	$(".modal-content").empty();

	let header = `<div class="modal-header"> 
    <h4 class="modal-title modal-text">Alterar Cargo</h4> </div>
    <div class="modal-body">
    <div class='row'>
        <div class="col-12">
             <input class="modal-text" id="txtCargo" type="text" placeholder="${name}">
        </div>
	</div>
    <div class="modal-footer">      
	   <button type="button" class="badge btn-outline-info" onclick="alterarCargo(${id})">Confirmar</button>
       <button type="button" class="badge btn-light" data-dismiss="modal">Fechar</button>
    </div>`;

	$(".modal-content").append(header)

	$("#myModal").modal({
		show: true
	});
}

function pesquisarPessoa() {
	let passporte = $("#txtPass").val()
	$('#dvPass').empty();
	$.post("http://tbl_policia/requestPassport", JSON.stringify({ user_id: passporte }), (data) => {
		let passport = data.passport;
		let option = `
			<div class="table-responsive">
			<table class="table">
			  <thead>
				<tr>
				  <th> Fone </th>
				  <th> Nome </th>
				  <th> </th>
				</tr>
			  </thead>
			  <tbody>`
		for (let i = 0; i < passport.length; i++) {
			option += `
				<tr>
				  <td>  ${passport[i].phone} </td>
				  <td> ${passport[i].name}  </td>
				  <td>
					<button class="badge btn-outline-info" onclick="addPolicial('${passport[i].user_id}')">Adicionar</button>
				  </td>`

		}
		option += `</tr>
				</tbody>
			</table>
			</div>`;
		$('#dvPass').append(option);

	})
}

function pesquisarPessoaProcurado() {
	let passporte = $("#procuradoPass").val()
	$('#dvProcurado').empty();
	$.post("http://tbl_policia/requestPassport", JSON.stringify({ user_id: passporte }), (data) => {
		let passport = data.passport;
		let option = `
			<div class="table-responsive">
			<table class="table">
			  <thead>
				<tr>
				  <th> Fone </th>
				  <th> Nome </th>
				  <th> </th>
				</tr>
			  </thead>
			  <tbody>`
		for (let i = 0; i < passport.length; i++) {
			option += `
				<tr>
				  <td>  ${passport[i].phone} </td>
				  <td> ${passport[i].name}  </td>
				  <td>
					<button class="badge btn-outline-info" onclick="addProcurado('${passport[i].user_id}')">Adicionar</button>
				  </td>`

		}
		option += `</tr>
				</tbody>
			</table>
			</div>`;
		$('#dvProcurado').append(option);

	})
}

function addPolicial(user_id) {
	$.post("http://tbl_policia/addPolicial", JSON.stringify({ user_id: user_id, cargo_id: 3 }), (data) => {

	})
	$('#myModal').modal('hide');
	getPoliciais()
}

function alterarCargo(id) {
	let cargo = $("#txtCargo").val()
	$.post("http://tbl_policia/updateCargo", JSON.stringify({ cargo: cargo, id: id }), (data) => { })
	$('#myModal').modal('hide');
	getCargos()
}

function getPoliciais() {
	$("#policialTable").empty();
	$.post("http://tbl_policia/buscaPolicial", "", (data) => {
		let arrPolicial = data.policial;
		let option = ""
		for (let i = 0; i < arrPolicial.length; i++) {
			option += `
				<tr>
				  <td> ${arrPolicial[i].user_id} </td>
				  <td> ${arrPolicial[i].nome_policial}  </td>
				  <td> ${arrPolicial[i].fone_Policial} </td>
				  <td> ${arrPolicial[i].cargo} </td>
				  <td> ${arrPolicial[i].cria_lei} </td>
				  <td>
				  	<button class="badge btn-outline-info" onclick="modalDinamicUpdUser('${arrPolicial[i].id_policia}',' ${arrPolicial[i].user_id}','${arrPolicial[i].nome_policial}',${arrPolicial[i].cargo_id}, '${arrPolicial[i].cria_lei}', '${arrPolicial[i].ativo}')">Alterar</button>
				  </td><td>`
			if (arrPolicial[i].ativo === 'S') {
				option += `	<button class="badge badge-outline-danger" onclick="updatePolicial('${arrPolicial[i].id_policia}','N',${arrPolicial[i].cargo_id}, '${arrPolicial[i].cria_lei}')">Inativar</button>`
			} else {
				option += `<button class="badge badge-outline-success" onclick="updatePolicial('${arrPolicial[i].id_policia}','N',${arrPolicial[i].cargo_id}, '${arrPolicial[i].cria_lei}')">Ativar</button>`
			}
			option += `	  </td>
				</tr>`
		}

		$('#policialTable').append(option);

	})
}

function getCargos() {
	$("#cargoTable").empty();
	$.post("http://tbl_policia/buscaCargos", "", (data) => {
		let arrCargos = data.cargos;
		let option = ""
		for (let i = 0; i < arrCargos.length; i++) {
			option += `
				<tr>
				  <td> ${arrCargos[i].cargo} </td>
				  <td>`
			option += `<button class="badge badge-outline-success" onclick="modalDinamicCargo('${arrCargos[i].id}', '${arrCargos[i].cargo}')">Alterar</button>`
			option += `	  </td>
				</tr>`
		}

		$('#cargoTable').append(option);

	})
}

function addMulta() {
	$("#multaPassValid").hide()
	$("#multaValorValid").hide()
	let multaValor = $("#multaValor").val()
	let multaPass = $("#multaPass").val()
	if (multaPass === 0 || multaValor <= 0) {
		if (multaPass === 0 || !multaPass) {
			$("#multaPassValid").show()
		}
		if (multaValor === 0 || !multaValor) {
			$("#multaValorValid").show()
		}
	} else {
		$.post("http://tbl_policia/Multas",
			JSON.stringify({ id: multaPass, valor: multaValor }), (data) => { })
	}

}

function prender() {
	$("#prenderPassValid").hide()
	$("#prenderValorValid").hide()
	let prenderValor = $("#prenderValor").val()
	let prenderPass = $("#prenderPass").val()
	if (prenderPass === 0 || prenderValor <= 0) {
		if (prenderPass === 0 || !prenderPass) {
			$("#prenderPassValid").show()
		}
		if (prenderValor === 0 || !prenderValor) {
			$("#prenderValorValid").show()
		}
	} else {
		$.post("http://tbl_policia/prender",
			JSON.stringify({ user_id: prenderPass, tempo: prenderValor }), (data) => { })
	}

}

function addDetido() {
	$("#detidoPassValid").hide()
	$("#detidoValorValid").hide()
	let multaValor = $("#detidoValor").val()
	let multaPass = $("#detidoPass").val()
	if (multaPass === 0 || multaValor <= 0) {
		if (multaPass === 0 || !multaPass) {
			$("#multaPassValid").show()
		}
		if (multaValor === 0 || !multaValor) {
			$("#multaValorValid").show()
		}
	} else {
		$.post("http://tbl_policia/detido",
			JSON.stringify({ id: multaPass, valor: multaValor }), (data) => { })
	}

}

function getProcurados() {
	$('#procuradoTable').empty();
	$.post("http://tbl_policia/getProcurados", "", (data) => {
		let procurados = data.procurados;
		console.log(procurados);
		let option
		for (let i = 0; i < procurados.length; i++) {
			option += `
			<tr>
			  <td>  ${procurados[i].user_id} </td>
			  <td> ${procurados[i].name}  </td>
			  <td>
				<button class="badge btn-outline-info" onclick="dellProcurado('${procurados[i].user_id}')">Remover</button>
			  </td>`
		}
		$('#procuradoTable').append(option);
	});

}

function dellProcurado(user_id) {
	$.post("http://tbl_policia/dellProcurados", JSON.stringify({ user_id: user_id }), (data) => { })
	openDiv('procurado')
}

function addProcurado(user_id) {
	$.post("http://tbl_policia/addProcurado", JSON.stringify({ user_id: user_id, cargo_id: 3 }), (data) => {
	})
	$('#dvProcurado').empty();
	$('#procuradoPass').val("");
	openDiv('procurado')
}

function getAllLeis() {
	$.post("http://tbl_policia/getUserData", "", (data) => {
		let arrUserData = data.userData
		for (let i = 0; i < arrUserData.length; i++) {
			console.log(arrUserData[i].cria_lei)
			lei = arrUserData[i].cria_lei
			if (lei === 'N') {
				$("#dvCriaLei").hide()
			} else {
				$("#dvCriaLei").show()
			}
			criTblLei()
		}
	})
	
}

function criTblLei(){
	$('#leisTable').empty();
	$.post("http://tbl_policia/getAllLeis", "", (data) => {
		let leis = data.leis;
		let option
		for (let i = 0; i < leis.length; i++) {
			option += `
			<tr>
			  <td> ${leis[i].artigo}  </td>
			  <td> ${leis[i].crime}  </td>
			  <td>  ${leis[i].servico} </td>
			  <td>`

			if (lei == 'S') {
				option += ` <button class="badge btn-outline-info" onclick="delLeis('${leis[i].id}')">Remover</button>`
			}
			option += ` </td>`
		}
		$('#leisTable').append(option);
	});
}

function delLeis(id) {
	$.post("http://tbl_policia/delLeis", JSON.stringify({ id: id }), (data) => { })
	openDiv('leis')
}

function addLeis() {
	let artigo = $("#leisArtigo").val()
	let crime = $("#leisCrime").val()
	let servico = $("#leisServico").val()
	$.post("http://tbl_policia/addLeis", JSON.stringify({ artigo, crime, servico }), (data) => {
	})
	$("#leisArtigo").val("")
	$("#leisCrime").val("")
	$("#leisServico").val("")
	getAllLeis()
}

function getAllRelatorios() {
	$('#relatoriosTable').empty();
	$.post("http://tbl_policia/getAllRelatorios", "", (data) => {
		let relatorios = data.relatorios;
		let option
		for (let i = 0; i < relatorios.length; i++) {
			option += `
			<tr>
			  <td> ${relatorios[i].id}  </td>
			  <td> ${relatorios[i].artigo}  </td>
			  <td> ${relatorios[i].name}  </td>
			  <td>
				<button class="badge btn-outline-info" 
				onclick="modalDinamicUpdRelatorio('${relatorios[i].descricao}','${relatorios[i].artigo}','${relatorios[i].id}')">
				Alterar</button>
			  </td>`
		}
		$('#relatoriosTable').append(option);
	});
}

function getAllLeisRelat() {
	$('#cmbLeis').empty();
	$.post("http://tbl_policia/getAllLeis", "", (data) => {
		leisRelatoios = data.leis;
		let option
		for (let i = 0; i < leisRelatoios.length; i++) {
			option += `
			<option value="${leisRelatoios[i].id}">${leisRelatoios[i].artigo} </option>`
		}
		$('#cmbLeis').append(option);
	});
}

function modalDinamicAddRelatorio() {
	id_relatorio = 0
	$(".modal-content").empty();
	getAllLeisRelat()
	let header = `<div class="modal-header"> 
    <h4 class="modal-title modal-text">Adicionar Relatorio</h4> </div>
    <div class="modal-body">
    <div class='row'>
        <div class="col-12">
		     <select  class='modal-text' id="cmbLeis" name="cmbLeis" id="cmbLeis">
			    <option  class='modal-text' value="0">Selecione um artigo</option>
	          </select>
        </div>
		<div class="col-12">
		    <textarea  class='modal-text' id="descricaoRelatorio" name="descricaoRelatorio" cols="40" rows="8"></textarea>
        </div>
	</div>
    <div class="modal-footer">      
	   <button type="button" class="badge btn-light" onclick="addRelatorio()">Adicionar</button>
       <button type="button" class="badge btn-light" data-dismiss="modal">Close</button>
    </div>`;

	$(".modal-content").append(header)

	$("#myModal").modal({
		show: true
	});
}

function modalDinamicUpdRelatorio(descricao, artigo, idRelat) {
	id_relatorio = idRelat
	let descricao_converter = String(descricao)
	console.log(descricao_converter)
	$(".modal-content").empty();

	let header = `<div class="modal-header"> 
    <h4 class="modal-title modal-text">Adicionar Relatorio</h4> </div>
    <div class="modal-body">
    <div class='row'>
        <div class="col-12">
		   <h2>${artigo}</h2>
		</div>
		<div class="col-12">
		    <textarea class='modal-text' id="descricaoRelatorio"  name="descricaoRelatorio" cols="40" rows="8"> ${descricao_converter} </textarea>
        </div>
	</div>
    <div class="modal-footer">      
	   <button type="button" class="badge btn-light" onclick="addRelatorio()">Adicionar</button>
       <button type="button" class="badge btn-light" data-dismiss="modal">Close</button>
    </div>`;

	$(".modal-content").append(header)

	$("#myModal").modal({
		show: true
	});
}

function addRelatorio() {
	let descricao = $('#descricaoRelatorio').val();
	let lei_id = $("#cmbLeis option:selected").val();
	console.log(lei_id);
	$.post("http://tbl_policia/updRelatorio", JSON.stringify({ descricao: descricao, lei_id: lei_id, id_relatorio: id_relatorio }), (data) => { });
	getAllRelatorios()
	$('#myModal').modal('hide');
}

function getCargosCombo() {
	$("#cmdCargo").empty();
	$.post("http://tbl_policia/buscaCargos", "", (data) => {
		let arrCargos = data.cargos;
		let option = ""
		for (let i = 0; i < arrCargos.length; i++) {
			option += ` <option  class='modal-text' value=" ${arrCargos[i].id}">${arrCargos[i].cargo}</option>`
		}

		$('#cmdCargo').append(option);

	})
}

function modalDinamicUpdUser(id, passaporte, nome, cargo_id, cria_lei, ativo) {
	console.log('entrou')
	$(".modal-content").empty();
	getCargosCombo()
	let header = `<div class="modal-header"> 
    <h4 class="modal-title modal-text">Alterar Dados Policial</h4> </div>
    <div class="modal-body">
    <div class='row'>
        <div class="col-6">
		     <h4> Passaporte </h4>
             <h4> ${passaporte} </h4>         
        </div>
		<div class="col-6">
		   <h4> Nome </h4>
		   <h4> ${nome} </h4>
	   </div>
	   <div class="col-6">
	       <h4> Cargo </h4>
			<select  class='modal-text' value=' ${cargo_id}' id="cmdCargo" name="cmdCargo" >
				<option  class='modal-text' value="0">Selecione um cargo</option>
			</select>
	   </div>
	   <div class="col-6">
	        <h4> Permite Criar Lei </h4>
			<select  class='modal-text' value=' ${cria_lei}' id="cmdCriaLei" name="cmdCriaLei" >
				<option  class='modal-text' value="N">Não</option>
				<option  class='modal-text' value="S">Sim</option>
			</select>
	  </div>
	</div>
    <div class="modal-footer">      
	   <button type="button" class="badge btn-light" onclick="updatePolicialValid(${id}, '${ativo}')">Aceitar</button>
       <button type="button" class="badge btn-light" data-dismiss="modal">Close</button>
    </div>`;

	$(".modal-content").append(header)

	$("#myModal").modal({
		show: true
	});
}

function updatePolicialValid(id, ativo) {
	let cargoId = $("#cmdCargo option:selected").val();
	let criaLei = $("#cmdCriaLei option:selected").val();
	if (cargoId == 0) {
		return
	}
	updatePolicial(id, ativo, cargoId, criaLei)
}

function updatePolicial(id, ativo, cargo, cria_lei) {
	$.post("http://tbl_policia/updatePolicia", JSON.stringify({ id: id, ativo: ativo, cargo: cargo, cria_lei: cria_lei }), (data) => { })
	$('#myModal').modal('hide');
	openDiv('policial')
}