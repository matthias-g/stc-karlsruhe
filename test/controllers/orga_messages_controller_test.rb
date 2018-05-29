require 'test_helper'

class OrgaMessagesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @message = orga_messages(:default)
    ActionMailer::Base.deliveries = []
  end

  def all_emails(*user_fixtures)
    user_fixtures.map{|u| users(u).email}.to_set
  end

  def all_emails_minus(*user_fixtures)
    (User.all - user_fixtures.map{|u| users(u)}).pluck(:email).to_set
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
    sign_in users(:leader)
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
    @message.update_attributes recipient: :all_users, content_type: :about_action_groups
    sent_and_assert_orga_message @message
    assert_redirected_to orga_message_path(@message.reload)
    assert_equal users(:admin).id, @message.sender.id
    assert @message.sent?
    assert_equal all_emails_minus(:deleted), get_recipients.to_set
  end

  test "send other email from orga to all users" do
    sign_in users(:admin)
    @message.update_attributes recipient: :all_users, content_type: :other_email_from_orga
    sent_and_assert_orga_message @message
    assert_redirected_to orga_message_path(@message.reload)
    assert_equal users(:admin), @message.sender
    assert @message.sent?
    assert_equal all_emails_minus(:deleted), get_recipients.to_set
  end

  test "send other email from orga to active users" do
    sign_in users(:admin)
    @message.update_attributes recipient: :active_users, content_type: :other_email_from_orga
    sent_and_assert_orga_message @message
    assert_redirected_to orga_message_path(@message.reload)
    assert_equal users(:admin).id, @message.sender.id
    assert @message.sent?
    assert_equal all_emails_minus(:deleted, :ancient_user), get_recipients.to_set
  end

  test "send other email from orga to current volunteers" do
    sign_in users(:admin)
    @message.update_attributes recipient: :current_volunteers, content_type: :other_email_from_orga
    sent_and_assert_orga_message @message
    assert_redirected_to orga_message_path(@message.reload)
    assert_equal users(:admin).id, @message.sender.id
    assert @message.sent?
    assert_equal all_emails(:volunteer, :subaction_volunteer, :subaction_2_volunteer, :ancient_user, :admin),
                 get_recipients.to_set
  end

  test "send other email from orga to current leaders" do
    sign_in users(:admin)
    @message.update_attributes recipient: :current_leaders, content_type: :other_email_from_orga
    sent_and_assert_orga_message @message
    assert_redirected_to orga_message_path(@message.reload)
    assert_equal users(:admin).id, @message.sender.id
    assert @message.sent?
    assert_equal all_emails(:leader, :subaction_leader, :admin), get_recipients.to_set
  end

  test "send other email from orga to current volunteers and leaders" do
    sign_in users(:admin)
    @message.update_attributes recipient: :current_volunteers_and_leaders, content_type: :other_email_from_orga
    sent_and_assert_orga_message @message
    assert_redirected_to orga_message_path(@message.reload)
    assert_equal users(:admin).id, @message.sender.id
    assert @message.sent?
    assert_equal all_emails(:volunteer, :subaction_volunteer, :subaction_2_volunteer,
                            :ancient_user, :leader, :subaction_leader, :admin),
                 get_recipients.to_set
  end



end
