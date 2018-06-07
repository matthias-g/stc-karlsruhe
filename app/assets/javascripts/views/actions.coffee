onViewLoad 'actions->edit, actions->new', ->

  # update available parent actions when week selection changes
  $('.week select').change ->
    window.getResource('action-groups', @.value, include: 'actions').done (action_group) ->
      select_element = $('.parent_action select').empty()
      for action in action_group.actions
        $('<option>').attr(value: action.id).text(action.title).appendTo select_element

  $('#add-action-tag').on 'ajax:success', ->
    list = $('#action-tag-list').empty()
    window.getJsonApi('/api/actions/242/tags').done (response) ->
      for tag in response.data
        list.append('<span>'+tag.attributes.title+'</span>')



onViewLoad 'actions->show, projects->show', =>

  # auto submit uploaded images
  $('form.edit_gallery').each (i, f) ->
    $('input', f).change ->
      $('.waitinfo', f).show()
      $(f).submit()
    $('input[type="submit"]', f).css(visibility: 'hidden')