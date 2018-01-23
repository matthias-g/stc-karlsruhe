class Leadership < ActiveRecord::Base
  belongs_to :user
  belongs_to :action

  validates_presence_of :user, :action
end
