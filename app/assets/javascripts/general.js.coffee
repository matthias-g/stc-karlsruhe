
   
### PUBLIC ###
    
# create a new flash message and append it
@createFlashMessage = (str) ->
  appendFlashMessage $("""
    <div class="alert alert-info alert-dismissible" role="alert">
      <a href="#" data-dismiss="alert" class="close">×</a>
      <ul><li>""" + str + """</li></ul>
    </div>
  """)

# submit the given form directly (with ajax) and extract flash messages from the html response
@sendWithAjax = (form) ->
  url = $(form).attr('action') + '?' + $(form).serialize()
  res = $('<div>').load url + ' #messages', ->
    extractFlashMessages res

# create a parameter string of all the values of a form / part form
@parametrize = (form) ->
  inputs = $(':input', form).serializeArray()
  params = $.map(inputs, (a) -> a.name + '=' + a.value).join('&')

  
# fires the handler on any field change, and hides the submit button
@onFieldChange = (form, handler) ->
  form.submit handler
  $(':input', form).change handler
  $('input[type="submit"]', form).hide()

# register handler for page load 
@onPageLoad = (handler) ->
  # TODO Rails 5 http://stackoverflow.com/a/18770589      
  $(document).ready handler
  $(document).on 'page:load', handler
  
# execute handler when new HTML is available (page load or ajax)
@onNewContent = (handler) ->
  onPageLoad ->  
    handler.call($('body').get(0))
    $('.modal').on 'shown.bs.modal', handler
  
  
  
### PRIVATE ###

# append a flash message, with timeout
appendFlashMessage = (flash) ->
  close = ->
    flash.alert 'close'
  flash.click close
  window.setInterval close, 5000
  $('#messages').append flash

# extract flash messages from the given container and append them
extractFlashMessages = (html) ->
  $('#messages .alert', html).detach().each (i, e) ->
    appendFlashMessage $(e)

# uncollapse accordion section if it's referenced in the url hash
uncollapseAccordeonAnchor = ->
  if location.hash
    target = $(location.hash + '.collapse').collapse('show')
    if target.size() > 0
      $('html, body').scrollTop target.offset().top - 100

# finds elements with a data-class attribute and instantiates the respective class for them
instantiateClasses = ->
  $('[data-class]').each ->
    new window[$(@).data('class')]($(@));


    
    
### INIT ###

onPageLoad ->
  uncollapseAccordeonAnchor()

onNewContent ->
  extractFlashMessages $(@)
  instantiateClasses()

  # lazyload images (must be activated with lazy:true in image_tag helper)
  $('img', @).lazyload threshold: 200