onViewLoad 'actions->edit, actions->new', ->

  # update available parent actions when week selection changes
  $('.week select').change ->
    apiGet('action-groups', @.value, include: 'actions').done (action_group) ->
      select_element = $('.parent_action select').empty()
      for action in action_group.actions
        $('<option>').attr(value: action.id).text(action.title).appendTo select_element


onViewLoad 'actions->show, projects->show', =>

  # auto submit uploaded images
  $('form.edit_gallery').each (i, f) ->
    $('input', f).change ->
      $('.waitinfo', f).show()
      $(f).submit()
    $('input[type="submit"]', f).css(visibility: 'hidden')