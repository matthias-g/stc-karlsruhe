onPageLoad ->
  # update available days when week selection changes
  $('#action-edit-view .week select').change updateDaysOnWeekChange

  # enable datepicker
  $('[data-behaviour~=datepicker]').datepicker(autoclose: true, format: "dd.mm.yyyy", language: 'de')


  # add "remove event" buttons to all events
  $('.events').on('click', '.remove-link', ->
    $(this).prev('input[type=hidden]').attr('value', 1)
    $(this).closest('.event-fields').hide())
  # don't submit the event prototype
  $('#event-prototype').closest('form').submit ->
    $('#event-prototype').remove()

# handler for "add leader" select
@addNewLeader = (userId, html) ->
  actionId = html.data('action-id')
  data = 'data': [type: 'users', id: userId]
  window.requestToJsonApi("/api/actions/#{actionId}/relationships/leaders", 'POST', data).done ->
    createFlashMessage I18n.t 'action.message.leaderAdded'
    location.reload()

# handler for "add volunteer" select
@addNewVolunteer = (userId, html) ->
  actionId = html.data('action-id')
  data = 'data': [type: 'users', id: userId]
  window.requestToJsonApi("/api/actions/#{actionId}/relationships/volunteers", 'POST', data).done ->
    createFlashMessage I18n.t 'action.message.volunteerAdded'
    location.reload()

# action edit: load weekdays of selected week
# TODO: currently not used
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
