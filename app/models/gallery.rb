class Gallery < ActiveRecord::Base

  has_many :gallery_pictures
  accepts_nested_attributes_for :gallery_pictures

end
