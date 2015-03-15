/* project filter on the project index page */

$(document).ready(function() {
  var ajaxSubmitter = function(e, obj) {
    e.preventDefault();
    var params = $.map($(":input", obj).serializeArray(), function(a) {
      return a.name + '=' + a.value;
    }).join('&');
    $('#project-list').load('/projekte?' + params + ' #project-list > *', function() {
      clipTexts($('#project-list'));
      $('#project-list img').lazyload();
      $('#filterResults').text('Gefundene Projekte: ' + $('#project-list > *').size());
    });
  };
  $('#projectFilter').submit(ajaxSubmitter);
  $('#projectFilter select, #projectFilter input').change(ajaxSubmitter);
  $('#projectFilter input[type="submit"]').hide();
});