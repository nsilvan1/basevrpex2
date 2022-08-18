
function setVeloBar(velo) {
    let fill_value = 180 * (velo) / (300)

    let fill_element = document.querySelector('.veloFill')

    fill_element.style.width = `${fill_value}%`
}



$(function () {
    $(document).ready(() => { })
    var oldSpeed

    window.addEventListener('message', function (event) {
        var item = event.data;

        if (item.hudoff == true) {
            $('body').fadeOut(500)
        } else if (item.hudoff == false) {
            $('body').fadeIn(500)
        }


        switch (item.action) {
            case 'update':

                $('.hud-carro').fadeOut(500)

                $("#sede").css("width",100-item.sede + "%" );
				$("#vida").css("width",item.health + "%" );
				$("#fome").css("width",100-item.fome +"%" );
        
                if (item.armour == 0){
                    $("#coletediv").hide(0);
                    $("#hud").css("bottom","1.6%");
                } else {
                    $("#hud").css("bottom","6%");
                    $("#coletediv").show(0);
                    $("#colete").css("width",item.armour +"%");
                }
        


                break;
            case 'inCar':

                $("#sede").css("width",100-item.sede + "%" );
				$("#vida").css("width",item.health + "%" );
				$("#fome").css("width",100-item.fome +"%" );
        
                if (item.armour == 0){
                    $("#coletediv").hide(0);
                    $("#hud").css("bottom","1.6%");
                } else {
                    $("#hud").css("bottom","6%");
                    $("#coletediv").show(0);
                    $("#colete").css("width",item.armour +"%");
                }
        
            
                $('.hud-carro').fadeIn(500)

                if(item.speed <= 9) {
                    $('#speed').html('00' + item.speed)
                   
                } else if(item.speed <= 44){
                    $('#speed').html('0' + item.speed)
               
                } else if(item.speed <= 64){
                    $('#speed').html('0' + item.speed)
                   
                } else if(item.speed <= 65){
                    $('#speed').html('0' + item.speed)
                 
                } else if(item.speed <= 99){
                    $('#speed').html('0' + item.speed)
                  
    			} else {
                    $('#speed').html(item.speed)
                  
                }

                

     
                break
            case 'proximity':
                if (item.number == 1) {
                    $('#voicemod').html('Sussurando')
                } else if (item.number == 2) {
                    $('#voicemod').html('Normal')
                } else if (item.number == 3) {
                    $('#voicemod').html('Gritando')
                }
                break;
            case 'talking':
                if (item.boolean) {
                    $('#voicemod').css('color', '#F69F1C')

                } else {
                    $('#voicemod').css('color', '#fff')
                }
                break;
        }
        if (item.only == "updateSpeed") {
            $('.motor').html(item.gear)
            if(item.speed <= 9) {
                $('#speed').html('00' + item.speed)
               
            } else if(item.speed <= 44){
                $('#speed').html('0' + item.speed)
           
            } else if(item.speed <= 64){
                $('#speed').html('0' + item.speed)
               
            } else if(item.speed <= 65){
                $('#speed').html('0' + item.speed)
             
            } else if(item.speed <= 99){
                $('#speed').html('0' + item.speed)
              
            } else {
                $('#speed').html(item.speed)
              
            }

            $('.fuel2').css('width',item.fuel + '%')

            let velo = document.querySelector('.velo')


    
    
            let velo_perc = 100 * (item.speed) / (230)
    
            setVeloBar(velo_perc)

        


        if(item.cinto == true) {
            $(".cinto img").attr("src", "svgs/cintoon.png");
        } else {
            $(".cinto img").attr("src", "svgs/cintooff.png");
        }

        }
    });
})

