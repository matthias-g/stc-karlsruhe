import JsonApi from 'devour-client'

# define and extend API
api = new JsonApi(apiUrl: '/api')

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

# Cache for GET requests
cached_requests = {}

# Try to get request from request cache
api.replaceMiddleware 'axios-request', name: 'cached-axios-request', req: (payload) =>
  identifier = payload.req.url
  identifier += '?' + $.param(payload.req.params) if !$.isEmptyObject(payload.req.params)
  if (identifier of cached_requests) and (payload.req.method == 'GET')
    {config: {method: 'get', url: payload.req.url, params: payload.req.params}, data: cached_requests[identifier]}
  else payload.jsonApi.axios(payload.req)

# Save response to request cache
api.insertMiddlewareBefore 'response', name: 'commit-to-store', res: (payload) =>
  if payload.res.config.method == 'get'
    identifier = payload.res.config.url + '?' + $.param(payload.res.config.params)
    cached_requests[identifier] = payload.res.data
  payload

export { api }

onPageLoad ->
  # Preload request cache
  cached_requests = window.included_requests if window.included_requests?