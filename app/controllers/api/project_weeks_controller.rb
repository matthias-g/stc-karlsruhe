class Api::ProjectWeeksController < ApplicationController
  before_action :set_project_week, only: [:projects]

  respond_to :json

  def index
    project_weeks = ProjectWeek.all
    respond_with(project_weeks.to_json(only: :title))
  end

  def projects
    projects = @project_week.projects.where(visible: true)
    respond_with(projects.to_json(only: [:id, :title, :description, :short_description]))
  end

  private
    def set_project_week
      @project_week = ProjectWeek.find_by_title(params[:id])
      @project_week = ProjectWeek.find(params[:id]) unless @project_week
    end

end
