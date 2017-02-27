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
  if object
    return $.when(object)
  deferred = $.Deferred()
  url = addParametersToUrl("/api/#{type}/#{resourceId}", parameters)
  window.getJsonApi(url, 'GET').done((response) =>
    window.getJsonApiStore().sync response
    deferred.resolve(window.getJsonApiStore().find(type, resourceId))
  ).fail((error) ->
    console.log('Failed getting resource', error)
    deferred.reject(error)
  )
  return deferred.promise()