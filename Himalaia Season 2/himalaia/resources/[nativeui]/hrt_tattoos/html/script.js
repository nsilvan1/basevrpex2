const TattooStore = {
	currentCategory: null,
	selectedTattoos: {},
	categories: {
		"head": { "title": "Cabeça", "available": [] },
		"torso": { "title": "Peito", "available": [] },
		"leftarm": { "title": "Braço Esquerdo", "available": [] },
		"rightarm": { "title": "Braço Direito", "available": [] },
		"leftleg": { "title": "Perna Esquerda", "available": [] },
		"rightleg": { "title": "Perna Direita", "available": [] }
	},
	changeCategory: function(category){
		$(".category").removeClass("selected");
		TattooStore.currentCategory = category;
		$(".category[category-name='"+category+"']").addClass("selected");
		$("#category-name").html(TattooStore.categories[category]["title"]);

		$("#items").html("");
		$.each(TattooStore.categories[category]["available"],function(index,tattoo){
			let selected =  "";
			let label = index + 1;

			if(TattooStore.selectedTattoos[tattoo.name])
				selected = " selected";

			$("#items").append(`<div class="item${selected}" tattoo-code="${tattoo.name}" tattoo-category="${category}" tattoo-index="${index}">${label}</div>`);
		});

		TattooStore.loadVariableListeners();
	},
	selectTattoo: function(category,index){
		let item = $(".item[tattoo-category='"+category+"'][tattoo-index='"+index+"']");
		if(item.hasClass("selected")){
			item.removeClass("selected");
			delete TattooStore.selectedTattoos[item.attr("tattoo-code")];
		} else {
			TattooStore.selectedTattoos[item.attr("tattoo-code")] = {};
			item.addClass("selected");
		}

		TattooStore.callServer("changeTattoo",{ type: category, id: index });
	},
	resetTattoos: function(){
		$(".item").removeClass("selected");

		TattooStore.selectedTattoos = {};
		TattooStore.callServer("clearTattoo",{});
	},
	loadStaticListeners: function(){
		$(".category").on("click",function(){
			TattooStore.changeCategory($(this).attr("category-name"));
		});

		$("#reset").on("click",function(){
			TattooStore.resetTattoos();
		});

		document.onkeydown = function(data) {
			switch(data.keyCode) {
				case 27:
					$("#tattoo-container").removeClass("open");
					$('.category2').css('right', '-440px')
					TattooStore.callServer("close",{});
				break;

				case 68:
					TattooStore.callServer("rotate","left");
				break;

				case 65:
					TattooStore.callServer("rotate","right");
				break;

				case 88:
					TattooStore.callServer("handsup",{});
				break;
			}
		};
	},
	loadVariableListeners: function(){
		$(".item").on("click",function(){
			TattooStore.selectTattoo($(this).attr("tattoo-category"),$(this).attr("tattoo-index"));
		});
	},
	callServer: function(endpoint,data){
		$.post("http://hrt_tattoos/"+endpoint,JSON.stringify(data));
	},
	load: function(tattoos,selectedTattoos){
		TattooStore.categories = {
			"head": { "title": "Cabeça", "available": [] },
			"torso": { "title": "Peito", "available": [] },
			"leftarm": { "title": "Braço Esquerdo", "available": [] },
			"rightarm": { "title": "Braço Direito", "available": [] },
			"leftleg": { "title": "Perna Esquerda", "available": [] },
			"rightleg": { "title": "Perna Direita", "available": [] }
		};

		$("#tattoo-container").addClass("open");
		$('.category2').css('right', '0')
		TattooStore.selectedTattoos = selectedTattoos;

		$.each(tattoos,function(category,element){
			$.each(element.tattoo,function(index,tattoo){
				TattooStore.categories[category]["available"].push(tattoo);
			});
		});

		TattooStore.changeCategory("head");
		TattooStore.loadStaticListeners();
	}
};

window.addEventListener("message",function(event){
	TattooStore.load(event.data.shop,event.data.tattoo);
});