class ContactFormMailer < ActionMailer::Base
  default to: StcKarlsruhe::Application::CONTACT_RECIPIENT

  def new_message(message)
    @message = message.body
    mail subject: message.subject, from: message.email, reply_to: message.email
  end
end
