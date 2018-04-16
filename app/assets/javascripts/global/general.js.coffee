### general.js ###
# Globally relevant event handlings that don't fit anywhere else


### INIT ###

onPageLoad ->
  $('.header img, #nav-logo img').on 'contextmenu', ->
    createFlashMessage I18n.t 'layout.message.downloadLogo'
    true

onNewContent ->
  # lazyload images (must be activated with lazy:true in image_tag helper)
  $('img', @).lazyload threshold: 200

onTurbolinksCache ->
  selectMenus = $('.bootstrap-select')
  selectMenus.find('button.dropdown-toggle').remove()
  selectMenus.find('div.dropdown-menu').remove()
  selectMenus.each ->
    $('select', @).insertAfter($(@))
    $(@).remove()