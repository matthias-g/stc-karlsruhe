module Helpers
  def sign_in(user)
    user.save!
    request['X-User-Email'] = user.email
    request['X-User-Token'] = user.authentication_token
  end
end

RSpec::Matchers.define :lead_project do |project|
  match do |user|
    user.leads_project? project
  end
end