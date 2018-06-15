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

@lang = (section, model_type, action, relationship = '', suffix = '', options = {}) ->
  action_fragment = switch action
    when 'add' then 'addTo' + capitalize(relationship)
    when 'remove' then 'removeFrom' + capitalize(relationship)
    else action
  I18n.t "#{singularize(model_type)}.#{section}.#{action_fragment}#{capitalize(suffix)}", options