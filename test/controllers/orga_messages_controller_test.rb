require 'test_helper'

class OrgaMessagesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @message = orga_messages(:one)
    ActionMailer::Base.deliveries = []
  end

  def get_recipients
    ActionMailer::Base.deliveries.map(&:to).flatten
  end

  def sent_and_assert_orga_message(message)
    assert_changes 'ActionMailer::Base.deliveries.size' do
      perform_enqueued_jobs do
        get send_message_orga_message_url(message)
      end
    end
  end

  test "should get index" do
    sign_in users(:admin)
    get orga_messages_url
    assert_response :success
    assert_select 'tbody tr', 3
  end

  test "should get new" do
    sign_in users(:admin)
    get new_orga_message_url
    assert_response :success
  end

  test "should create orga_message" do
    sign_in users(:admin)
    assert_difference('OrgaMessage.count') do
      post orga_messages_url, params: { orga_message: { from: @message.from, recipient: @message.recipient, content_type: @message.content_type,
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
    patch orga_message_url(@message), params: { orga_message: { from: @message.from, recipient: @message.recipient, content_type: @message.content_type,
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
      post orga_messages_url, params: { orga_message: { from: @message.from, recipient: @message.recipient, content_type: @message.content_type,
                                    subject: @message.subject, body: @message.body} }
    end
    assert_redirected_to new_user_session_url
    get orga_message_url(@message)
    assert_redirected_to new_user_session_url
    get edit_orga_message_url(@message)
    assert_redirected_to new_user_session_url
    patch orga_message_url(@message), params: { orga_message: { from: @message.from, recipient: @message.recipient, content_type: @message.content_type,
                                                 subject: @message.subject, body: @message.body} }
    assert_redirected_to new_user_session_url
    assert_no_difference 'OrgaMessage.count' do
      delete orga_message_url(@message)
    end
    assert_redirected_to new_user_session_url
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      get send_message_orga_message_url(@message)
    end
    assert_redirected_to new_user_session_url
  end

  test "don't do anything for non admins" do
    sign_in users(:rolf)
    get orga_messages_url
    assert_redirected_to root_url
    get new_orga_message_url
    assert_redirected_to root_url
    assert_no_difference 'OrgaMessage.count' do
      post orga_messages_url, params: { orga_message: { from: @message.from, recipient: @message.recipient, content_type: @message.content_type,
                                                        subject: @message.subject, body: @message.body} }
    end
    assert_redirected_to root_url
    get orga_message_url(@message)
    assert_redirected_to root_url
    get edit_orga_message_url(@message)
    assert_redirected_to root_url
    patch orga_message_url(@message), params: { orga_message: { from: @message.from, recipient: @message.recipient, content_type: @message.content_type,
                                                                subject: @message.subject, body: @message.body} }
    assert_redirected_to root_url
    assert_no_difference 'OrgaMessage.count' do
      delete orga_message_url(@message)
    end
    assert_redirected_to root_url
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      get send_message_orga_message_url(@message)
    end
    assert_redirected_to root_url
  end

  test "send mail about action groups to all users" do
    sign_in users(:admin)
    sent_and_assert_orga_message @message
    assert_redirected_to orga_message_path(@message.reload)
    assert_equal users(:admin).id, @message.sender.id
    assert @message.sent?
    recipients = get_recipients
    assert_equal (User.count - 2) + 1, recipients.count
    assert_not_includes recipients, users(:deleted).email
    assert_includes recipients, users(:sabine).email
  end

  test "send other email from orga to all users" do
    sign_in users(:admin)
    message = orga_messages(:two)
    sent_and_assert_orga_message message
    assert_redirected_to orga_message_path(message.reload)
    assert_equal users(:admin).id, message.sender.id
    assert message.sent?
    recipients = get_recipients
    assert_equal (User.count - 2) + 1, recipients.count
    assert_not_includes recipients, users(:deleted).email
    assert_not_includes recipients, users(:sabine).email
  end

  test "send other email from orga to active users" do
    sign_in users(:admin)
    message = orga_messages(:two)
    message.recipient = :active_users
    message.save!
    sent_and_assert_orga_message message
    assert_redirected_to orga_message_path(message.reload)
    assert_equal users(:admin).id, message.sender.id
    assert message.sent?
    recipients = get_recipients
    assert_equal (User.count - 3) + 1, recipients.count
    assert_not_includes recipients, users(:deleted).email
    assert_not_includes recipients, users(:sabine).email
    assert_not_includes recipients, users(:lea).email  # is old user
  end

  test "send other email from orga to current volunteers" do
    sign_in users(:admin)
    message = orga_messages(:two)
    message.recipient = :current_volunteers
    message.save!
    sent_and_assert_orga_message message
    assert_redirected_to orga_message_path(message.reload)
    assert_equal users(:admin).id, message.sender.id
    assert message.sent?
    recipients = get_recipients
    assert_equal 3, recipients.count
    assert_not_includes recipients, users(:sabine).email # is disabled
    assert_includes recipients, users(:lea).email
    assert_includes recipients, users(:peter).email
    assert_includes recipients, users(:admin).email
  end

  test "send other email from orga to current leaders" do
    sign_in users(:admin)
    message = orga_messages(:two)
    message.recipient = :current_leaders
    message.save!
    sent_and_assert_orga_message message
    assert_redirected_to orga_message_path(message.reload)
    assert_equal users(:admin).id, message.sender.id
    assert message.sent?
    recipients = get_recipients
    assert_equal 4, recipients.count
    assert_includes recipients,  users(:tabea).email
    assert_includes recipients,  users(:birgit).email
    assert_includes recipients,  users(:rolf).email
    assert_includes recipients,  users(:admin).email
  end

  test "send other email from orga to current volunteers and leaders" do
    sign_in users(:admin)
    message = orga_messages(:two)
    message.recipient = :current_volunteers_and_leaders
    message.save!
    sent_and_assert_orga_message message
    assert_redirected_to orga_message_path(message.reload)
    assert_equal users(:admin).id, message.sender.id
    assert message.sent?
    recipients = get_recipients
    assert_equal 6, recipients.count
    assert_not_includes recipients, users(:sabine).email # is disabled
    assert_includes recipients, users(:lea).email
    assert_includes recipients, users(:peter).email
    assert_includes recipients, users(:tabea).email
    assert_includes recipients, users(:birgit).email
    assert_includes recipients, users(:rolf).email
    assert_includes recipients, users(:admin).email
  end

  test "send email about action groups from orga to all users" do
    sign_in users(:admin)
    message = orga_messages(:two)
    message.recipient = :all_users
    message.content_type = :about_action_groups
    message.save!
    sent_and_assert_orga_message message
    assert_redirected_to orga_message_path(message.reload)
    assert_equal users(:admin).id, message.sender.id
    assert message.sent?
    recipients = get_recipients
    assert_equal (User.count - 2) + 1, recipients.count
    assert_not_includes recipients, users(:deleted).email
    assert_not_includes recipients, users(:peter).email
  end

end
