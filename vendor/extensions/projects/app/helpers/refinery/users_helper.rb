module Refinery
  module UsersHelper
    def refinery_users_exist?
      Refinery::Role[:refinery].users.any?
    end
  end
end