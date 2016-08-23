require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest

  test 'send contact mail' do
    assert_difference 'ActionMailer::Base.deliveries.size', +2 do
      post send_contact_mail_url, params: { message: { recipient: 'default@servethecity-karlsruhe.de', sender: 'test@stc.com',
                                          subject: 'Test', body: 'Hey, how are you?' } }
    end
  end

end
