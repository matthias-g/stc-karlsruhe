class Message

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :sender, :recipient, :subject, :body

  validate :sender, :recipient, format: { with: %r{.+@.+\..+} }
  validates :sender, :recipient, :body, :subject, presence: true, allow_blank: false

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

end