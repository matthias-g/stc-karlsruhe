/* project filter on the project index page */

$(document).ready(function() {
  var ajaxSubmitter = function(e, obj) {
    e.preventDefault();
    var params = $.map($(":input", obj).serializeArray(), function(a) {
      return a.name + '=' + a.value;
    }).join('&');
    $('#project-list').load('?' + params + ' #project-list > *', function() {
      clipTexts($('#project-list'));
      $('#project-list img').lazyload();
      $('#filterResults').text('Gefundene Projekte: ' + $('#project-list > *').size());
    });
  };
  $('#projectFilter').submit(ajaxSubmitter);
  $('#projectFilter select, #projectFilter input').change(ajaxSubmitter);
  $('#projectFilter input[type="submit"]').hide();
});

/* Load new weekdays in the project edit view once the week is changed. */
function updateWeekDays() {
    var week = $('.week select').get(0).value;
    $.getJSON('/api/project_weeks/' + week + '/project_days.json', function(res) {
        var daySelect = $('.days select').empty();
        $.each(res, function(idx, day) {
            daySelect.append($('<option value="'+day.id+'">'+day.title+'</option>'));
        });
    });
}