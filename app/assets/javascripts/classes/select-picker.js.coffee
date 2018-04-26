# A text field with an auto-completion/select dropdown
# - data-handler must be the name of the global method which loads the suggestions

class @SelectPicker

  constructor: (select) ->
    select.selectpicker 'render'
    #handler_name = select.data('handler')
    handling = select.data('handling')
    select.on 'changed.bs.select', ->
      url = handling.url.replace('{id}', select.val())
      payload = JSON.stringify(handling.data).replace('{id}', select.val())
      request = window.requestToJsonApi(url, handling.method, data: JSON.parse(payload))

      # fire basic response handling
      request.success (data, status, xhr) ->
        select.trigger('ajax:success', [data, status, xhr])
      request.error (xhr, status, error) ->
        select.trigger('ajax:error', [xhr, status, error])

