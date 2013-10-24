class PageSection < ActiveRecord::Base
  attr_accessible :content, :title

  has_and_belongs_to_many :pages
end
