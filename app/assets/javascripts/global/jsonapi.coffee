### jsonapi.js ###
# Global methods relating to JSON API

# generic JSONAPI call (uncached and lowlevel, use other methods below where possible)
@apiRequest = (url, method = 'GET', payload = {}) ->
  settings =
    accepts: {jsonapi: 'application/vnd.api+json'}
    contentType: 'application/vnd.api+json'
    converters: {'text jsonapi': (result) -> result}
    dataType: 'jsonapi'
    method: method
  unless $.isEmptyObject(payload)
    settings.data = JSON.stringify(payload)
  $.ajax(url, settings).fail(handleJsonApiError)

# calls a controller action on the resource
@apiCallAction = (type, id, action, method = 'GET', payload = {}) ->
  apiRequest("/api/#{type}/#{id}/#{action}", method, payload)

# adds an item to an association
@apiAdd = (type, id, relationship, item_type, item_id) ->
  apiRequest("/api/#{type}/#{id}/relationships/#{relationship}",
    'POST', {data: [{type: item_type, id: item_id}]})

# removes an item from an association
@apiRemove = (type, id, relationship, item_type, item_id) ->
  apiRequest("/api/#{type}/#{id}/relationships/#{relationship}",
    'DELETE', {data: [{type: item_type, id: item_id}]})

# deletes a resource
@apiDelete = (type, id) ->
  apiRequest("/api/#{type}/#{id}", 'DELETE')

# gets a resource
@apiGet = (type, id, params = {}) ->
  # try to get it from the store
  store = getApiStore()
  res = store.find(type, id)
  if res && (!params['include'] || res[params['include']])
    return $.when(res)
  # otherwise get it via JSONAPI
  deferred = $.Deferred()
  $.ajax("/api/#{type}/#{id}?#{$.param(params)}",
    accepts: {jsonapi: 'application/vnd.api+json'}
    converters: {'text jsonapi': (result) -> JSON.parse(result)}
    dataType: 'jsonapi'
  ).done((data) =>
    store.sync data
    deferred.resolve(store.find(type, id))
  ).fail((error) ->
    console.log("Failed getting resource #{id} of type #{type}", error)
    deferred.reject(error)
  ).fail(handleJsonApiError)
  deferred.promise()

# gets all resources of a type
@apiGetAll = (type, params = {}) ->
  # try to get it from the store
  store = getApiStore()
  res = store.find(type)
  if res && (!params['include'] || res[params['include']])
    return $.when(res)
  # otherwise get it via JSONAPI
  deferred = $.Deferred()
  url = "/api/#{type}"
  url += "?#{$.param(params)}" unless $.isEmptyObject(params)
  $.ajax(url,
    accepts: {jsonapi: 'application/vnd.api+json'}
    converters: {'text jsonapi': (result) -> JSON.parse(result)}
    dataType: 'jsonapi'
  ).done((data) =>
    store.sync data
    deferred.resolve(store.findAll(type))
  ).fail((error) ->
    console.log("Failed getting resources of type #{type}", error)
    deferred.reject(error)
  ).fail(handleJsonApiError)
  deferred.promise()


### UJS: links/forms with data-remote=true ###

# send all UJS calls via JSONAPI
$.rails.ajax = (settings) ->
  if (settings.dataType == 'jsonapi')
    $.extend settings,
      accepts: {jsonapi: 'application/vnd.api+json'}
      contentType: 'application/vnd.api+json'
      converters: {'text jsonapi': (result) -> JSON.parse(result)}
      data: JSON.stringify({data: settings.data})
  $.ajax(settings)


onNewContent ->

  # basic UJS JSONAPI error/success handling
  $('[data-type=jsonapi]').on 'ajax:error', handleJsonApiError
  $('[data-type=jsonapi]').on 'ajax:success', ->
    link = $(@)

    # display success message
    if link.data('success-message')
      createFlashMessage link.data('success-message')

    # remove link and parents up to nth level (min 1)
    if link.data('success-remove')
      level = parseInt(link.data('success-remove')) - 1
      link.parents().eq(level).slideUp 'fast', -> $(@).remove()

    # reload page
    if link.data('success-reload')
      location.reload()


# PRIVATE

# singleton getter for the JSONAPI store
getApiStore = ->
  unless window.jsonApiStore
    window.jsonApiStore = new JsonApiDataStore()
  window.jsonApiStore

# handler for all JSONAPI errors
handleJsonApiError = (xhr, textStatus, errorThrown) ->
  switch errorThrown.trim()
    when 'Forbidden'
      createFlashMessage 'You have no permission for this action', '', 'danger'
    when 'Unauthorized'
      createFlashMessage 'You need to be logged in for this action', '', 'danger'
    else
      response = xhr.responseText
      response = JSON.parse(response) if (typeof response == 'string')
      for error in response.errors
        switch parseInt(error.code)
          when 113 then createFlashMessage 'This element is already present', '', 'danger'
          else createFlashMessage error.detail, error.title, 'danger'