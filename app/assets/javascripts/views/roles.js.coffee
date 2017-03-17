# handler for "add-user-to-role" select
@addUserToRole = (userId, html) ->
  roleId = html.data('role-id')
  data = {
    'data': [
      { 'type': 'roles', 'id': roleId }
    ]
  }
  window.requestToJsonApi("/api/users/#{userId}/relationships/roles", 'POST', data).done ->
    location.reload()

@removeUserFromRole = (userId, roleId) ->
  data = {
    'data': [
      { 'type': 'roles', 'id': roleId }
    ]
  }
  return window.requestToJsonApi("/api/users/#{userId}/relationships/roles", 'DELETE', data)

$ ->
  $('.role-info .glyphicon-remove').click (event) ->
    event.preventDefault()
    removeButton = $(@)
    userId = removeButton.data('user-id')
    roleId = removeButton.data('role-id')
    window.removeUserFromRole(userId, roleId).done ->
      removeButton.closest('.user').remove()