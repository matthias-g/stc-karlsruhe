class ContactFormMailer < ActionMailer::Base
  default to: CONTACT_RECIPIENT

  def new_message(message)
    @message = message.body
    mail subject: message.subject, reply_to: message.email
  end
end
