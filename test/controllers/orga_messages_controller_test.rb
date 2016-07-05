require 'test_helper'

class OrgaMessagesControllerTest < ActionController::TestCase
  setup do
    @message = orga_messages(:one)
  end

  test "should get index" do
    sign_in users(:admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:messages)
  end

  test "should get new" do
    sign_in users(:admin)
    get :new
    assert_response :success
  end

  test "should create orga_message" do
    sign_in users(:admin)
    assert_difference('OrgaMessage.count') do
      post :create, orga_message: { from: @message.from, recipient: @message.recipient, content_type: @message.content_type,
                                    subject: @message.subject, body: @message.body}
    end

    assert_redirected_to orga_message_path(assigns(:message))
  end

  test "should show orga_message" do
    sign_in users(:admin)
    get :show, id: @message
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:admin)
    get :edit, id: @message
    assert_response :success
  end

  test "should update orga_message" do
    sign_in users(:admin)
    patch :update, id: @message, orga_message: { from: @message.from, recipient: @message.recipient, content_type: @message.content_type,
                                                  subject: @message.subject, body: @message.body}
    assert_redirected_to orga_message_path(assigns(:message))
  end

  test "should destroy orga_message" do
    sign_in users(:admin)
    assert_difference('OrgaMessage.count', -1) do
      delete :destroy, id: @message
    end
    assert_redirected_to orga_messages_path
  end

  test "don't do anything for not logged in users" do
    get :index
    assert_redirected_to login_or_register_url
    get :new
    assert_redirected_to login_or_register_url
    assert_no_difference 'OrgaMessage.count' do
      post :create, orga_message: { from: @message.from, recipient: @message.recipient, content_type: @message.content_type,
                                    subject: @message.subject, body: @message.body}
    end
    assert_redirected_to login_or_register_url
    get :show, id: @message
    assert_redirected_to login_or_register_url
    get :edit, id: @message
    assert_redirected_to login_or_register_url
    patch :update, id: @message, orga_message: { from: @message.from, recipient: @message.recipient, content_type: @message.content_type,
                                                 subject: @message.subject, body: @message.body}
    assert_redirected_to login_or_register_url
    assert_no_difference 'OrgaMessage.count' do
      delete :destroy, id: @message
    end
    assert_redirected_to login_or_register_url
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      get :send_message, id: @message
    end
    assert_redirected_to login_or_register_url
  end

  test "don't do anything for non admins" do
    sign_in users(:rolf)
    get :index
    assert_redirected_to root_url
    get :new
    assert_redirected_to root_url
    assert_no_difference 'OrgaMessage.count' do
      post :create, orga_message: { from: @message.from, recipient: @message.recipient, content_type: @message.content_type,
                                    subject: @message.subject, body: @message.body}
    end
    assert_redirected_to root_url
    get :show, id: @message
    assert_redirected_to root_url
    get :edit, id: @message
    assert_redirected_to root_url
    patch :update, id: @message, orga_message: { from: @message.from, recipient: @message.recipient, content_type: @message.content_type,
                                                 subject: @message.subject, body: @message.body}
    assert_redirected_to root_url
    assert_no_difference 'OrgaMessage.count' do
      delete :destroy, id: @message
    end
    assert_redirected_to root_url
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      get :send_message, id: @message
    end
    assert_redirected_to root_url
  end

  test "send mail about project weeks to all users" do
    sign_in users(:admin)
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      get :send_message, id: @message
    end
    assert_redirected_to orga_message_path(assigns(:message))
    assert_equal users(:admin).id, assigns(:message).sender.id
    assert assigns(:message).sent?
    mail = ActionMailer::Base.deliveries.last
    assert_equal 3, mail.bcc.count
    assert (not mail.bcc.include? users(:deleted).email)
    assert mail.bcc.include? users(:sabine).email
  end

  test "send other email from orga to all users" do
    sign_in users(:admin)
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      get :send_message, id: orga_messages(:two)
    end
    assert_redirected_to orga_message_path(assigns(:message))
    assert_equal users(:admin).id, assigns(:message).sender.id
    assert assigns(:message).sent?
    mail = ActionMailer::Base.deliveries.last
    assert_equal 2, mail.bcc.count
    assert (not mail.bcc.include? users(:deleted).email)
    assert (not mail.bcc.include? users(:sabine).email)
  end

end
