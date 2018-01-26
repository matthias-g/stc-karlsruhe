# updates action list if filter changes
class @ActionFilter

  constructor: (html) ->
    @onFieldChange html, (e, obj) =>
      e.preventDefault()
      listId = html.data('list')
      $(listId).load '?' + @parametrize(obj) + ' ' + listId + ' > *', ->
        $('img', @).lazyload()
        $(html.data('info')).text 'Gefundene Aktionen: ' + $(@).children().size()


  # create a parameter string of all the values of a form / part form
  parametrize: (form) ->
    inputs = $(':input', form).serializeArray()
    params = $.map(inputs, (a) -> a.name + '=' + a.value).join('&')

  # fires the handler on any field change, and hides the submit button
  onFieldChange: (form, handler) ->
    form.submit handler
    $(':input', form).change handler
    $('input[type="submit"]', form).hide()