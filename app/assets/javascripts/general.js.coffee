extractFlashMessages = (html) ->
  $('#messages .alert', html).detach().each (i, e) ->
    msg = $(e)
    close = ->
      msg.alert 'close'
    msg.click close
    window.setInterval close, 5000
    $('#messages').append msg


sendWithAjax = (form) ->
  url = $(form).attr('action') + '?' + $(form).serialize()
  res = $('<div>').load url + ' #messages', ->
    extractFlashMessages res

    
### uncollapse accordion section if it's referenced in the url hash ###
uncollapseAccordeonAnchor = ->
  if location.hash
    target = $(location.hash + '.collapse').collapse('show')
    if target.size() > 0
      $('html, body').scrollTop target.offset().top - 100

      
### Retrieve Facebook likes with the graph API ###     
loadLikeboxes = ->
  $('.get-likes').each ->
    dst = $(@)
    $.getJSON('https://graph.facebook.com/' + dst.data('fb-page') + '?access_token=' + dst.data('fb-token'), (res) ->
      dst.text res.likes
    ).fail (jqxhr, textStatus, error) ->
      console.log 'Request Failed: ' + textStatus + ', ' + error
      console.log jqxhr.responseJSON
      dst.parent().hide()

      
# create a parameter string of all the values of a form / part form
parametrize = (form) ->
  inputs = $(':input', form).serializeArray()
  params = $.map(inputs, (a) -> a.name + '=' + a.value).join('&')

  
# submits values immediately, instead of waiting for the submit button 
submitOnChange = (form, handler) ->
  filter.submit handler
  $(':input', filter).change handler
  $('input[type="submit"]', filter).hide()
      
  
  
ready = ->
  
  extractFlashMessages $('body')  
  uncollapseAccordeonAnchor
  loadLikeboxes
  
  # lazyload images (must be activated with lazy:true in image_tag helper)
  $('img').lazyload threshold: 200 
  
  ### Load modal AJAX content ###
  $('.modal').on 'show.bs.modal', (e) ->
    $('.modal-content', @).load $(e.relatedTarget).attr('href')

  # init image croppers
  $('.cropbox').each ->
    new ImageCropper($(@))
  $('.modal').on 'shown.bs.modal', ->
    $('.cropbox', @).each ->
      new ImageCropper($(@))

  # init maps
  $('.map').each ->
    new GoogleMap($(@))

  $('.locked-iframe-trigger').each ->
    new LockedIframe($(@))
    
# TODO Rails 5 http://stackoverflow.com/a/18770589      
$(document).ready ready
$(document).on 'page:load', ready