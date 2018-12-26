require 'test_helper'

class SubscriptionsControllerTest < ActionDispatch::IntegrationTest

  test "create subscription" do
    subscription = nil
    assert_mails_sent(1) do
      subscription = Subscription.create!(email: 'asdfasfd@asdf.com', name: 'Test Name')
    end
    assert subscription.confirmed_at.nil?
    get confirm_newsletter_url(sgid: subscription.to_sgid(for: :confirm))
    subscription.reload
    assert_not subscription.confirmed_at.nil?
    assert_equal I18n.t('subscription.confirmation.success'), flash[:notice]
  end

  test "unsubscribe emails about action groups" do
    subscription = subscriptions(:volunteer)
    assert subscription.receive_emails_about_action_groups
    get unsubscribe_url(sgid: subscription.to_sgid(for: :unsubscribe), type: :receive_emails_about_action_groups)
    subscription.reload
    assert_not subscription.receive_emails_about_action_groups
    assert_equal I18n.t('subscription.removal.success'), flash[:notice]
  end

  test "unsubscribe all emails removes subscription" do
    subscription = subscriptions(:volunteer)
    assert subscription.receive_emails_about_action_groups
    assert subscription.receive_emails_about_other_projects
    assert subscription.receive_other_emails_from_orga
    get unsubscribe_url(sgid: subscription.to_sgid(for: :unsubscribe), type: :all_emails)
    assert_equal I18n.t('subscription.removal.success'), flash[:notice]
    assert_not Subscription.exists?(subscription.id)
  end

  test "unsubscribe without type fails" do
    subscription = subscriptions(:volunteer)
    assert subscription.receive_emails_about_action_groups
    assert subscription.receive_emails_about_other_projects
    assert subscription.receive_other_emails_from_orga
    get unsubscribe_url(sgid: subscription.to_sgid(for: :unsubscribe))
    subscription.reload
    assert_equal I18n.t('subscription.removal.failed'), flash[:error]
    assert subscription.receive_emails_about_action_groups
    assert subscription.receive_emails_about_other_projects
    assert subscription.receive_other_emails_from_orga
  end

  test "unsubscribe of last option removes subscription" do
    subscription = subscriptions(:volunteer)
    subscription.receive_other_emails_from_orga = false
    subscription.receive_emails_about_action_groups = false
    subscription.save!
    assert subscription.receive_emails_about_other_projects
    get unsubscribe_url(sgid: subscription.to_sgid(for: :unsubscribe), type: :receive_emails_about_other_projects)
    assert_equal I18n.t('subscription.removal.success'), flash[:notice]
    assert_not Subscription.exists?(subscription.id)
  end
end
