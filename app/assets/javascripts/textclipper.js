$(document).ready(function() {
    $('.clipText').each(function() {
        var p = $(this).children(),
            divh = $(this).height();
        while (p.outerHeight() > divh) {
            p.text(function (index, text) {
                return text.replace(/\W*\s(\S)*$/, '...');
            });
        }
    });
});