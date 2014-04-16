class Mailer < ActionMailer::Base
  default from: StcKarlsruhe::Application::NO_REPLY_SENDER

  def contact_mail(message)
    @message = message.body
    mail from: message.sender, to: StcKarlsruhe::Application::CONTACT_FORM_RECIPIENT, reply_to: message.sender, subject: message.subject
  end

  def multi_user_bcc_mail(message)
    @message = message.body
    mail from: message.sender, bcc: message.recipient, reply_to: message.sender, subject: message.subject
  end

  def single_user_mail(message)
    @message = message.body
    mail from: message.sender, to: message.recipient, reply_to: message.sender, subject: message.subject
  end

  def notification_mail(message)
    @message = message.body
    mail from: StcKarlsruhe::Application::NO_REPLY_SENDER, to: message.recipient, reply_to: message.sender, subject: message.subject
  end
end
