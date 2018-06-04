module Helpers
  def sign_in(user)
    user.save!
    request['X-User-Email'] = user.email
    request['X-User-Token'] = user.authentication_token
  end

  def should_fail
    is_expected.to be_falsey
  end

  def should_pass
    is_expected.to be_truthy
  end

  def grants_access
    expect(subject).to permit(user, action)
  end

  def denies_access
    expect(subject).not_to permit(user, action)
  end

  def grants_access_to_project
    expect(subject).to permit(user, project)
  end

  def denies_access_to_project
    expect(subject).not_to permit(user, project)
  end

  def finish_initiative(initiative)
    initiative.events.each do |event|
      event.update_attribute :date, 2.days.ago
    end
  end

  def hide_initiative(initiative)
    initiative.update_attribute :visible, false
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