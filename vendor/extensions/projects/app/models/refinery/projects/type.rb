class Refinery::Projects::Type < Refinery::Core::BaseModel
  attr_accessible :title
  validates :title, :presence => true, :uniqueness => true
end
