class Subscription < ApplicationRecord

  validates_presence_of :email, :name
  validates_uniqueness_of :email

  after_create :check_and_send_confirmation_request

  scope :confirmed, -> { where.not(confirmed_at: nil) }

  def confirmed?
    !confirmed_at.nil?
  end

  def check_and_send_confirmation_request
    user = User.find_by_email(email)
    if user
      update(confirmed_at: user.created_at) # TODO should be user.confirmed_at
    end
    Mailer.subscription_creation_mail(self).deliver_later if confirmed_at.nil?
  end

end
