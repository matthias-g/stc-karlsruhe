$(document).ready(function() {
    var form = $('#projectFilter').submit(function(e) {
        e.preventDefault();
        var params = $.map($(":input", this).serializeArray(), function(a) {
            return a.name + '=' + a.value;
        }).join('&');
        $('#project-list').load('/projects?' + params + ' #project-list > *');
    });
});