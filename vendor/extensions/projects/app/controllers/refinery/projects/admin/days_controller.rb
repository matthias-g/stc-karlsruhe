class Refinery::Projects::Admin::DaysController < ::Refinery::AdminController

  crudify :'refinery/projects/day', :xhr_paging => true

end
