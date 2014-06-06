$(document).ready(function() {
    var popupTarget = ' .popupTarget';

    // defines the login/registration popups in the top right corner
    $('.miniPopup').each(function() {
        var container = $(this);
        var link = container.children('a');
        var popup = container.children('div');
        link.click(function() {
            $('.miniPopup').not(container).children('div').fadeOut();
            popup.fadeToggle();
            if (container.hasClass('loadFromLink')) {
                popup.load(link.attr('href') + popupTarget, function() {
                    popup.find('input:not([type="hidden"]), textarea').eq(0).focus();
                });
            }
            return false;
        });
    });

    $.ajaxSetup({
        statusCode: {
            401: function(){
                openPopup("/profile/login" + popupTarget,
                          "/profile/register" + popupTarget);
            }
        }
    });

    // define helper functions
    function openPopup(url, url2) {
        var closeButton = $('<a id="popupClose" alt="Abbrechen" href="#"></a>').click(hidePopup),
            popup = $('#popupInner').empty().append(closeButton);
        if (url2) {
            var cols = $('<div class="two-col-group padded">').appendTo(popup);
            $('<div>').appendTo(cols).load(url, autoFocus);
            $('<div>').appendTo(cols).load(url2);
        } else $('<div>').appendTo(popup).load(url, autoFocus);
        $('#popup').fadeIn().css({display: ''});
        return false;
    }
    function hidePopup() {
        $('#popup').fadeOut();
        return false;
    }
    function autoFocus() {
        $('#popup').find('input:not([type="hidden"]), textarea').eq(0).focus();
    }

    // add popup to html
    if ($('#popup').size() == 0)
        $('body').append($('<div id="popup" style="display:none">'
            +'<div id="popupMiddle"><div id="popupInner"></div></div></div>'));
    // hide popup on clicking aside
    $('#popupMiddle').click(hidePopup).children().click(function(e) {
        e.stopPropagation();
    });
    // open popup links in popup
    $('a.openInPopup').click(function() {
        var link = $(this),
            url = link.attr('href') + popupTarget;
        return (link.hasClass('dualPopup')) ? openPopup(url, url) : openPopup(url);
    });
});