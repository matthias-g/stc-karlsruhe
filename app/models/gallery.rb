class Gallery < ApplicationRecord

  has_many :gallery_pictures, dependent: :destroy
  accepts_nested_attributes_for :gallery_pictures
  has_many :projects
  has_many :news_entries

end
