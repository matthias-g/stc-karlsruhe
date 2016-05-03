$(document).ready(function () {
    var counter = $('#countdown');
    var fields = counter.find('div span');
    var end = new Date($('#countdown').data('date'));
    var _second = 1000, _minute = _second * 60,
        _hour = _minute * 60, _day = _hour * 24;
    var timer;

    function update() {
        var d = end - new Date();
        if (d < 0) {
            clearInterval(timer);
            counter.find('div').hide();
            counter.find('.running').hide();
            counter.find('.finished').show();
            return;
        }
        fields.eq(0).text(Math.floor(d / _day));
        fields.eq(1).text(('0' + Math.floor((d % _day) / _hour)).slice(-2));
        fields.eq(2).text(('0' + Math.floor((d % _hour) / _minute)).slice(-2));
        fields.eq(3).text(('0' + Math.floor((d % _minute) / _second)).slice(-2));
    }
    timer = setInterval(update, 1000);
    update();
});

$(document).ready(function () {
    $('.bigheader .logo').on('contextmenu', function() {
        var html = "<div class=\"alert alert-info alert-dismissible\" role=\"alert\"> \
            <a href=\"#\" data-dismiss=\"alert\" class=\"close\">×</a> \
            <ul> \
                <li>Möchtest Du unser Logo herunterladen? Auf unserer\
                <a href=\"/presse\">Presseseite</a> findest Du dafür ein\
                <a href=\"/downloads/Logos.zip\">Archiv</a> mit einer Auswahl verschiedener Versionen. </li> \
            </ul> \
            </div>";
        $('#messages').append(html);
        return true;
    });

});