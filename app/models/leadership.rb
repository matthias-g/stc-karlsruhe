class Leadership < ActiveRecord::Base
  belongs_to :user
  belongs_to :initiative

  validates_presence_of :user, :initiative
end
