# An iframe that is only loaded when a trigger has been clicked
# - data-frame-src should contain the iframe URL

class @YoutubeVideo
  
  constructor: (html) ->
    iframe = $('iframe', html)
    $('.trigger', html).click ->
      iframe.attr(src: iframe.data('frame-src'))
      $(@).hide()