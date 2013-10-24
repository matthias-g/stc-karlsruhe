class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :username

  has_and_belongs_to_many :projects_as_leader, :class_name => '::Project'
  has_and_belongs_to_many :projects_as_volunteer, :class_name => '::Project'

end
