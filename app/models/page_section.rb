class PageSection < ActiveRecord::Base
  belongs_to :page

  validates_presence_of :index

end
