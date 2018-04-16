# A Bootstrap modal dialog that dynamically load its content from the href of the link that was used to open the modal
# - modal attribute data-type can be used to indicate loading via AJAX (default) or iframe

class @Modal

  constructor: (html) ->
    type = html.data('type')
    html.on 'show.bs.modal', (e) ->
      href = $(e.relatedTarget).attr('href')
      if type == 'iframe'
        $('.modal-body', @).html $('<iframe>').attr(src: href)
      else
        $('.modal-content', @).load (href  + ' .modal-content > *'), ->
          registerContent $('.modal-content > *', @)