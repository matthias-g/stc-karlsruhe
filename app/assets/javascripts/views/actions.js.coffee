onViewLoad 'actions->edit, actions->new', ->

  # update available parent actions when week selection changes
  $('.week select').change ->
    window.getResource('action_groups', @.value, include: 'actions').done (action_group) ->
      select_element = $('.parent_action select').empty()
      for action in action_group.actions
        $('<option>').attr(value: action.id).text(action.title).appendTo select_element


onViewLoad 'actions->show', ->

  # auto submit uploaded images
  $('form.edit_gallery').each (i, f) ->
    $('gallery-upload', f).change ->
      $('.waitinfo', f).show()
      $(f).submit()
    $('input[type="submit"]', f).css(visibility: 'hidden')


onViewLoad 'actions->edit_leaders', ->

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