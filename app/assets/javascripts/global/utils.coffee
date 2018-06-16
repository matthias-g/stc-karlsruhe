@capitalize = (str) ->
  return '' unless str
  str.charAt(0).toUpperCase() + str.slice(1);

@singularize = (str) ->
  return '' unless str
  str.slice(0, -1)

@find_in_object_array = (id, myArray) ->
  for obj in myArray
    return obj if obj.id == id
  return null

@get_name_for = (resource) ->
  if resource._type == 'users'
    if 'last-name' of resource
      return capitalize(resource['first-name']) + ' ' + capitalize(resource['last-name'])
    else
      return capitalize(resource['first-name'])
  resource.title

# Looks up a suitable translation for the given action
# e.g. ll(event_resource, 'added', 'volunteers', 'John Doe')
#   => I18n.t 'action.message.volunteer_added', model: 'Event 1', item: 'John Doe'
@ll = (model, action, relationship = '', item = '') ->
  section = 'button'
  section = 'message' if action in ['added', 'removed', 'created', 'deleted']
  root = "#{singularize(model._type)}.#{section}."
  if item != ''
    I18n.t(root + singularize(relationship) + '_' + action, model: get_name_for(model), item: item)
  else if relationship != ''
    I18n.t(root + action + '_' + singularize(relationship), model: get_name_for(model))
  else I18n.t(root + action, model: get_name_for(model))