$(document).ready(function() {
    /* lazyload images (must be activated with lazy:true in image_tag helper) */
    $('img').lazyload({threshold: 200});

    /* clip preview texts */
    /*clipTexts();*/

    extractFlashMessages($('body'));

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
        $.getJSON('https://graph.facebook.com/' + dst.data('fb-page')
            + '?access_token='+ dst.data('fb-token'), function(res) {
            dst.text(res.likes);
        }).fail(function (jqxhr, textStatus, error) {
            var err = textStatus + ", " + error;
            console.log( "Request Failed: " + err );
            console.log(jqxhr.responseJSON);
            dst.parent().hide();
            dst.parent().prev().css('margin-top','15px');
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

function extractFlashMessages(html) {
    $('#messages .alert', html).detach().each(function(i, e) {
        var msg = $(e);
        var close = function() {
            msg.alert('close');
        };
        msg.click(close);
        window.setInterval(close, 5000);
        $('#messages').append(msg);
    });
}

function sendWithAjax(form) {
    var url = $(form).attr('action') +'?'+ $(form).serialize();
    var res = $('<div>').load(url + ' #messages', function() {
        extractFlashMessages(res);
    });
    return false;
}