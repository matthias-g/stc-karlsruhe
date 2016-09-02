class User < ApplicationRecord
  acts_as_token_authenticatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :participations, dependent: :destroy
  has_many :projects_as_volunteer, through: :participations, source: :project
  has_many :leaderships, dependent: :destroy
  has_many :projects_as_leader, through: :leaderships, source: :project
  has_and_belongs_to_many :roles

  USERNAME_FORMAT = /\A[\w]+\z/

  validates_presence_of :username, :first_name, :last_name, :email
  validates :username,
            uniqueness: { case_sensitive: false },
            format: { with: USERNAME_FORMAT, message: I18n.t('activerecord.errors.messages.onlyLetters') },
            length: { in: 2..50 }
  validates :email,
            uniqueness: { case_sensitive: false },
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i },
            length: { in: 5..100 }
  validates :first_name,
            length: { in: 2..50 },
            format: { with: /\A[[[:word:]]-\.]+( [[[:word:]]-\.]+)*\z/, message: I18n.t('activerecord.errors.messages.onlyWordsAndInnerSpace') }
  validates :last_name,
            length: { in: 2..50 },
            format: { with: /\A[[[:word:]]-\.]+( [[[:word:]]-\.]+)*\z/, message: I18n.t('activerecord.errors.messages.onlyWordsAndInnerSpace') }
  attr_accessor :login

  before_validation :set_default_username_if_blank!, on: :create

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    if login
      where(conditions.to_hash).where(['lower(username) = :value OR lower(email) = :value', { :value => login.downcase }]).first
    else
      conditions[:email].downcase! if conditions[:email]
      where(conditions.to_hash).first
    end
  end

  def full_name
    first_name + ' ' + last_name
  end

  def leads_project?(project)
    projects_as_leader.include? project
  end

  # based on https://github.com/refinery/refinerycms/blob/master/authentication/app/models/refinery/user.rb
  def add_role(title)
    raise ArgumentError, 'Role should be the title of the role not a role object.' if title.is_a?(Role)
    roles << Role.find {|r| r.title.camelize == title.to_s.camelize} unless has_role?(title)
  end

  # based on https://github.com/refinery/refinerycms/blob/master/authentication/app/models/refinery/user.rb
  def has_role?(title)
    raise ArgumentError, 'Role should be the title of the role not a role object.' if title.is_a?(Role)
    roles.any?{|r| r.title.camelize == title.to_s.camelize}
  end

  def admin?
    has_role?(:admin)
  end

  def photographer?
    has_role?(:photographer)
  end

  def clear!
    self.first_name = 'cleared'
    self.last_name = 'cleared'
    self.phone = ''
    self.username = ''
    set_default_username_if_blank!
    self.email = self.username + '@cleared.servethecity-karlsruhe.de'
    self.cleared = true
  end

  private

  def set_default_username_if_blank!  # not thread safe
    return unless username.blank?
    possible_usernames = [first_name, "#{first_name}#{last_name.first}", "#{first_name}#{last_name}"]
    possible_usernames.each { |new_name|
      unless username_exists_in_database? new_name
        self.username = new_name
        break
      end
    }
    max_num = 10 * User.count
    tries = 0
    while username.blank?
      new_name = "user#{rand(max_num)}"
      self.username = new_name unless username_exists_in_database? new_name
      tries += 1
      if tries > 1000
        logger.error "No username could be generated within #{tries} tries. Returning #{new_name}. First name: #{first_name}, last name: #{last_name}, max_num: #{max_num}"
        return new_name
      end
    end
  end

  def username_exists_in_database? username
    User.where('lower(username) = ?', username.downcase).count > 0 || !USERNAME_FORMAT.match(username)
  end

end
