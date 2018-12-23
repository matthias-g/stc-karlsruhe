### recaptcha.js ###
# Inits recaptcha elements and makes them compatible with Turbolinks

pageLoaded = false
recaptchaReady = false
vuejsInitialized = false
recaptchaIds = []

$.fn.initRecaptcha = ->
  return if (!pageLoaded || !recaptchaReady || !vuejsInitialized)
  @.each ->
    recaptchaIds.push(grecaptcha.render(@, sitekey: $(@).data('sitekey')))

# this is called by the recaptcha library when loaded
@recaptchaLoadCallback = ->
  recaptchaReady = true
  $('.g-recaptcha').initRecaptcha()

# this is called after the Vue instance has been created
@vuejsInitializedCallback = ->
  vuejsInitialized = true
  $('.g-recaptcha').initRecaptcha()


onPageLoad ->
  pageLoaded = true
  $('.g-recaptcha').initRecaptcha()

beforeTurbolinksCache ->
  pageLoaded = false
  vuejsInitialized = false
  for id in recaptchaIds
    grecaptcha.reset(id)
  recaptchaIds = []
  $('.g-recaptcha').empty()