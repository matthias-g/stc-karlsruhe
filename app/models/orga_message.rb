class OrgaMessage < ApplicationRecord
  include OrgaMessagesHelper

  belongs_to :author, class_name: 'User'
  belongs_to :sender, class_name: 'User'

  validates :from, :recipient, :content_type, :subject, :body, :author, presence: true, allow_blank: false

  def sent?
    sent_at != nil
  end

  def send_message sender
    self.sender = sender
    Mailer.orga_mail(self).deliver_now
    self.sent_at = Time.now
    self.recipient = render_recipient_group self.recipient, sender
    self.save
  end

end
