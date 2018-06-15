### flash-messages.js ###
# Global methods for creating flash messages or extracting them from any HTML content


### API ###

# create a new flash message and append it
@createFlashMessage = (desc, heading, type) ->
  type ?= 'info'
  desc = '<h4>' + heading + '</h4>' + desc if heading && heading.length
  appendFlashMessage $("""
    <div class="alert alert-""" + type + """ alert-dismissible" role="alert">
      <a href="#" data-dismiss="alert" class="close">×</a>
      """ + desc + """
      <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
  """)

@resourceFlash = (model, action, relationship = null, suffix = '', options = {}) ->
  createFlashMessage lang('message', model, action, relationship, suffix, options)

# extract flash messages from the given container and append them
@extractFlashMessages = (html) ->
  $('#flash-messages .alert', html).detach().each (i, ele) ->
    appendFlashMessage $(ele)


### PRIVATE ###

# append a flash message, with timeout
appendFlashMessage = (flash) ->
  close = ->
    flash.alert 'close'
  flash.click close
  window.setInterval close, 7000
  $('#flash-messages').append flash


### INIT ###

onNewContent ->
  extractFlashMessages(@)