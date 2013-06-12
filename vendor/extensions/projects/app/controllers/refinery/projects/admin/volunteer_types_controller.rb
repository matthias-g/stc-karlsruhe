class Refinery::Projects::Admin::VolunteerTypesController < ::Refinery::AdminController

  crudify :'refinery/projects/volunteer_type', :xhr_paging => true

end
