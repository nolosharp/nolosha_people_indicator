const colors = {
    green: {filter: 'invert(56%) sepia(11%) saturate(2366%) hue-rotate(79deg) brightness(104%) contrast(89%)', color: '#3FB754'},
    yellow: {filter:'invert(81%) sepia(26%) saturate(7497%) hue-rotate(337deg) brightness(104%) contrast(96%)', color: '#FF8C00FF'},
    red: {filter:'invert(15%) sepia(81%) saturate(7433%) hue-rotate(359deg) brightness(104%) contrast(115%)', color: '#FF0000FF'}
}

$("document").ready(function () {
    $("body").hide();
})

window.addEventListener('message',  (event) => {
    const action = event.data.action;

    switch (action) {
        case 'show':
            $("body").show();
            break
        case 'setColor':
            setColor(event.data.color)
            break
        case 'hide':
            $("body").hide();
            break
        default:
            break
    }
})

function setColor(color) {
    const colorCss = colors[color]

    // $('#crowd-indicator').css('border', `3px solid ${colorCss.color}`)
    $('#crowd-logo').css('filter', colorCss.filter)
}
