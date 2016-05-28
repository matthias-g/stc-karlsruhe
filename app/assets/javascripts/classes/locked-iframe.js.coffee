class LockedIframe
  
  constructor: (trigger) ->
    trigger.click ->
      $($(@).data('target-frame')).each ->
        $(@).removeClass('locked-iframe').attr(src: $(this).data('frame-src'))
      $(@).hide()