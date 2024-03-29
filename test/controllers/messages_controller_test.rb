require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest

  test "send contact mail" do
    assert_mails_sent(2) do
      post send_contact_mail_url, params: { message: { recipient: 'default@servethecity-karlsruhe.de', sender: 'test@stc.com',
                                          subject: 'Test', body: 'Hey, how are you?', simple_spam_check: 'Karlsruhe'} }
    end
  end

  test "try sending contact mail but fail simple captcha test" do
    assert_mails_sent(0) do
      post send_contact_mail_url, params: { message: { recipient: 'default@servethecity-karlsruhe.de', sender: 'test@stc.com',
                                          subject: 'Test', body: 'Hey, how are you?'} }
    end
  end

  test "try sending contact mail but fail recaptcha test" do
    Recaptcha.configuration.skip_verify_env.delete("test")
    assert_mails_sent(0) do
      post send_contact_mail_url, params: { message: { recipient: 'default@servethecity-karlsruhe.de', sender: 'test@stc.com',
                                                       subject: 'Test', body: 'Hey, how are you?'} }
    end
    Recaptcha.configuration.skip_verify_env.push("test")
  end

end
