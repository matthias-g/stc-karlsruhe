$(document).ready(function() {
    $('.miniPopup').each(function() {
        var container = $(this);
        var link = container.children('a');
        var popup = container.children('div');
        link.click(function() {
            $('.miniPopup').not(container).children('div').fadeOut();
            popup.fadeToggle();
            popup.load(link.attr('href') + ' #popupTarget', function() {
                popup.find('input:not([type="hidden"]), textarea').eq(0).focus();
            });
            return false;
        });
    });

    // define helper functions
    function showPopup() {
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
            closeButton = $('<a id="popupClose" alt="Abbrechen" href="#"></a>').click(hidePopup),
            popup = $('#popupInner').empty().append(closeButton),
            url = link.attr('href') + ' #popupTarget';
        showPopup();
        if (link.hasClass('dualPopup')) {
            var cols = $('<div class="two-col-group">').appendTo(popup);
            $('<div>').appendTo(cols).load(url, autoFocus);
            $('<div>').appendTo(cols).load(url);
        } else popup.load(url, autoFocus);
        return false;
    });
});