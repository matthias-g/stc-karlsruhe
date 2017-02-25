
   
### PUBLIC ###

# dynamically loads a script (once)
loadedScripts = []
@requireScript = (path, callback) ->
  if path in loadedScripts
    callback()
  else
    loadedScripts.push path
    $.getScript '/assets/' + path + '.js', callback

# create a new flash message and append it
@createFlashMessage = (str, type) ->
  type ?= 'info'
  appendFlashMessage $("""
    <div class="alert alert-""" + type + """ alert-dismissible" role="alert">
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
  #$(document).on 'page:load', handler
  
# execute handler when new HTML is available (page load or ajax)
@onNewContent = (handler) ->
  onPageLoad ->  
    handler.call($('body').get(0))
    $('.modal').on 'shown.bs.modal', handler

@getJsonApi = (url) ->
  settings = {
    accepts: {
      jsonapi: 'application/vnd.api+json'
    },
    converters: {
      'text jsonapi': (result) -> JSON.parse(result)
    },
    dataType: 'jsonapi'
  }
  $.ajax(url, settings)

@updateJsonApi = (url, payload) ->
  settings = {
    accepts: {
      jsonapi: 'application/vnd.api+json'
    },
    contentType: 'application/vnd.api+json',
    converters: {
      'text jsonapi': (result) -> JSON.parse(result)
    },
    dataType: 'jsonapi',
    data: JSON.stringify(payload),
    method: 'PATCH'
  }
  $.ajax(url, settings)
@requestToJsonApi = (url, method, payload = {}) ->
  settings = {
    accepts: {
      jsonapi: 'application/vnd.api+json'
    },
    contentType: 'application/vnd.api+json',
    converters: {
      'text jsonapi': (result) -> result
    },
    dataType: 'jsonapi',
    data: JSON.stringify(payload),
    method: method
  }
  $.ajax(url, settings)

@getJsonApiStore = ->
  unless window.jsonApiStore
    window.jsonApiStore = new JsonApiDataStore()
  return window.jsonApiStore
  
### PRIVATE ###

# append a flash message, with timeout
@appendFlashMessage = (flash) ->
  close = ->
    flash.alert 'close'
  flash.click close
  window.setInterval close, 5000
  $('#messages').append flash

# extract flash messages from the given container and append them
extractFlashMessages = (html) ->
  $('#messages .alert', html).detach().each (index, element) ->
    appendFlashMessage $(element)

# uncollapse accordion section if it's referenced in the url hash
uncollapseAccordeonAnchor = ->
  if location.hash
    target = $(location.hash + '.collapse').collapse('show')
    if target.size() > 0
      $('html, body').scrollTop target.offset().top - 100

# finds elements with a data-class attribute and instantiates the respective class for them
instantiateClasses = (html) ->
  $('[data-class]', html).each ->
    new window[$(@).data('class')]($(@));


    
    
### INIT ###

onPageLoad ->
  uncollapseAccordeonAnchor()

onNewContent ->
  extractFlashMessages(@)
  instantiateClasses(@)

  # lazyload images (must be activated with lazy:true in image_tag helper)
  $('img', @).lazyload threshold: 200
