class Refinery::Projects::Admin::TypesController < ::Refinery::AdminController

  crudify :'refinery/projects/type', :xhr_paging => true

end
