class Refinery::Projects::Day < Refinery::Core::BaseModel
  attr_accessible :title
  validates :title, :presence => true, :uniqueness => true
end
