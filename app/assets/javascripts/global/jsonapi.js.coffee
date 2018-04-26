### jsonapi.js ###
# Global methods relating to JSON API

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

addParametersToUrl = (url, params) ->
  separator = '?'
  for key, value of params
    url += separator + key + '=' + value
    separator = '&'
  return url

@getResource = (type, resourceId, parameters = {}) ->
  object = window.getJsonApiStore().find(type, resourceId)
  if object && (!parameters['include'] || object[parameters['include']])
    return $.when(object)
  deferred = $.Deferred()
  url = addParametersToUrl("/api/#{type}/#{resourceId}", parameters)
  window.getJsonApi(url, 'GET').done((response) =>
    window.getJsonApiStore().sync response
    deferred.resolve(window.getJsonApiStore().find(type, resourceId))
  ).fail((error) ->
    console.log("Failed getting resource #{resourceId} of type #{type}", error)
    deferred.reject(error)
  )
  return deferred.promise()

@getResources = (type, parameters = {}) ->
  deferred = $.Deferred()
  url = addParametersToUrl("/api/#{type}", parameters)
  window.getJsonApi(url, 'GET').done((response) =>
    window.getJsonApiStore().sync response
    deferred.resolve(window.getJsonApiStore().findAll(type))
  ).fail((error) ->
    console.log("Failed getting resources of type #{type}", error)
    deferred.reject(error)
  )
  return deferred.promise()



# extend rails ujs remote calls to send params JSONAPI call
$.rails.ajax = (options) ->
  if (options.dataType == 'jsonapi')
    $.extend options,
      accepts: {jsonapi: 'application/vnd.api+json'}
      contentType: 'application/vnd.api+json'
      converters: {'text jsonapi': (result) -> JSON.parse(result)}
      data: JSON.stringify({data: options.data})
  $.ajax(options)


onNewContent ->

  # basic ujs JSONAPI success handling
  $('[data-type=jsonapi]').on 'ajax:success', ->
    link = $(@)

    # display success message
    if link.data('success-message')
      createFlashMessage link.data('success-message')

    # remove link and parents up to nth level (min 1)
    if link.data('success-remove')
      level = parseInt(link.data('success-remove')) - 1
      link.parents().eq(level).slideUp 'fast', ->
        $(@).remove()

    # reload page
    if link.data('success-reload')
      location.reload()

  # basic ujs JSONAPI error handling
  $('[data-type=jsonapi]').on 'ajax:error', (event, xhr, status, error) ->
    response = JSON.parse(xhr.responseText)
    console.log(response)
    for error in response.errors
      createFlashMessage error.detail, error.title, 'danger'