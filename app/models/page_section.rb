class PageSection < ActiveRecord::Base
  belongs_to :page

  validates_presence_of :css_class

end
