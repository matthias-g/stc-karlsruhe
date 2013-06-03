module Refinery
  module Projects
    module Admin
      module ProjectsHelper
        def usernames
          User.all.collect{|u| u.username }
        end
      end
    end
  end
end