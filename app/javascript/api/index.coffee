import JsonApi from 'devour-client'

# define and extend API
api = new JsonApi(apiUrl: '/api', logger: RAILS_ENV != 'production')

# misc function singularize for local use
singularize = api.pluralize.singular

# Method for adding an item to a relationship
api.add = (modelType, modelId, relationship, itemId) ->
  itemType = api.modelFor(singularize(modelType)).attributes[relationship].type
  api.runMiddleware
    url: "/api/#{modelType}/#{modelId}/relationships/#{relationship}"
    method: 'POST'
    params: {}
    model: singularize(itemType)
    data: [type: itemType, id: itemId]

# Method for removing an item from a relationship
api.remove = (modelType, modelId, relationship, itemId) ->
  itemType = api.modelFor(singularize(modelType)).attributes[relationship].type
  api.runMiddleware
    url: "/api/#{modelType}/#{modelId}/relationships/#{relationship}"
    method: 'DELETE'
    params: {}
    model: singularize(itemType)
    data: [type: itemType, id: itemId]

# Convert camelCase attributes back to dashed-format
api.insertMiddlewareBefore 'axios-request', name: 'serialize-undo-camelcase', req: (payload) =>
  if payload.req.data? && payload.req.data.data?
    new_attr = {}
    for key, value of payload.req.data.data.attributes
      new_key = key.replace(/[A-Z]/g, (x) -> '-' + x.toLowerCase())
      new_attr[new_key] = value
    payload.req.data.data.attributes = new_attr
  payload

# Try to get request from request cache
cached_requests = {}
api.replaceMiddleware 'axios-request', name: 'cached-axios-request', req: (payload) =>
  if payload.req.method != 'GET'
    return payload.jsonApi.axios(payload.req)
  else
    cid = payload.req.url
    cid += '?' + $.param(payload.req.params) if !$.isEmptyObject(payload.req.params)
    return cached_requests[cid] if cid of cached_requests
    return cached_requests[cid] = payload.jsonApi.axios(payload.req)

export { api }

onPageLoad ->
  # Preload request cache
  cached_requests = window.included_requests if window.included_requests?
