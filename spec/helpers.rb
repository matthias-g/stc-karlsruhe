module Helpers
  def sign_in(user)
    user.save!
    request['X-User-Email'] = user.email
    request['X-User-Token'] = user.authentication_token
  end
end

module Fixtures extend ActiveSupport::Concern
included do
  def projects(title)
    Project.find_by(title: title)
  end
  def roles(title)
    Role.find_by(title: title)
  end
  def users(username)
    User.find_by(username: username)
  end
end
end

RSpec::Matchers.define :lead_project do |project|
  match do |user|
    user.leads_project? project
  end
end