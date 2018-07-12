import JsonApi from 'devour-client'

# define and extend API
api = new JsonApi(apiUrl: '/api')

singularize = api.pluralize.singular

api.add = (modelType, modelId, relationship, itemId) ->
  itemType = api.modelFor(singularize(modelType)).attributes[relationship].type
  api.runMiddleware
    url: "/api/#{modelType}/#{modelId}/relationships/#{relationship}"
    method: 'POST'
    params: {}
    model: singularize(itemType)
    data: [type: itemType, id: itemId]

api.remove = (modelType, modelId, relationship, itemId) ->
  itemType = api.modelFor(singularize(modelType)).attributes[relationship].type
  api.runMiddleware
    url: "/api/#{modelType}/#{modelId}/relationships/#{relationship}"
    method: 'DELETE'
    params: {}
    model: singularize(itemType)
    data: [type: itemType, id: itemId]

export { api }



# basic request caching, without data updating for other requests

cached_requests = {}

api.replaceMiddleware 'axios-request', name: 'cached-axios-request', req: (payload) =>
  identifier = payload.req.url
  identifier += '?' + $.param(payload.req.params) if !$.isEmptyObject(payload.req.params)
  if (identifier of cached_requests) and (payload.req.method == 'GET')
    {config: {method: 'get', url: payload.req.url, params: payload.req.params}, data: cached_requests[identifier]}
  else payload.jsonApi.axios(payload.req)

api.insertMiddlewareBefore 'response', name: 'commit-to-store', res: (payload) =>
  if payload.res.config.method == 'get'
    identifier = payload.res.config.url + '?' + $.param(payload.res.config.params)
    cached_requests[identifier] = payload.res.data
  payload

onPageLoad ->
  cached_requests = window.included_requests if window.included_requests?