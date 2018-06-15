### recaptcha.js ###
# Inits recaptcha elements and makes them compatible with Turbolinks

pageLoaded = false
recaptchaReady = false
recaptchaIds = []

$.fn.initRecaptcha = ->
  return if (!pageLoaded || !recaptchaReady)
  @.each ->
    recaptchaIds.push(grecaptcha.render(@, sitekey: $(@).data('sitekey')))

# this is called by the recaptcha library when loaded
@recaptchaLoadCallback = ->
  recaptchaReady = true
  $('.g-recaptcha').initRecaptcha()


onPageLoad ->
  pageLoaded = true
  $('.g-recaptcha').initRecaptcha()

beforeTurbolinksCache ->
  for id in recaptchaIds
    grecaptcha.reset(id)
  recaptchaIds = []
  $('.g-recaptcha').empty()