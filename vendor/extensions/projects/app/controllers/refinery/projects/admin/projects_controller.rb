module Refinery
  module Projects
    module Admin
      class ProjectsController < ::Refinery::AdminController

        crudify :'refinery/projects/project', :xhr_paging => true

        def publish
          @project = Project.find(params[:id])
          @project.publish
          redirect_to refinery.projects_admin_projects_path
        end

        def hide
          @project = Project.find(params[:id])
          @project.hide
          redirect_to refinery.projects_admin_projects_path
        end

      end
    end
  end
end
