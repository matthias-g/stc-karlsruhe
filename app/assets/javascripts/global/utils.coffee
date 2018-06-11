@capitalize = (str) ->
  str.charAt(0).toUpperCase() + str.slice(1);

@singularize = (str) ->
  str.slice(0, -1)

@find_in_object_array = (id, myArray) ->
  for obj in myArray
    return obj if obj.id == id
  return null