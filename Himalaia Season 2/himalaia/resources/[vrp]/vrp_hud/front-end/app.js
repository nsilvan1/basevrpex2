// LOGO AREA



const functions = {
    setTime: (data) => {
        let time = document.getElementById("time");
        time.innerHTML = data.value
    },
    setLocation: (data) => {
        let location = document.getElementById("rua");
        location.innerHTML = data.value
    },
    setHealth: (data) => {
        $('.healthDisplay').css('width', data.value + "%")
    },
    setSpeed: (data) => {
        bar.set(
            data.value,
            false
        )
    },
    setDurability: (data) => {
        engine.set(
            data.value,
            true
        )
    },
    setFuel: (data) => {
        fuel.set(
            data.value,
            false
        )
    },
    setLight: (data) => {
        if (data.value === "alto") {
            $(".lightIcon").addClass("light-active");
        }
        if (data.value === "normal") {
            $(".lightIcon").addClass("light-active");
        }
        if (data.value === "off") {
            $(".lightIcon").removeClass("light-active");
        }
    },
    setMarcha: (data) => {
        let marcha = document.getElementById("marcha");
        marcha.innerHTML = data.value
    },
    setMotor: (data) => {
        if (data.value === false) {
            $(".motor i").addClass("carActive")
            $(".motor i").removeClass("carInactive")
        } else if (data.value === true) {
            $(".motor i").addClass("carInactive")
            $(".motor i").removeClass("carActive")
        }
    },
    setArmour: (data) => {
        $('.armourDisplay').css('width', data.value + "%");
        if (data.value === 0) {
            $(".armour").css("display", "none");
            $(".velocimetro").css("bottom", "0")
        } else {
            $(".armour").css("display", "flex");
            $(".velocimetro").css("bottom", "0")
        }
    },
    setCinto: (data) => {
        if (data.value == false) {
            $(".seatbelt").css('display', "block")
            $(".seatbelt-on").css('display', 'none')
        } else if (data.value == true) {
            $(".seatbelt-on").css('display', "block")
            $(".seatbelt").css('display', "none")
        }
    },
    setDisplay: (data) => {
        if (data.value === false) {
            $(".container").css("opacity", "0")
        } else {
            $(".container").css("opacity", "1")
        }
    },
    micColor: (data) => {
        if (data.value == true) {
            $(".active").addClass("talking")
        } else {
            $(".active").removeClass("talking")
        }
    },
    hudChannel: (data) => {
        let frequencia = document.getElementById("frequencia")
        frequencia.innerHTML = data.value
    },
    hudMode: (data) => {
        if (data.value == 1) {
            $(".one").addClass("active")
            $(".two").removeClass("active")
            $(".three").removeClass("active")
        } else if (data.value == 2) {
            $(".one").addClass("active")
            $(".two").addClass("active")
            $(".three").removeClass("active")
        } else if (data.value == 3) {
            $(".one").addClass("active")
            $(".two").addClass("active")
            $(".three").addClass("active")
        }
    },
    setProgress: (data) => {
        if (data.progress) {
            $(".progress").css("display", "block")
            var TempDuracaoMili = data.value;
            var TempoDuracaoS = (TempDuracaoMili / 1000);
            let root = document.documentElement;
            root.style.setProperty('--tempoduracao', TempoDuracaoS + 's');
            setTimeout(function () {
                $(".progress").css("display", "none")
            }, TempDuracaoMili);
        }
    },
}

window.addEventListener("message", function (event) {
    let action = event.data.action;
    if (functions[action]) functions[action](event.data);
});

let cache = 0;

$(document).ready(function () {
    var sound = new Audio('sound.mp3');
    sound.volume = 0.5;
    let blocked = false
    let list = []
    document.onkeyup = function(data){
        if (data.which == 27){
            hideAll()
            $.post("http://vrp_notifypush/focusOff")
        }
    }

    $(document).on("click",".notify-button",function(){
        $.post("http://vrp_notifypush/setWay",JSON.stringify({ x: $(this).attr("data-x"), y: $(this).attr("data-y") }))
    })

    const hideAll = () => {
        blocked = false
        $(".notifications").css("overflow","hidden")
        $(".notifications").html("")
    }

    const addNotification = data => {
        if (list.length > 9) list.shift()

        const html = `
            <div class="notification">
                <div class="notify-info">
                    <div class="notify-title">
                        <div class="notify-code">911</div>
                        <div class="notify-ttext"> ${data.title}</div>
                    </div>
                    <div class="notify-body">
                        ${data.badge === undefined ? "" : `<span><i class="fas fa-id-badge"></i><span> ${data.badge}</span></span>`}
                        ${data.loc === undefined ? "" : `<span><i class="fas fa-globe-europe"></i><span> ${data.loc}</span></span>`}
                        ${data.dir === undefined ? "" : `<span><i class="fas fa-compass"></i><span> ${data.dir}</span></span>`}
                        ${data.veh === undefined ? "" : `<span><i class="fas fa-car-side"></i><span> ${data.veh}</span></span>`}
                        ${data.color === undefined ? "" : `<span><i class="fas fa-palette"></i><span> ${data.color}</span></span>`}
                    </div>
                </div>

            <div data-x="${data.x}" data-y="${data.y}" class="notify-button"><i class="fas fa-map-marker-alt fa-lg"></i></div>
        </div>`

        list.push(html)

        if (!blocked){
            $(html).prependTo(".notifications")
            .hide()
            .show("slide", { direction: "right" }, 250)
            .delay(5000)
            .hide("slide", { direction: "right" }, 250)
        }
    }

    const showLast = () => {
        hideAll()
        blocked = true

        $(".notifications").css("overflow-y", "scroll")
        for (i in list) {
            $(list[i]).prependTo(".notifications")
        }
    }
    window.addEventListener("message", function (event) {
        switch (event.data.action) {
            case "update":
                $(".velocimetro").addClass("hideSpeedometer");
                $(".velocimetro").removeClass("showSpeedometer");
                break;
            case "inCar":
                $(".velocimetro").addClass("showSpeedometer");
                $(".velocimetro").removeClass("hideSpeedometer");
                if (cache == 0) {
                    $(".seatbelt").css('display', "block");
                    $(".seatbelt-on").css('display', "none")
                    cache++;
                }
                break;
            case 'notify':
                addNotification(event.data.data)
                break

            case 'showAll':
                if (list.length > 0) {
                    showLast()
                    $.post("http://vrp_notifypush/focusOn")
                }
                break
        }
        if (event.data.action == 'open') {
            var number = Math.floor((Math.random() * 1000) + 1);
            $('.notify').append(`
            <div class="wrapper-${number}">
                <div class="notification_main-${number}">
                    <div class="title-${number}"></div>
                    <div class="text-${number}">
                        ${event.data.message}
                    </div>
                </div>
            </div>`)
            $(`.wrapper-${number}`).css({
                "margin-bottom": "10px",
                "width": "275px",
                "margin": "0 0 8px -180px",
                "border-radius": "15px"
            })
            $('.notification_main-' + number).addClass('main')
            $('.text-' + number).css({
                "font-size": "12px"
            })

            if (event.data.type == 'sucesso') {
                $(`.title-${number}`).html("Sucesso").css({
                    "font-size": "16px",
                    "font-weight": "600"
                })
                $(`.notification_main-${number}`).addClass('success-icon')
                $(`.wrapper-${number}`).addClass('success')
                sound.play();
            } else if (event.data.type == 'importante') {
                $(`.title-${number}`).html("Importante").css({
                    "font-size": "16px",
                    "font-weight": "600"
                })
                $(`.notification_main-${number}`).addClass('info-icon')
                $(`.wrapper-${number}`).addClass('info')
                sound.play();
            } else if (event.data.type == 'negado') {
                $(`.title-${number}`).html("Negado").css({
                    "font-size": "16px",
                    "font-weight": "600"
                })
                $(`.notification_main-${number}`).addClass('error-icon')
                $(`.wrapper-${number}`).addClass('error')
                sound.play();
            } else if (event.data.type == 'aviso') {
                $(`.title-${number}`).html("Aviso").css({
                    "font-size": "16px",
                    "font-weight": "600"
                })
                $(`.notification_main-${number}`).addClass('warning-icon')
                $(`.wrapper-${number}`).addClass('warning')
                sound.play();
            } else if (event.data.type == 'sms') {
                $(`.title-${number}`).html(event.data.title).css({
                    "font-size": "16px",
                    "font-weight": "600"
                })
                $(`.notification_main-${number}`).addClass('sms-icon')
                $(`.wrapper-${number}`).addClass('sms')
                sound.play();
            } else if (event.data.type == 'long') {
                $(`.title-${number}`).html(event.data.title).css({
                    "font-size": "16px",
                    "font-weight": "600"
                })
                $(`.notification_main-${number}`).addClass('long-icon')
                $(`.wrapper-${number}`).addClass('long')
                sound.play();
            }
            anime({
                targets: `.wrapper-${number}`,
                translateX: -60,
                duration: 750,
                easing: 'spring(5, 100, 35, 10)',
            })
            setTimeout(function () {
                anime({
                    targets: `.wrapper-${number}`,
                    translateX: 500,
                    duration: 750,
                    easing: 'spring(5, 80, 5, 0)'
                })
                setTimeout(function () {
                    $(`.wrapper-${number}`).remove()
                }, 750)
            }, event.data.time)
        }
    })
});