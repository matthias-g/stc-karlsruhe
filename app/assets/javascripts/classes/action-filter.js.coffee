# A filter form that updates the action list as soon as any filter input is changed.
# - The filter request is sent to the current URL
# - Expects attribute "data-list": ID of container which contains the action list

class @ActionFilter

  constructor: (html) ->
    @onFieldChange html, (e, obj) =>
      e.preventDefault()
      listId = html.data('list')
      $(listId).load '?' + @parametrize(html) + ' ' + listId + ' > *', ->
        registerContent(@)
        createFlashMessage I18n.t('action.message.found_actions', count: $('.action-card', @).length)


  # create a parameter string of all the values of a form / part form
  parametrize: (form) ->
    inputs = {}
    for a in $(':input', form).serializeArray()
      inputs[a.name] = a.value
    params = $.map(inputs, (v,k) -> k + '=' + v).join('&')

  # fires the handler on any field change, and hides the submit button
  onFieldChange: (form, handler) ->
    form.submit handler
    $(':input', form).change handler
    $('input[type="submit"]', form).hide()