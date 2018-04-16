# A text field with an auto-completion/select dropdown
# - data-handler must be the name of the global method which loads the suggestions

class @SelectPicker

  constructor: (select) ->
    select.selectpicker 'render'
    handler_name = select.data('handler')
    handler = window[handler] if handler_name? and window[handler_name]?
    select.on 'changed.bs.select', ->
      handler(select.val(), select)