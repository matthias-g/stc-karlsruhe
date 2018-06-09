onPageLoad ->

  $('#newsletter form').submit (e) ->
    e.preventDefault()

    # collect values
    values = {}
    $(':input', @).each ->
      values[@name] = $(@).val()

    # send survey, then hide it
    callback = (response) ->
      createFlashMessage I18n.t('subscription.creation.success')
      $('#newsletter').slideUp 800, -> $(@).remove()

    payload = {
      'type': 'subscriptions',
      'attributes': {
        'email': values['subscription[email]'],
        'name': values['subscription[name]']
      }
    }
    console.log(payload)
    console.log(values)
    request = window.requestToJsonApi('/api/subscriptions', 'POST', data: payload)
    request.done(callback)
    request.fail( (err) -> console.log(err) )