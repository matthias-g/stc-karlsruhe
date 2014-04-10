# based on https://github.com/refinery/refinerycms/blob/master/authentication/app/models/refinery/role.rb

class Role < ActiveRecord::Base

  before_validation :camelize_title
  validates :title, :presence => true, :uniqueness =>  true

  private

    def camelize_title(role_title = self.title)
      self.title = role_title.to_s.camelize
    end
end
