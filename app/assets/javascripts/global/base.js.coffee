### base.js ###
# Basic global methods, like event & content registration and some AJAX methods
# Also invokes classes on elements with the data-class attribute and inits the I18n module


### API ###

# register given handler for page load
@onPageLoad = (handler) ->
  document.addEventListener 'turbolinks:load', handler

# register given handler for when new HTML is available
content_handlers = []
@onNewContent = (handler) ->
  content_handlers.push handler

# execute given handler before page is submitted to Turbolinks cache
@onTurbolinksCache = (handler) ->
  document.addEventListener 'turbolinks:before-cache', handler

# load a script (once)
loadedScripts = []
@requireScript = (path, callback) ->
  if path in loadedScripts
    callback()
  else
    loadedScripts.push path
    $.getScript '/assets/' + path + '.js', callback

# executes all onNewContent handlers for the given content
@registerContent = (html_element) ->
  for handler in content_handlers
    handler.call html_element

# submit the given form with AJAX and extract flash messages from the html response
@sendFormWithAjax = (form) ->
  url = $(form).attr('action') + '?' + $(form).serialize()
  res = $('<div>').load url + ' #flash-messages', ->
    extractFlashMessages res


### PRIVATE ###

# finds elements with a data-class attribute and instantiates the respective class for them
instantiateClasses = (html) ->
  $('[data-class]', html).each ->
    new window[$(@).data('class')]($(@));


### INIT ###

onPageLoad ->
  I18n.locale = $('body').data('locale')
  registerContent $('body')
  $('.modal').on 'shown.bs.modal', ->
    registerContent $('.modal-content', @)

onNewContent ->
  instantiateClasses(@)