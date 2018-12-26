require 'test_helper'

class OrgaMessageTest < ActiveSupport::TestCase

  setup do
    @message = orga_messages(:default)
  end

  def get_message_recipient_set(sender)
    @message.calculate_recipients_for_sender(sender).pluck(:email).to_set
  end



  test "sent? is false for unsent message" do
    assert_not @message.sent?
  end

  test "sent? is true for sent message" do
    assert orga_messages(:already_sent).sent?
  end

  test "send_message" do
    @message.send_message users(:coordinator)
    assert @message.sent?
    assert @message.sent_at > 10.seconds.ago
    assert @message.sent_at < Time.now
    assert_equal users(:coordinator), @message.sender
    assert_not_empty @message.sent_to
    assert_not_empty @message.recipient
  end

  test "recipients includes correct users" do
    sender = users(:coordinator)

    @message.recipient = :current_volunteers_and_leaders
    assert_equal all_mails(:volunteer, :subaction_volunteer,
                           :subaction_2_volunteer, :ancient_user,
                           :leader, :subaction_leader),
                 get_message_recipient_set(sender)

    @message.recipient = :current_volunteers
    assert_equal all_mails(:volunteer, :subaction_volunteer,
                           :subaction_2_volunteer, :ancient_user),
                 get_message_recipient_set(sender)

    @message.recipient = :current_leaders
    assert_equal all_mails(:leader, :subaction_leader),
                 get_message_recipient_set(sender)

    @message.recipient = :all_users
    assert_equal all_subscription_mails,
                 get_message_recipient_set(sender)

    @message.recipient = :test
    assert_equal 1000, @message.calculate_recipients_for_sender(sender).count
    assert_equal all_mails(:coordinator), get_message_recipient_set(sender)

    @message.recipient = :sender
    assert_equal 1, @message.calculate_recipients_for_sender(sender).count
    assert_equal all_mails(:coordinator), get_message_recipient_set(sender)
  end


  test "recipients does not include users who dont want the mails" do
    assert_includes @message.calculate_recipients_for_sender(users(:coordinator)), subscriptions(:volunteer)
    subscriptions(:volunteer).update_attribute :receive_emails_about_action_groups, false
    assert_not_includes @message.calculate_recipients_for_sender(users(:coordinator)), subscriptions(:volunteer)
  end

end
