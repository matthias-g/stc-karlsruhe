require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest

  test 'send contact mail' do
    assert_difference 'ActionMailer::Base.deliveries.size', +2 do
      post send_contact_mail_url, params: { message: { recipient: 'default@servethecity-karlsruhe.de', sender: 'test@stc.com',
                                          subject: 'Test', body: 'Hey, how are you?' } }
    end
  end

  test 'try sending contact mail but fail captcha test' do
    Recaptcha.configuration.skip_verify_env.delete("test")
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      post send_contact_mail_url, params: { message: { recipient: 'default@servethecity-karlsruhe.de', sender: 'test@stc.com',
                                                       subject: 'Test', body: 'Hey, how are you?' } }
    end
    Recaptcha.configuration.skip_verify_env.push("test")
  end

end
