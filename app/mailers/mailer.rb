class Mailer < ActionMailer::Base
  default from: StcKarlsruhe::Application::NO_REPLY_SENDER

  def contact_mail(message)
    @message = message.body
    recipient = StcKarlsruhe::Application::CONTACT_FORM_RECIPIENT
    mail from: message.sender, to: recipient, reply_to: message.sender, subject: message.subject
  end

  def project_mail(message, sender, project)
    @message = message.body
    @project_title = project.title
    @sender = sender
    recipients = project.volunteers.map { |v| v.email}.join(',') + ',' + sender.email
    mail from: "Serve the City Karlsruhe <no-reply@servethecity-karlsruhe.de>",
         bcc: recipients, reply_to: sender.email, subject: message.subject
  end

  def user_mail(message, sender, recipient)
    @message = message.body
    @sender = sender
    @recipient = recipient
    mail from: "Serve the City Karlsruhe <no-reply@servethecity-karlsruhe.de>",
         to: recipient.email, reply_to: sender.email, subject: message.subject
  end

  def generic_mail(message, bcc = nil)
    @message = message.body
    if bcc
      mail from: message.sender, bcc: message.recipient, subject: message.subject
    else
      mail from: message.sender, to: message.recipient, subject: message.subject
    end
  end

end
