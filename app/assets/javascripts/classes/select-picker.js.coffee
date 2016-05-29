class @SelectPicker

  constructor: (@html) ->
    @html.selectpicker 'render'
    handler = @html.data('handler')
    @handle window[handler] if handler? and window[handler]?

  handle: (handler) =>
    @html.on 'changed.bs.select', =>
      handler(@html.val(), @html)