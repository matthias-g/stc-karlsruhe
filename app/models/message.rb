class Message

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :sender, :recipient, :type, :subject, :body, :recipient_scope, :simple_spam_check

  validates :sender, :recipient, format: { with: %r{.+@.+\..+} }
  validates :sender, :recipient, :subject, :body, presence: true, allow_blank: false

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  class << self
    def i18n_scope
      :activerecord
    end
  end

end
