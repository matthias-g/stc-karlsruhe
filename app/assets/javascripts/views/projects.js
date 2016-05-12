/* project filter on the project index page */

$(document).ready(function() {
  var ajaxSubmitter = function(e, obj) {
    e.preventDefault();
    var params = $.map($(":input", obj).serializeArray(), function(a) {
      return a.name + '=' + a.value;
    }).join('&');
    $('#project-list').load('?' + params + ' #project-list > *', function() {
      //clipTexts($('#project-list'));
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
            $('<option>').attr({value: day.id}).text(day.title).appendTo(daySelect);
        });
    });
}

// TODO Rails 5 http://stackoverflow.com/a/18770589
var ready = function() {
    $('.selectpicker').selectpicker('render');
    $('#select-new-leader').on('changed.bs.select', function(event, clickedIndex, newValue, oldValue) {
        var user = $('#select-new-leader').val();
        var project = $('#select-new-leader').data('project-id');
        $.getJSON('/api/projects/' + project + '/add_leader?user_id=' + user, function(res) {
            location.reload();
        });
    });
};

$(document).ready(ready);
$(document).on('page:load', ready);