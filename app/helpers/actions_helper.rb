module ActionsHelperc

  # creates a comma separated list of all user names (+ anonymous user count)
  # (currently unused)
  def list_users(users)
    existing_users = users.where(cleared: false)
    deleted_users_count = users.where(cleared: true).count
    output = existing_users.map { |v| link_to(v.first_name, user_path(v)) }.join(', ')
    if deleted_users_count > 0
      output += ' + ' if existing_users.count > 0
      output += deleted_users_count.to_s + ' ' + User.model_name.human(count: deleted_users_count)
    end
    output.html_safe
  end

  # gives a list of all possible parent actions
  def possible_parent_actions(action)
    actions = action.action_group ? action.action_group.actions : Action.where(action_group: nil)
    actions = policy_scope(actions.where(parent_action_id: nil)) - [action]
    actions.pluck(:title, :id)
  end

end
