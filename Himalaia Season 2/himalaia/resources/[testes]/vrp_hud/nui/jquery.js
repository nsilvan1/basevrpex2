$(document).ready(function() {
    window.addEventListener("message", function(event) {

        if (event.data.hud !== undefined) {
            if (event.data.hud == true) {
                $("#displayHud").css("display", "block");
            } else {
                $("#displayHud").css("display", "none");
            }
            return
        }

        /* if (event.data.talking == true) {
            if (event.data.voice == 1) {
                $("#voice01").css("background", "rgba(255,255,0,0)");
                $("#voice02").css("background", "rgba(255,255,0,0)");
                $("#voice03").css("background", "rgba(255,255,0,0.5)");
            } else if (event.data.voice == 2) {
                $("#voice01").css("background", "rgba(255,255,0,0)");
                $("#voice02").css("background", "rgba(255,255,0,0.5)");
                $("#voice03").css("background", "rgba(255,255,0,0.5)");
            } else if (event.data.voice == 3) {
                $("#voice01").css("background", "rgba(255,255,0,0.5)");
                $("#voice02").css("background", "rgba(255,255,0,0.5)");
                $("#voice03").css("background", "rgba(255,255,0,0.5)");
            }
        } else {
            if (event.data.voice == 1) {
                $("#voice01").css("background", "rgba(255,255,255,0)");
                $("#voice02").css("background", "rgba(255,255,255,0)");
                $("#voice03").css("background", "rgba(255,255,255,0.5)");
            } else if (event.data.voice == 2) {
                $("#voice01").css("background", "rgba(255,255,255,0)");
                $("#voice02").css("background", "rgba(255,255,255,0.5)");
                $("#voice03").css("background", "rgba(255,255,255,0.5)");
            } else if (event.data.voice == 3) {
                $("#voice01").css("background", "rgba(255,255,255,0.5)");
                $("#voice02").css("background", "rgba(255,255,255,0.5)");
                $("#voice03").css("background", "rgba(255,255,255,0.5)");
            }
        } */

        if (event.data.heal <= 1) {
            $("#displayHealth").css("height", "0");
        } else {
            $("#displayHealth").css("height", event.data.heal + "%");
        }

        if (parseInt(event.data.armor) > 0) {
            $("#backArmour").css("display", "block")
            $("#displayArmour").css("height", event.data.armor + "%");
        } else {
            $("#backArmour").css("display", "block")
        }

        $("#displayWater").css("height", 100 - event.data.thirst + "%");
        $("#displayFood").css("height", 100 - event.data.hunger + "%");
        $("#displayStress").css("height", event.data.heal + "%");

        if (event.data.hours <= 9) {
            event.data.hours = "0" + event.data.hours
        }

        if (event.data.minutes <= 9) {
            event.data.minutes = "0" + event.data.minutes
        }

        if (event.data.incar !== undefined) {
            if (event.data.incar == true) {
                var status = document.getElementById("displayTop");
                if (status.style.display !== "block") {
                    $("#displayTop").css("display", "block");
                }

                if (event.data.cinto) {
                    $("#seatBelt-on").css("display", "block");
                    $("#seatBelt-off").css("display", "none");
                } else {
                    $("#seatBelt-off").css("display", "block");
                    $("#seatBelt-on").css("display", "none");
                }

                $("#gasoline").html("GAS <s>" + parseInt(event.data.gas) + "</s>");
                $("#mph").html("KM <s>" + parseInt(event.data.speed) + "</s>");
            } else {
                var status = document.getElementById("displayTop");
                if (status.style.display !== "none") {
                    $("#displayTop").css("display", "none");
                }
            }
        }

        $("#displayMiddle").html(event.data.rua + "<s>-</s>" + event.data.hora + ":" + event.data.minuto);
    });
});