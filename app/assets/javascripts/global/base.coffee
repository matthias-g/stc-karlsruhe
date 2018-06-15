### base.js ###
# Basic global methods, like event & content registration and some AJAX methods
# Also invokes classes on elements with the data-class attribute and inits the I18n module


### API ###

# register code to be run on page load
pageload_handlers = []
@onPageLoad = (handler) ->
  pageload_handlers.push handler

# register code to be run on any HTML content (handler receives jQuery set)
content_handlers = []
@onNewContent = (handler) ->
  content_handlers.push handler

# register code for running before the page is submitted to Turbolinks cache
@beforeTurbolinksCache = (handler) ->
  document.addEventListener 'turbolinks:before-cache', handler

# register register code to be run on page load of a specific controller/action
@onViewLoad = (controller_actions, handler) ->
  actions = controller_actions.replace(/->/g, '.').split(',')
  @onPageLoad ->
    for action in actions
      if $('#content > #' + action.trim()).length
        handler.call(window)

# informs the system that new HTML content was created
@registerContent = (jquery_collection) ->
  for handler in content_handlers
    handler.call jquery_collection



### PRIVATE ###

# finds elements with a data-class attribute and instantiates the respective class for them
instantiateClasses = (html) ->
  $('[data-class]', html).each ->
    new window[$(@).data('class')]($(@));


### INIT ###

document.addEventListener 'turbolinks:load', ->
  for handler in pageload_handlers
    handler.call(window)
  registerContent $('body')


onPageLoad ->
  I18n.locale = $('body').data('locale')
  $('.modal').on 'shown.bs.modal', ->
    registerContent $('.modal-content', @)

onNewContent ->
  instantiateClasses(@)