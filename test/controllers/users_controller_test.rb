require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:unrelated)
  end

  test "should send message to user" do
    sign_in users(:unrelated_2)
    assert_mails_sent(1) do
      post contact_user_user_path(@user),
           params: { message: { subject: 'Test', body: 'Hey, how are you?'} }
    end
    assert_equal all_mails(:unrelated), mail_recipients
  end


  # TODO test that clear! is persisted with save!

end
