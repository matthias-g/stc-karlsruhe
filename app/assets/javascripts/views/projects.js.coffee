
# submit handler for the project list filter
filterProjectList = (e, obj) ->
  e.preventDefault()
  $('#project-list').load '?' + parametrize(obj) + ' #project-list > *', ->
    $('img', @).lazyload()
    $('#filterResults').text 'Gefundene Aktionen: ' + $(@).children().size()

# handler for "add leader" select
@addNewLeader = (userId, html) ->
  projectId = html.data('project-id')
  data = {
    'data': [
      { 'type': 'users', 'id': userId }
    ]
  }
  window.requestToJsonApi("/api/projects/#{projectId}/relationships/leaders", 'POST', data).done ->
    location.reload()

# project edit: load weekdays of selected week
updateDaysOnWeekChange = ->
  weekId = @.value
  window.getResource('project-weeks', weekId, { 'include': 'days'}).done (projectWeek) ->
    daySelect = $('.days select').empty()
    for day in projectWeek.days
      $('<option>').attr(value: day.id).text(day.title).appendTo daySelect
    
    
      
onPageLoad ->
  # update project list if filter changes
  onFieldChange $('#projectFilter'), filterProjectList

  # update available days when week selction changes
  $('#project-edit-view .week select').change updateDaysOnWeekChange
