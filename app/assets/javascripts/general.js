$(document).ready(function() {
    /* lazyload images (must be activated with lazy:true in image_tag helper) */
    $('img').lazyload({threshold: 200});

    /* clip preview texts */
    /*clipTexts();*/

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

    /* Retrieve Facebook likes with the graph API */
    $('.get-likes').each(function() {
        var dst = $(this);
        $.getJSON('https://graph.facebook.com/' + dst.data('fb-page'), function(res) {
            dst.text(res.likes);
        });
    });

    /* Load modal AJAX content */
    $('.modal').on('show.bs.modal', function (event) {
        $('.modal-content', this).load($(event.relatedTarget).attr('href'));
    })
});

/* clip overflowing text in all .clipText areas within {parent}. */
/*function clipTexts(parent) {
    $('.clipText', parent).each(function() {
        var p = $(this).children(),
            divh = $(this).height();
        while (p.outerHeight() > divh) {
            p.text(function (index, text) {
                return text.replace(/\W*\s(\S)*$/, '...');
            });
        }
    });
}*/

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

function sendWithAjax(form) {
    var url = $(form).attr('action') +'?'+ $(form).serialize();
    var res = $('<div>').load(url + ' #messages > *', function() {
        res.children().each(function(i, e) {
            showMessage($(e));
        });
    });
    return false;
}