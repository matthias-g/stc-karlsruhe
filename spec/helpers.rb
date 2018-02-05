module Helpers
  def sign_in(user)
    user.save!
    request['X-User-Email'] = user.email
    request['X-User-Token'] = user.authentication_token
  end
end

module Fixtures extend ActiveSupport::Concern
included do
  def actions(title)
    action = Action.find_by(title: title)
    action.save! # trigger save hooks
    action
  end
  def roles(title)
    Role.find_by(title: title)
  end
  def users(username)
    User.find_by(username: username)
  end
end
end

RSpec::Matchers.define :lead_action do |action|
  match do |user|
    user.leads_action? action
  end
end

RSpec::Matchers.define :volunteer_in_action do |action|
  match do |user|
    action.volunteer?(user)
  end
end