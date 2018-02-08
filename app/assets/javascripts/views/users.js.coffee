onPageLoad ->
  # enable survey submission
  $('#users #survey form').submit (e) ->
    e.preventDefault()

    # collect values
    values = {}
    $(':input', @).each ->
      values[@name] = $(@).val()

    # find empty question
    hasEmptyValue = false
    for key, value of values
      if (!value || value.trim() == '')
        hasEmptyValue = true
    if (hasEmptyValue)
      createFlashMessage I18n.t('user.message.fieldEmpty'), 'warning'
      return

    # send survey, then hide it
    callback = (response) ->
      createFlashMessage I18n.t 'user.message.surveySent'
      $('#users #survey').slideUp 800
    $.post ('/api' + $(@).attr('action')), values, callback, 'json'

  # (un)check all mail checkboxes if "#emails_from_orga" checkbox is changed
  $('#emails_from_orga').change ->
    $('.emails-from-orga input').prop(checked: @checked)

  # check "#emails_from_orga" if any other mail checkbox is set
  $.fn.reduce = [].reduce # TODO: bad style to extend jQuery like this
  $('.emails-from-orga input').change ->
    reducer_or = (aggr, e) -> aggr || e.checked
    $('#emails_from_orga').prop(checked: $('.emails-from-orga input').reduce(reducer_or, false))