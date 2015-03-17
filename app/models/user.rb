class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :participations
  has_many :projects, through: :participations
  has_and_belongs_to_many :roles

  validates_presence_of :username, :first_name, :last_name
  validates :username,
      uniqueness: {case_sensitive: false},
      format: {with: /\A[\w]+\z/,
      message: I18n.t('activerecord.errors.messages.onlyLetters') }
  attr_accessor :login

  before_validation :set_default_username_if_blank!, on: :create

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(['lower(username) = :value OR lower(email) = :value', { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def full_name
    first_name + ' ' + last_name
  end

  def leads_project? project
    projects_as_leader.include? project
  end

  def projects_as_volunteer
    projects.where(participations: {as_leader: false})
  end

  def projects_as_leader
    projects.where(participations: {as_leader: true})
  end

  # based on https://github.com/refinery/refinerycms/blob/master/authentication/app/models/refinery/user.rb
  def add_role(title)
    raise ArgumentException, 'Role should be the title of the role not a role object.' if title.is_a?(Role)
    roles << Role.find {|r| r.title.camelize == title.to_s.camelize} unless has_role?(title)
  end

  # based on https://github.com/refinery/refinerycms/blob/master/authentication/app/models/refinery/user.rb
  def has_role?(title)
    raise ArgumentException, 'Role should be the title of the role not a role object.' if title.is_a?(Role)
    roles.any?{|r| r.title.camelize == title.to_s.camelize}
  end

  def is_admin?
    has_role?(:admin)
  end

  private

  def set_default_username_if_blank!
    if username.blank?
      possible_usernames = [first_name, "#{first_name}#{last_name.first}", "#{first_name}#{last_name}"]
      possible_usernames.each { |new_name|
        unless User.find_by_username(new_name)
          self.username = new_name
          return
        end
      }
      max_num = 10 * User.count
      while username.blank?
        new_name = "user#{rand(max_num)}"
        unless User.find_by_username(new_name)
          self.username = new_name
          return
        end
      end
    end
  end

end
