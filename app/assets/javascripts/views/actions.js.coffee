
# submit handler for the action list filter
filterActionList = (e, obj) ->
  e.preventDefault()
  $('#action-list').load '?' + parametrize(obj) + ' #action-list > *', ->
    $('img', @).lazyload()
    $('#filterResults').text 'Gefundene Aktionen: ' + $(@).children().size()

# handler for "add leader" select
@addNewLeader = (userId, html) ->
  actionId = html.data('action-id')
  data = {
    'data': [
      { 'type': 'users', 'id': userId }
    ]
  }
  window.requestToJsonApi("/api/actions/#{actionId}/relationships/leaders", 'POST', data).done ->
    location.reload()

# action edit: load weekdays of selected week
# TODO currently not used
updateDaysOnWeekChange = ->
  weekId = @.value
  updateSelect = (actionDays) ->
    daySelect = $('.days select').empty()
    for day in actionDays
      $('<option>').attr(value: day.id).text(day.title).appendTo daySelect
  if weekId
    window.getResource('action-weeks', weekId, {'include': 'days'}).done (actionWeek) ->
      updateSelect(actionWeek.days)
  else
    window.getResources('action-days', {'include': 'action-week'}).done (actionDays) ->
      updateSelect(actionDays.filter (day) -> !day['action-week'])


onPageLoad ->
  # update action list if filter changes
  onFieldChange $('#actionFilter'), filterActionList

  # update available days when week selction changes
  $('#action-edit-view .week select').change updateDaysOnWeekChange

  $('[data-behaviour~=datepicker]').datepicker(autoclose: true, format: "dd.mm.yyyy", language: 'de')
