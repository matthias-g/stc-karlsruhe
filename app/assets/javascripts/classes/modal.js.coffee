class @Modal

  constructor: (@html) ->
    # Load modal AJAX content
    @html.on 'show.bs.modal', (e) ->
      $('.modal-content', @).load($(e.relatedTarget).attr('href')  + ' .modal-content > *')