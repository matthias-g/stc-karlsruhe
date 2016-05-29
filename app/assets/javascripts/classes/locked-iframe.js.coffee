class @LockedIframe
  
  constructor: (@html) ->
    trigger = $('.locked-iframe-trigger', @html)
    iframe = $('.locked-iframe', @html) 
    trigger.click ->
      iframe.removeClass('locked-iframe').attr(src: iframe.data('frame-src'))
      trigger.hide()