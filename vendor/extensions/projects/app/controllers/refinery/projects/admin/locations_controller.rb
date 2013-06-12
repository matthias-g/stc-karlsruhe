class Refinery::Projects::Admin::LocationsController < ::Refinery::AdminController

  crudify :'refinery/projects/location', :xhr_paging => true

end
