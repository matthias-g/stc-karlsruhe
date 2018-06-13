require 'test_helper'

class OrgaMessagesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @message = orga_messages(:default)
  end

  def send_and_assert_orga_message(message, count)
    assert_mails_sent(count) do
      get send_message_orga_message_url(message)
    end
  end



  test "should get index" do
    sign_in users(:admin)
    get orga_messages_url
    assert_response :success
    assert_select 'tbody tr', 2
  end

  test "should get new" do
    sign_in users(:admin)
    get new_orga_message_url
    assert_response :success
  end

  test "should create orga_message" do
    sign_in users(:admin)
    assert_difference('OrgaMessage.count') do
      post orga_messages_url, params: {
          orga_message: { from: @message.from, recipient: @message.recipient,
                          content_type: @message.content_type,
                          action_group_id: @message.action_group.id,
                          subject: @message.subject, body: @message.body} }
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'h1', /#{Regexp.quote(@message.subject)}/
  end

  test "should show orga_message" do
    sign_in users(:admin)
    get orga_message_url(@message)
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:admin)
    get edit_orga_message_url(@message)
    assert_response :success
  end

  test "should update orga_message" do
    sign_in users(:admin)
    patch orga_message_url(@message), params: {
        orga_message: { from: @message.from, recipient: @message.recipient,
                        content_type: @message.content_type,
                        action_group_id: @message.action_group.id,
                        subject: 'new subject', body: @message.body} }
    assert_redirected_to orga_message_path(@message.reload)
    assert_equal 'new subject', @message.subject
  end

  test "should destroy orga_message" do
    sign_in users(:admin)
    assert_difference('OrgaMessage.count', -1) do
      delete orga_message_url(@message)
    end
    assert_redirected_to orga_messages_path
  end

  test "don't do anything for not logged in users" do
    get orga_messages_url
    assert_redirected_to new_user_session_url
    get new_orga_message_url
    assert_redirected_to new_user_session_url
    assert_no_difference 'OrgaMessage.count' do
      post orga_messages_url, params: {
          orga_message: { from: @message.from, recipient: @message.recipient,
                          content_type: @message.content_type,
                          action_group_id: @message.action_group.id,
                          subject: @message.subject, body: @message.body} }
    end
    assert_redirected_to new_user_session_url
    get orga_message_url(@message)
    assert_redirected_to new_user_session_url
    get edit_orga_message_url(@message)
    assert_redirected_to new_user_session_url
    patch orga_message_url(@message), params: {
        orga_message: { from: @message.from, recipient: @message.recipient,
                        content_type: @message.content_type,
                        action_group_id: @message.action_group.id,
                        subject: @message.subject, body: @message.body} }
    assert_redirected_to new_user_session_url
    assert_no_difference 'OrgaMessage.count' do
      delete orga_message_url(@message)
    end
    assert_redirected_to new_user_session_url
    assert_mails_sent 0 do
      get send_message_orga_message_url(@message)
    end
    assert_redirected_to new_user_session_url
  end

  test "don't do anything for non admins" do
    sign_in users(:leader)
    get orga_messages_url
    assert_redirected_to root_url
    get new_orga_message_url
    assert_redirected_to root_url
    assert_no_difference 'OrgaMessage.count' do
      post orga_messages_url, params: {
          orga_message: { from: @message.from, recipient: @message.recipient,
                          content_type: @message.content_type,
                          action_group_id: @message.action_group.id,
                          subject: @message.subject, body: @message.body} }
    end
    assert_redirected_to root_url
    get orga_message_url(@message)
    assert_redirected_to root_url
    get edit_orga_message_url(@message)
    assert_redirected_to root_url
    patch orga_message_url(@message), params: {
        orga_message: { from: @message.from, recipient: @message.recipient,
                        content_type: @message.content_type,
                        action_group_id: @message.action_group.id,
                        subject: @message.subject, body: @message.body} }
    assert_redirected_to root_url
    assert_no_difference 'OrgaMessage.count' do
      delete orga_message_url(@message)
    end
    assert_redirected_to root_url
    assert_mails_sent 0 do
      get send_message_orga_message_url(@message)
    end
    assert_redirected_to root_url
  end

  test "sending an orga mail marks it as sent and redirects to 'show'" do
    sign_in users(:admin)
    get send_message_orga_message_url @message
    assert_redirected_to orga_message_path(@message.reload)
    assert_equal users(:admin).id, @message.sender.id
    assert @message.sent?
  end

  test "send 'mail about action groups' to all users" do
    sender = users(:admin)
    sign_in sender
    @message.update_attributes recipient: :all_users, content_type: :about_action_groups
    send_and_assert_orga_message(@message, Subscription.all.count + 1)
    assert_equal all_subscription_mails + [sender.email], mail_recipients
  end

  test "send 'other email from orga' to all users" do
    sender = users(:admin)
    sign_in sender
    @message.update_attributes recipient: :all_users, content_type: :other_email_from_orga
    not_receivers = Subscription.where(receive_other_emails_from_orga: false).pluck(:email)
    send_and_assert_orga_message(@message, Subscription.all.count - not_receivers.count + 1)
    assert_equal all_subscription_mails - not_receivers + [sender.email], mail_recipients
  end

  test "send 'other email from orga' to current volunteers" do
    sign_in users(:admin)
    @message.update_attributes recipient: :current_volunteers, content_type: :other_email_from_orga
    send_and_assert_orga_message(@message, 4 + 1)
    assert_equal all_mails(:volunteer, :subaction_volunteer, :subaction_2_volunteer,
                           :ancient_user, :admin), mail_recipients
  end

  test "send 'other email from orga' to current leaders" do
    sign_in users(:admin)
    @message.update_attributes recipient: :current_leaders, content_type: :other_email_from_orga
    send_and_assert_orga_message(@message, 2 + 1)
    assert_equal all_mails(:leader, :subaction_leader, :admin), mail_recipients
  end

  test "send 'other email from orga' to current volunteers and leaders" do
    sign_in users(:admin)
    @message.update_attributes recipient: :current_volunteers_and_leaders, content_type: :other_email_from_orga
    send_and_assert_orga_message(@message, 6 + 1)
    assert_equal all_mails(:volunteer, :subaction_volunteer, :subaction_2_volunteer,
                           :ancient_user, :leader, :subaction_leader, :admin), mail_recipients
  end



end
