# Capitalize the first letter in a string
capitalize = (str) ->
  return '' unless str
  str.charAt(0).toUpperCase() + str.slice(1);

# Singularize a pluralized word (only for very simple cases)
singularize = (str) ->
  return '' unless str
  str.slice(0, -1)

# Get the object in the given array which has the given id as key "id"
find_in_object_array = (id, myArray) ->
  for obj in myArray
    return obj if obj.id == id
  return null

# Get a suitable human readable title for a Devour resource
# currently supports users, actions, projects, action groups, tags...
get_name_for = (resource) ->
  if resource.type == 'users'
    if 'lastName' of resource
      return capitalize(resource['firstName']) + ' ' + capitalize(resource['lastName'])
    else
      return capitalize(resource['firstName'])
  resource.title

# Look up a suitable translation for the given action
# e.g. ll(event_resource, 'added', 'volunteers', 'John Doe')
#   => I18n.t 'action.message.volunteer_added', model: 'Event 1', item: 'John Doe'
ll = (model, action, relationship = '', item = '') ->
  section = 'button'
  section = 'message' if action in ['added', 'removed', 'created', 'deleted']
  root = "#{singularize(model.type)}.#{section}."
  if item != ''
    I18n.t(root + singularize(relationship) + '_' + action, model: get_name_for(model), item: item)
  else if relationship != ''
    I18n.t(root + action + '_' + singularize(relationship), model: get_name_for(model))
  else I18n.t(root + action, model: get_name_for(model))

# Check whether arrays arr1 and arr2 have common elements
intersect = (arr1, arr2) ->
  for el in arr1
    return true if el in arr2
  false

# Check whether array "sub" is a subset of array "arr"
subset = (sub, arr) ->
  for el in sub
    return false if el not in arr
  true

# Remove duplicate strings from a string array
removeDuplicates = (arr) ->
  output = {}
  output[arr[key]] = arr[key] for key in [0...arr.length]
  value for key, value of output

# Remove objects with a duplicate "id" key from an array of objects
removeDuplicatesById = (arr) ->
  output = {}
  output[item.id] = item for item in arr
  value for key, value of output

# Turn an array of array of elements into an array of elements
flatten = (arr) ->
  [].concat(arr...)

export default {capitalize, singularize, find_in_object_array, get_name_for, ll,
  intersect, subset, removeDuplicates, removeDuplicatesById, flatten}