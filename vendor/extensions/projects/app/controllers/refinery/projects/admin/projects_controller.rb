module Refinery
  module Projects
    module Admin
      class ProjectsController < ::Refinery::AdminController

        crudify :'refinery/projects/project', :xhr_paging => true

        def publish
          @project = Project.find(params[:id])
          @project.publish
          redirect_to refinery.edit_projects_admin_project_path(@project)
        end

        def hide
          @project = Project.find(params[:id])
          @project.hide
          redirect_to refinery.edit_projects_admin_project_path(@project)
        end

      end
    end
  end
end
