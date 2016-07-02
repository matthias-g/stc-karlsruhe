require 'test_helper'

class MessagesControllerTest < ActionController::TestCase

  test "send admin mail about project weeks to all users" do
    sign_in users(:admin)
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      post :send_admin_mail, message: { recipient: 'all_users', sender: 'test@stc.com', type: 'about_project_weeks', subject: 'Test', body: 'Hey, check this test out!' }
    end
    mail = ActionMailer::Base.deliveries.last
    assert_equal 3, mail.bcc.count
    assert (not mail.bcc.include? users(:deleted).email)
    assert mail.bcc.include? users(:sabine).email
  end

  test "send other email from orga to all users" do
    sign_in users(:admin)
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      post :send_admin_mail, message: { recipient: 'all_users', sender: 'test@stc.com', type: 'other_email_from_orga', subject: 'Test', body: 'Hey, check this test out!' }
    end
    mail = ActionMailer::Base.deliveries.last
    assert_equal 2, mail.bcc.count
    assert (not mail.bcc.include? users(:deleted).email)
    assert (not mail.bcc.include? users(:sabine).email)
  end

end
