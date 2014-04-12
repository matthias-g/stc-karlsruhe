class ContactFormMailer < ActionMailer::Base
  default to: "admins@stc-karlsruhe.de"

  def contact subject, message, reply_to
    @message = message
    mail subject: subject, reply_to: reply_to
  end
end
