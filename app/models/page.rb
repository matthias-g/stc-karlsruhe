class Page < ActiveRecord::Base
  has_many :sections, :class_name => 'PageSection'
  accepts_nested_attributes_for :sections

  validates_presence_of :header_name
end
