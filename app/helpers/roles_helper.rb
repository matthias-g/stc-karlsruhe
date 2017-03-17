module RolesHelper
  def options_for_add_user_to_role(role)
    options = policy_scope(User.all.where(cleared: false)).order(:first_name, :last_name).map do |user|
      [user.full_name, user.id, {data: { tokens: user.username }}]
    end
    options_for_select(options)
  end
end
