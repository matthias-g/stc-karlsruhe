$ ->
  $('#user-view .survey form').submit (event) ->
    event.preventDefault()
    form = $(this)
    url = '/api' + form.attr('action')

    inputs = form.find(':input')
    values = {}
    inputs.each ->
      values[this.name] = $(this).val()

    hasEmptyValue = false
    for key, value of values
      if (!value || value.trim() == '')
        hasEmptyValue = true

    if (hasEmptyValue)
      createFlashMessage 'Das Feld darf nicht leer sein.', 'warning'
      return;

    callback = (response) ->
      createFlashMessage 'Vielen Dank für deine Rückmeldung!'
      $('#user-view .survey').slideUp 800
    $.post url, values, callback, 'json'
