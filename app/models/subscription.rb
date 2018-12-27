class Subscription < ApplicationRecord

  validates_presence_of :email, :name
  validates_uniqueness_of :email, scope: :confirmed_at

  after_create :check_and_send_confirmation_request

  scope :confirmed, -> { where.not(confirmed_at: nil) }

  def confirmed?
    !confirmed_at.nil?
  end

  def check_and_send_confirmation_request
    if confirmed_at
      user = User.find_by_email(email)
      update(confirmed_at: user.confirmed_at)
    end
    Mailer.subscription_creation_mail(self).deliver_later if confirmed_at.nil?
  end

end
