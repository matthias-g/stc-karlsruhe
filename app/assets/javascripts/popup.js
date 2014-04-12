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
});