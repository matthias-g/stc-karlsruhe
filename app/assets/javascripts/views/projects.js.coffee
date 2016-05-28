
# submit handler for the project list filter
filterProjectList = (e, obj) ->
  e.preventDefault()
  $('#project-list').load '?' + parametrize(obj) + ' #project-list > *', ->
    $('img', @).lazyload()
    $('#filterResults').text 'Gefundene Projekte: ' + $(@).children().size()

# handler for "add leader" select
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
    
    
      
onPageLoad ->
  # update project list if filter changes
  onFieldChange $('#projectFilter'), filterProjectList

  # update available days when week selction changes
  $('#project-edit-view .week select').change updateDaysOnWeekChange
  
  # update leaders when a new leader is selected
  $('#select-new-leader').on 'changed.bs.select', addNewLeader

