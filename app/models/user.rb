class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :projects_as_volunteer, :class_name => 'Project' , :join_table => 'projects_volunteers'
  has_and_belongs_to_many :projects_as_leader, :class_name => 'Project' , :join_table => 'projects_leaders'
  has_and_belongs_to_many :roles

  validates :username, :presence => true, :uniqueness => { :case_sensitive => false }, :format => { with: /\A[a-zA-Z0-9]+\z/, message: 'only allows letters' }
  validates :forename, :presence => true
  validates :lastname, :presence => true
  attr_accessor :login

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(['lower(username) = :value OR lower(email) = :value', { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def full_name
    forename + ' ' + lastname
  end

  def leads_project?(project)
    projects_as_leader.any?{|p| p.id == project.id}
  end

  # based on https://github.com/refinery/refinerycms/blob/master/authentication/app/models/refinery/user.rb
  def add_role(title)
    raise ArgumentException, 'Role should be the title of the role not a role object.' if title.is_a?(Role)
    roles << Role[title] unless has_role?(title)
  end

  # based on https://github.com/refinery/refinerycms/blob/master/authentication/app/models/refinery/user.rb
  def has_role?(title)
    raise ArgumentException, 'Role should be the title of the role not a role object.' if title.is_a?(Role)
    roles.any?{|r| r.title == title.to_s.camelize}
  end

  def is_admin?
    has_role?(:admin)
  end

end
