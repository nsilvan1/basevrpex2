const imagesUrl = "nui://vrp_inventory/nui/images/";

const Routes = {
    load: function(title, items) {
      $(".craft-items").html("");
      $.each(items, function(index, element) {
          $(".craft-items").append(`
           <div class="item list-item">
              <div class="item-photo" style="
              -webkit-mask-image: linear-gradient(to left, transparent 25%, black 100%);"><img src="${imagesUrl + (element.image ? element.image : index)}.png"></div>
              <div class="item-desc">
                <small>Item</small>
                <span>${element.name}</span>
              </div>
              <button onclick="Routes.selectRoute('${index}')"><i class="fas fa-play-circle icon"></i> SELECIONAR</button>
          </div>
      `);
      });
    },
    selectRoute: function(code) {
      Routes.callServer("selectRoute", {code: code});
    },
    callServer: function(endpoint, data, callback) {
      $.post("http://contrabando/" + endpoint, JSON.stringify(data), callback);
    }
};

document.onkeyup = function(data) {
  if (data.which == 27) {
    Routes.callServer("exit", {});
  }
};

$('.close').on('click', function() {
    Routes.callServer("exit", {});
});
    
window.addEventListener("message", function(event) {
    var action = event.data.action;
    switch(action) {
      case "open":
        Routes.load(event.data.title, event.data.items);
        $("body").show();
      break;
      case "exit":
        $("body").hide();
      break;
    }
});