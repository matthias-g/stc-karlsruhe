
### PUBLIC ###

# dynamically loads a script (once)
#loadedScripts = []
#@requireScript = (path, callback) ->
#  if path in loadedScripts
#    callback()
#  else
#    loadedScripts.push path
#    $.getScript '/assets/' + path + '.js', callback

# create a new flash message and append it
@createFlashMessage = (str, type) ->
  type ?= 'info'
  appendFlashMessage $("""
    <div class="alert alert-""" + type + """ alert-dismissible" role="alert">
      <a href="#" data-dismiss="alert" class="close">×</a>
      """ + str + """
      <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
  """)

# submit the given form directly (with AJAX) and extract flash messages from the html response
@sendFormWithAjax = (form) ->
  url = $(form).attr('action') + '?' + $(form).serialize()
  res = $('<div>').load url + ' #flash-messages', ->
    extractFlashMessages res

# register handler for page load 
@onPageLoad = (handler) ->
  $(document).on 'turbolinks:load', handler
  
# execute handler when new HTML is available (page load or AJAX)
@onNewContent = (handler) ->
  onPageLoad ->  
    handler.call($('body').get(0))
    $('.modal').on 'shown.bs.modal', handler
  
### PRIVATE ###

# append a flash message, with timeout
@appendFlashMessage = (flash) ->
  close = ->
    flash.alert 'close'
  flash.click close
  window.setInterval close, 5000
  $('#flash-messages').append flash

# extract flash messages from the given container and append them
extractFlashMessages = (html) ->
  $('#flash-messages .alert', html).detach().each (index, element) ->
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

pageLoaded = false
recaptchaReady = false
recaptchaIds = []
$.fn.initRecaptcha = ->
  return if (!pageLoaded || !recaptchaReady)
  @.each (index, element) ->
    recaptchaIds.push(grecaptcha.render(element, {'sitekey' : $(element).data('sitekey')}))

### INIT ###

onPageLoad ->
  uncollapseAccordeonAnchor()
  pageLoaded = true
  $('.g-recaptcha').initRecaptcha()

onNewContent ->
  extractFlashMessages(@)
  instantiateClasses(@)

  # lazyload images (must be activated with lazy:true in image_tag helper)
  $('img', @).lazyload threshold: 200

# this is called by the recaptcha library when loaded
@recaptchaLoadCallback = ->
  recaptchaReady = true
  $('.g-recaptcha').initRecaptcha()

document.addEventListener "turbolinks:before-cache", ->
  for recaptchaId in recaptchaIds
    grecaptcha.reset(recaptchaId)
  recaptchaIds = []
  $('.g-recaptcha').empty()

  selectMenus = $('.bootstrap-select')
  selectMenus.find('button.dropdown-toggle').remove()
  selectMenus.find('div.dropdown-menu').remove()
  selectMenus.each (index, ele) ->
    element = $(ele)
    originalSelect = element.find('select')
    originalSelect.insertAfter(element)
    element.remove()