class ContactFormMailer < ActionMailer::Base
  default to: "admins@stc-karlsruhe.de"

  def contact subject, content, reply_to
    @content = content
    mail subject: subject, reply_to: reply_to
  end
end
