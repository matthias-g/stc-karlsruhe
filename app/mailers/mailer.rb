class Mailer < ActionMailer::Base
  default from: StcKarlsruhe::Application::NO_REPLY_SENDER

  def contact_mail(message)
    @message = message.body
    mail from: message.sender, to: StcKarlsruhe::Application::CONTACT_FORM_RECIPIENT, reply_to: message.sender, subject: message.subject
  end

  def multi_user_bcc_mail(message, from_name, project_title)
    @message = message.body
    @project_title = project_title
    mail from: "#{from_name} <no-reply@servethecity-karlsruhe.de>", bcc: message.recipient, reply_to: message.sender, subject: message.subject
  end

  def single_user_mail(message, from_name, to_name)
    @message = message.body
    @from_name = from_name
    @to_name = to_name
    mail from: "#{from_name} <no-reply@servethecity-karlsruhe.de>", to: message.recipient, reply_to: message.sender, subject: message.subject
  end

  def generic_mail(message)
    @message = message.body
    mail from: message.sender, to: message.recipient, subject: message.subject
  end
end
