require 'test_helper'

class OrgaMessageTest < ActiveSupport::TestCase

  setup do
    @message = orga_messages(:default)
  end

  def all_emails(*user_fixtures)
    user_fixtures.map{|u| users(u).email}.to_set
  end

  def all_emails_minus(*user_fixtures)
    (User.all - user_fixtures.map{|u| users(u)}).pluck(:email).to_set
  end

  def get_message_recipient_set(sender)
    @message.recipients(sender).pluck(:email).to_set
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
    assert_equal all_emails(:volunteer, :subaction_volunteer,
                            :subaction_2_volunteer, :ancient_user,
                            :leader, :subaction_leader),
                 get_message_recipient_set(sender)

    @message.recipient = :current_volunteers
    assert_equal all_emails(:volunteer, :subaction_volunteer,
                            :subaction_2_volunteer, :ancient_user),
                 get_message_recipient_set(sender)

    @message.recipient = :current_leaders
    assert_equal all_emails(:leader, :subaction_leader),
                 get_message_recipient_set(sender)

    @message.recipient = :all_users
    assert_equal all_emails_minus(:deleted),
                 get_message_recipient_set(sender)

    @message.recipient = :active_users
    assert_equal all_emails_minus(:deleted, :ancient_user),
                 get_message_recipient_set(sender)

    @message.recipient = :test
    assert_equal 1000, @message.recipients(sender).count
    assert_equal all_emails(:coordinator), get_message_recipient_set(sender)

    @message.recipient = :sender
    assert_equal 1, @message.recipients(sender).count
    assert_equal all_emails(:coordinator), get_message_recipient_set(sender)
  end

  test "recipients doesn't include users who dont want the mails" do
    users(:volunteer).update_attribute :receive_emails_about_action_groups, false
    assert_not_includes @message.recipients(users(:coordinator)), users(:volunteer)
  end

end
