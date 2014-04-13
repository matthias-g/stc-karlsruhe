$(document).ready(function() {
    var ajaxSubmitter = function(e) {
        e.preventDefault();
        var params = $.map($(":input", this).serializeArray(), function(a) {
            return a.name + '=' + a.value;
        }).join('&');
        $('#project-list').load('/projects?' + params + ' #project-list > *', function() {
            clipTexts($('#project-list'));
        });
    };
    $('#projectFilter').submit(ajaxSubmitter);
    $('#projectFilter select, #projectFilter input').change(ajaxSubmitter);
    $('#projectFilter input[type="submit"]').hide();

});