$(document).ready(function() {
    /* lazyload images (must be activated with lazy:true in image_tag helper) */
    $('img').lazyload();

    /* clip preview texts */
    clipTexts();

    /* find flash messages */
    $('#messages > *').detach().each(function() {
        showMessage($(this));
    });

    /* uncollapse accordion section if it's referenced in the url hash */
    if (location.hash) {
        var target = $(location.hash + '.collapse').collapse('show');
        if (target.size() > 0) {
            $('html, body').scrollTop(target.offset().top - 100);
        }
    }
});

/* clip overflowing text in all .clipText areas within {parent}. */
function clipTexts(parent) {
    $('.clipText', parent).each(function() {
        var p = $(this).children(),
            divh = $(this).height();
        while (p.outerHeight() > divh) {
            p.text(function (index, text) {
                return text.replace(/\W*\s(\S)*$/, '...');
            });
        }
    });
}

/* show a flash message */
function showMessage(htmlstr) {
    var msg = $(htmlstr);
    msg.click(function() {
        msg.fadeOut();
    });
    window.setInterval(function() {
        msg.fadeOut();
    }, 5000);
    $('#messages').append(msg);
}