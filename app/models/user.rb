class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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

end
