class Refinery::Projects::Admin::SectorsController < ::Refinery::AdminController

  crudify :'refinery/projects/sector', :xhr_paging => true

end
