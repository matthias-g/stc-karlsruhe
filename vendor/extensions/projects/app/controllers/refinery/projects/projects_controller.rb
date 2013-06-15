module Refinery
  module Projects
    class ProjectsController < ::ApplicationController

      before_filter :find_all_projects
      before_filter :find_page
      before_filter :authenticate_refinery_user!, :only => [:enter, :edit, :update]

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @project in the line below:
        @projects = Project.all
        @projects &= Type.find(params[:type]).collect{|t| t.projects}.flatten if params[:type]
        @projects &= Sector.find(params[:sector]).collect{|s| s.projects}.flatten if params[:sector]
        @projects &= VolunteerType.find(params[:volunteer_type]).collect{|vt| vt.projects}.flatten if params[:volunteer_type]
        @projects &= Location.find(params[:location]).collect{|l| l.projects}.flatten if params[:location]
        @projects &= Day.find(params[:day]).collect{|d| d.projects}.flatten if params[:day]
        present(@page)
        render(:layout => 'project_explorer')
      end

      def show
        @project = Project.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @project in the line below:
        present(@page)
      end

      def edit
        @project = Project.find(params[:id])
        unless current_refinery_user.leads_project?(@project)
          redirect_to refinery.projects_project_path(@project)
        end
      end

      def update
        @project = Project.find(params[:id])
        unless current_refinery_user.leads_project?(@project)
          # TODO flash error message
          redirect_to refinery.projects_project_path(@project)
          return
        end
        if @project.update_attributes(params[:project])
          redirect_to refinery.projects_project_path(@project)
        else
          render(:action => :edit)
        end
      end

      def enter
        @project = Project.find(params[:id])
        @project.add_volunteer(current_refinery_user) if current_refinery_user.has_role?(:volunteer)
        redirect_to refinery.projects_project_url(@project)
      end

      def leave
        @project = Project.find(params[:id])
        @project.delete_volunteer(current_refinery_user)
        redirect_to refinery.projects_project_url(@project)
      end

    protected

      def find_all_projects
        @projects = Project.order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/projects").first
      end

    end
  end
end
