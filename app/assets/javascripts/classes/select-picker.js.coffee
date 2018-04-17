# A text field with an auto-completion/select dropdown
# - data-handler must be the name of the global method which loads the suggestions

class @SelectPicker

  constructor: (select) ->
    select.selectpicker 'render'
    handler_name = select.data('handler')
    select.on 'changed.bs.select', ->
      handler = window[handler_name] if handler_name? and window[handler_name]?
      handler(select.val(), select)
