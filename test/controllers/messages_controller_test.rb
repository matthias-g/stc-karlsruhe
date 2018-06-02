require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest

  def assert_mails_sent(count, &block)
    assert_difference 'ActionMailer::Base.deliveries.size', count do
      perform_enqueued_jobs(&block)
    end
  end

  test "send contact mail" do
    assert_mails_sent(2) do
      post send_contact_mail_url, params: { message: { recipient: 'default@servethecity-karlsruhe.de', sender: 'test@stc.com',
                                          subject: 'Test', body: 'Hey, how are you?', privacy_consent: '1' } }
    end
  end

  test "try sending contact mail but fail privacy consent" do
    assert_mails_sent(0) do
      post send_contact_mail_url, params: { message: { recipient: 'default@servethecity-karlsruhe.de', sender: 'test@stc.com',
                                                       subject: 'Test', body: 'Hey, how are you?', privacy_consent: '0' } }
    end
  end

  test "try sending contact mail but fail captcha test" do
    Recaptcha.configuration.skip_verify_env.delete("test")
    assert_mails_sent(0) do
      post send_contact_mail_url, params: { message: { recipient: 'default@servethecity-karlsruhe.de', sender: 'test@stc.com',
                                                       subject: 'Test', body: 'Hey, how are you?', privacy_consent: '1' } }
    end
    Recaptcha.configuration.skip_verify_env.push("test")
  end

end
