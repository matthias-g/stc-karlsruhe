onViewLoad 'roles', ->

  # enable "delete role from user" button
  $('.role-info .fa-trash').click (event) ->
    event.preventDefault()
    removeButton = $(@)
    userId = removeButton.data('user-id')
    roleId = removeButton.data('role-id')
    window.removeUserFromRole(userId, roleId).done ->
      removeButton.closest('.user').remove()

# Gives a user a role (handler for "add-user-to-role" select)
@addUserToRole = (userId, html) ->
  data = 'data': [type: 'roles', id: html.data('role-id')]
  window.requestToJsonApi("/api/users/#{userId}/relationships/roles", 'POST', data).done ->
    location.reload()

# Removes a role from a user
@removeUserFromRole = (userId, roleId) ->
  data = 'data': [type: 'roles', id: roleId]
  return window.requestToJsonApi("/api/users/#{userId}/relationships/roles", 'DELETE', data)

