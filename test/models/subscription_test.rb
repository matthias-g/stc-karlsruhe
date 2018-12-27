require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase
  test "creation of subscription is not possible if unconfirmed subscription with same email exists" do
    Subscription.create!(email: 'volunteer0@example.com', name: 'volunteer',
                         receive_emails_about_action_groups: false, receive_emails_about_other_projects: true, receive_other_emails_from_orga: false)
    subscription = Subscription.create(email: 'volunteer0@example.com', name: 'volunteer',
                                       receive_emails_about_action_groups: true, receive_emails_about_other_projects: true, receive_other_emails_from_orga: false)
    assert_not subscription.valid?
  end
end
