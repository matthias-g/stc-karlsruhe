require 'test_helper'

class MessagesControllerTest < ActionController::TestCase

  test "send admin mail to all users" do
    sign_in users(:admin)
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      post :send_admin_mail, message: { recipient: 'all_users', sender: 'test@stc.com', subject: 'Test', body: 'Hey, check this test out!' }
    end
    mail = ActionMailer::Base.deliveries.last
    assert_equal 3, mail.bcc.count
    assert (not mail.bcc.include? users(:deleted).email)
  end

end
