class Project < ActiveRecord::Base

  has_and_belongs_to_many :volunteers, :class_name => 'User', :join_table => 'projects_volunteers'

  def add_volunteer(user)
    raise ArgumentException, 'User should be a user object.' unless user.is_a?(User)
    volunteers << user unless has_volunteer?(user)
  end

  def has_volunteer?(user)
    return false unless user
    raise ArgumentException, 'User should be a user object.' unless user.is_a?(User)
    volunteers.any?{ |v| v.username == user.username }
  end

  def delete_volunteer(user)
    if has_volunteer?(user)
      volunteers.delete(user)
    end
  end

  def make_visible
    self.visible = true
    self.save
  end

  def make_invisible
    self.visible = false
    self.save
  end

end
