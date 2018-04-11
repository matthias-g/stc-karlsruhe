class @Modal

  constructor: (@html) ->
    type = @html.data('type')
    # Load modal AJAX content
    @html.on 'show.bs.modal', (e) ->
      href = $(e.relatedTarget).attr('href')
      if type == 'iframe'
        $('.modal-body', @).html($('<iframe>').attr(src: href))
      else
        $('.modal-content', @).load(href  + ' .modal-content > *')