class Refinery::Projects::Admin::SetorsController < ::Refinery::AdminController

  crudify :'refinery/projects/sector', :xhr_paging => true

end
