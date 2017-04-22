require 'test_helper'

class OrgaMessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @message = orga_messages(:one)
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
    assert_select '#subject', @message.subject
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
    assert_redirected_to login_or_register_url
    get new_orga_message_url
    assert_redirected_to login_or_register_url
    assert_no_difference 'OrgaMessage.count' do
      post orga_messages_url, params: { orga_message: { from: @message.from, recipient: @message.recipient, content_type: @message.content_type,
                                    subject: @message.subject, body: @message.body} }
    end
    assert_redirected_to login_or_register_url
    get orga_message_url(@message)
    assert_redirected_to login_or_register_url
    get edit_orga_message_url(@message)
    assert_redirected_to login_or_register_url
    patch orga_message_url(@message), params: { orga_message: { from: @message.from, recipient: @message.recipient, content_type: @message.content_type,
                                                 subject: @message.subject, body: @message.body} }
    assert_redirected_to login_or_register_url
    assert_no_difference 'OrgaMessage.count' do
      delete orga_message_url(@message)
    end
    assert_redirected_to login_or_register_url
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      get send_message_orga_message_url(@message)
    end
    assert_redirected_to login_or_register_url
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

  test "send mail about project weeks to all users" do
    sign_in users(:admin)
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      get send_message_orga_message_url(@message)
    end
    assert_redirected_to orga_message_path(@message.reload)
    assert_equal users(:admin).id, @message.sender.id
    assert @message.sent?
    mail = ActionMailer::Base.deliveries.last
    assert_equal (User.count - 2), mail.bcc.count
    assert (not mail.bcc.include? users(:deleted).email)
    assert mail.bcc.include? users(:sabine).email
  end

  test "send other email from orga to all users" do
    sign_in users(:admin)
    message = orga_messages(:two)
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      get send_message_orga_message_url(message)
    end
    assert_redirected_to orga_message_path(message.reload)
    assert_equal users(:admin).id, message.sender.id
    assert message.sent?
    mail = ActionMailer::Base.deliveries.last
    assert_equal (User.count - 2), mail.bcc.count
    assert (not mail.bcc.include? users(:deleted).email)
    assert (not mail.bcc.include? users(:sabine).email)
  end

  test "send other email from orga to active users" do
    sign_in users(:admin)
    message = orga_messages(:two)
    message.recipient = :active_users
    message.save!
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      get send_message_orga_message_url(message)
    end
    assert_redirected_to orga_message_path(message.reload)
    assert_equal users(:admin).id, message.sender.id
    assert message.sent?
    mail = ActionMailer::Base.deliveries.last
    assert_equal (User.count - 3), mail.bcc.count
    assert (not mail.bcc.include? users(:deleted).email)
    assert (not mail.bcc.include? users(:sabine).email)
    assert (not mail.bcc.include? users(:lea).email)  # is old user
  end

  test "send email about project weeks from orga to all users" do
    sign_in users(:admin)
    message = orga_messages(:two)
    message.recipient = :all_users
    message.content_type = :about_project_weeks
    message.save!
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      get send_message_orga_message_url(message)
    end
    assert_redirected_to orga_message_path(message.reload)
    assert_equal users(:admin).id, message.sender.id
    assert message.sent?
    mail = ActionMailer::Base.deliveries.last
    assert_equal (User.count - 2), mail.bcc.count
    assert (not mail.bcc.include? users(:deleted).email)
    assert (not mail.bcc.include? users(:peter).email)
  end

end
