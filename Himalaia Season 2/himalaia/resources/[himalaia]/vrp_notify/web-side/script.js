function notify(img, message, color) {
    let container = document.querySelector('.notifies-container')
    
    let element = document.createElement('div')
    element.classList.add('notify')

    let line = document.createElement('div')
    line.classList.add('notifyLine')
    line.style.backgroundColor = color
    line.classList.add('width')

    element.innerHTML = `
    <div class = 'notifyText'>
        <img src="images/${img}" alt="">
        <p>${message}</p>
    </div>
    `

    element.appendChild(line)

    
    container.appendChild(element)
    element.classList.add('appear')
    
    deleteElement(element)

}

window.addEventListener("message", (event) => {
    let type = event.data.css.toLowerCase()

    let color = ''
    let img = ''

    if (type == 'sucesso') {
        color = '#6FCF97'
        img = 'sucess.svg'
    } else if (type == 'negado') {
        color = '#EB5757'
        img = 'cancel.svg'
    } else if (type == 'importante' || type == 'aviso') {
        color = '#F2994A'
        img = 'warning.svg'
    } else if (type == 'ferimento') {
        color = '#EB5757'
        img = 'ferimento.svg'
    }
	


    notify(img, event.data.message, color)

})


function deleteElement(element) {
    setTimeout(() => {
        element.classList.remove('appear')
        element.classList.add('disappear')
        setTimeout(() => {
            element.remove()
        }, 590);
    }, 4800);
}