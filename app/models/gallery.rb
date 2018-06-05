class Gallery < ApplicationRecord

  belongs_to :owner, polymorphic: true, optional: true

  has_many :gallery_pictures, dependent: :destroy
  accepts_nested_attributes_for :gallery_pictures

end
