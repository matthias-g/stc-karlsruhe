class ContactUserMailer < ActionMailer::Base
  default from: "no-reply@stc-karlsruhe.de"

  def contact_user user, subject, content, reply_to
    @message = content
    mail to: user.mail, subject: subject, reply_to: reply_to
  end
end
