### flash-messages.js ###
# Global methods for creating flash messages or extracting them from any HTML content


### API ###

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