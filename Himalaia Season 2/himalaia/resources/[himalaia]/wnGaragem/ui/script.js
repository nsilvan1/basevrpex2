$(document).ready(function(){
	let actionContainer = $("#actionmenu");

	window.addEventListener('message',function(event){

		$(".search").on("keyup", function () {
			let search = $(this).val().toLowerCase();
			$(".name").filter(function () {
			  $(this).closest(".lista").toggle($(this).text().toLowerCase().indexOf(search) > -1)
			});
		});

		let item = event.data;
		switch(item.action){
			case 'showMenu':
				updateGarages();
				actionContainer.fadeIn(1000);
				$("#dashboard-2").css(`display`, `none`)
			break;

			case 'hideMenu':
				actionContainer.fadeOut(1000);
			break;

			case 'updateGarages':
				updateGarages();
				
			break;
		}
	});

	document.onkeyup = function(data){
		if (data.which == 27){
			sendData("ButtonClick","exit")
		}
	};
	const updateGarages = () => {
		$.post('http://wnGaragem/myVehicles',JSON.stringify({}),(data) => {
			const nameList = data.vehicles.sort((a,b) => (a.name2 > b.name2) ? 1: -1);
			
			$('#listaVeiculos').html(`
				
				${nameList.map((item) => (`
		
	
				<div class="lista" data-status='${item.status}' data-ipva='${item.ipva}' data-name="${item.name}" data-name2="${item.name2}" data-engine="${item.engine}" data-body="${item.body}" data-fuel="${item.fuel}"><img src="http://localhost/cars/${item.name}.png" alt=""><div class="name">${item.name2}</div></div>

				`)).join('')}
			`);
			var vehicles = document.getElementsByClassName("lista")
			$("#nomeCarro").text($(vehicles[0]).data("name2"))
			$("#nomeCarroo").text($(vehicles[0]).data("name2"))

			// $("#seguro span").text($(vehicles[0]).data("status"))
			// $("#servicos span").text($(vehicles[0]).data("ipva"))
			$("#engine").text(`${$(vehicles[0]).data("engine")}%`)
			$(".div-motor").css(`width`, `${$(this).data("engine")*2}px`)
			$(".div-metal").css(`width`, `${$(this).data("body")*2}px`)
			$(".div-fuel").css(`width`, `${$(this).data("fuel")*2}px`)
			$("#latariapercent").text(`${$(vehicles[0]).data("body")}%`)
			$("#fuel").text(`${$(vehicles[0]).data("fuel")}%`)
			$("#mostraFoto").css("background-image",`url(http://localhost/cars/${$(vehicles[0]).data("name")}.png)`)
			$(vehicles[0]).addClass("active")
		});
		

	}
});

const formatarNumero = (n) => {
	var n = n.toString();
	var r = '';
	var x = 0;

	for (var i = n.length; i > 0; i--) {
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}
	return r.split('').reverse().join('');
}

const sendData = (name,data) => {
	$.post("http://wnGaragem/"+name,JSON.stringify(data),function(datab){});
}


//<div class="lista" style="background-image: url(https://cdn.discordapp.com/attachments/712813091674390560/766505559121199133/Adder-GTAV-Front.webp);"></div>



$(document).on('click','.lista',function(){
	let $el = $(this);
	let isActive = $el.hasClass('active');
	if (isActive) return;
	$('.lista').removeClass('active');
    if(!isActive) $el.addClass('active');
    


    $("#nomeCarro").text($(this).data("name2"))
	$("#nomeCarroo").text($(this).data("name2"))
    // $("#seguro span").text($(this).data("status"))
    // $("#servicos span").text($(this).data("ipva"))
    $("#engine").text(`${$(this).data("engine")}%`)
	$(".div-motor").css(`width`, `${$(this).data("engine")*2}px`)
	$(".div-metal").css(`width`, `${$(this).data("body")*2}px`)
	$(".div-fuel").css(`width`, `${$(this).data("fuel")*2}px`)
    $("#latariapercent").text(`${$(this).data("body")}%`)
    $("#fuel").text(`${$(this).data("fuel")}%`)
	$("#mostraFoto").css("background-image",`url(http://localhost/cars/${$(this).data("name")}.png)`)

});

$(document).on('click','#retirar',function(){
	let $el = $('.lista.active');
	if($el) {
		$.post('http://wnGaragem/spawnVehicles',JSON.stringify({
			name: $el.attr('data-name')
		}));
	}
})

$(document).on('click','.lista',function(){
	$("#dashboard-2").css(`display`, `block`)
})

$(document).on('click','#guardar',function(){
	$.post('http://wnGaragem/deleteVehicles',JSON.stringify({}));
})
