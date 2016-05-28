
  
# submit handler for the project list filter
filterProjectList = (e, obj) ->
  e.preventDefault()
  $('#project-list').load '?' + parametrize(obj) + ' #project-list > *', ->
    $('#project-list img').lazyload()
    $('#filterResults').text 'Gefundene Projekte: ' + $('#project-list > *').size()
      
addNewLeader = (e, idx, val) ->
  $.ajax '/api/projects/' + $(@).data('project-id') + '/add_leader?user_id=' + val, ->
    location.reload()

# project edit: load weekdays of selected week
updateDaysOnWeekChange = ->
  week = @.value
  $.getJSON '/api/project_weeks/' + week + '/project_days', (res) ->
    daySelect = $('.days select').empty()
    $.each res, (idx, day) ->
      $('<option>').attr(value: day.id).text(day.title).appendTo daySelect    
    
    
ready = ->
  # load select pickers
  $('.selectpicker').selectpicker 'render'
  
  # register submit/change handlers
  submitOnChange $('#projectFilter'), filterProjectList 
  $('#project-edit-view .week select').change updateDaysOnWeekChange
  $('#select-new-leader').on 'changed.bs.select', addNewLeader


# TODO Rails 5 http://stackoverflow.com/a/18770589      
$(document).ready ready
$(document).on 'page:load', ready