class @YoutubeVideo
  
  constructor: (@html) ->
    trigger = $('.trigger', @html)
    iframe = $('iframe', @html)
    trigger.click ->
      iframe.attr(src: iframe.data('frame-src'))
      trigger.hide()