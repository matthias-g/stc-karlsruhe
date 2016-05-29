class Participation < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates_presence_of :user, :project

  def self.active_user_count
    joins(:project).visible.select(:user_id).uniq.count
  end

end
