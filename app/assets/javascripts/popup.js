$(document).ready(function() {
    $.ajaxSetup({
        statusCode: {
            401: function(){
                openPopup("/profile/login" + popupTarget);
            }
        }
    });

    // mini popups are the small dropdowns at the topright corner
    $('.miniPopup').each(function() {
        var container = $(this);
        var link = container.children('a');
        var popup = container.children('div');
        link.click(function() {
            $('.miniPopup').not(container).children('div').fadeOut();
            popup.fadeToggle();
            if (container.hasClass('loadFromLink')) {
                popup.load(link.attr('href') + ' #content > *', function() {
                    popup.find('input:not([type="hidden"]), textarea').eq(0).focus();
                });
            }
            return false;
        });
    });

    // add popup to html
    if ($('#popup').size() == 0)
        $('body').append($('<div id="popup" style="display:none">'
            +'<div id="popupMiddle"><div id="popupInner"></div></div></div>'));
    $('#popupMiddle').click(hidePopup).children().click(function(e) {
        e.stopPropagation();
    });

    // open popup links in popup
    $('a.openInPopup').click(function() {
        var link = $(this),
            url = link.attr('href') + ' #content > *';
        return openPopup(url);
    });


    // define helper functions
    function openPopup(content, isHTMLString) {
        var closeButton = $('<a id="popupClose" alt="Abbrechen" href="#"></a>').click(hidePopup),
            popup = $('#popupInner').empty().append(closeButton),
            wrapper = $('<div>').appendTo(popup);
        if (isHTMLString) {
            wrapper.html(content);
            autoFocus(popup);
        } else wrapper.load(content, function() {autoFocus(popup)});
        $('#popup').fadeIn().css({display: ''});
        return false;
    }
    function hidePopup() {
        $('#popup').fadeOut();
        return false;
    }
    function autoFocus(parent) {
        parent.find('input:not([type="hidden"]), textarea').eq(0).focus();
    }
});