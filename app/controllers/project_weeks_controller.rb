class ProjectWeeksController < ApplicationController
  before_action :set_project_week, only: [:edit, :update, :destroy]
  before_action :authenticate_admin_user!, except: [:show]

  respond_to :html

  def index
    @project_weeks = ProjectWeek.all
  end

  def show
    @project_week = !params[:title] ? set_project_week : ProjectWeek.find_by_title(params[:title])
    @projects = @project_week.projects.toplevel.order(status: :asc, picture_source: :desc)
    if params[:filter]
      p = filter_params # TODO: multiple day selection
      @projects = @projects.where(status: Project.statuses[p[:status]]) if p[:status].present?
      @projects = @projects.joins(:days).where(project_days: {id: [p[:day]]}).distinct if p[:day].present?
    end
    @projects = policy_scope(@projects)
  end

  def new
    @project_week = ProjectWeek.new
  end

  def edit
  end

  def create
    @project_week = ProjectWeek.new(project_week_params)
    @project_week.save
    respond_with @project_week
  end

  def update
    @project_week.update(project_week_params)
    respond_with @project_week
  end

  def destroy
    @project_week.destroy
    respond_with @project_week
  end

  private
    def set_project_week
      @project_week = ProjectWeek.find(params[:id])
    end

    def project_week_params
      params.require(:project_week).permit(:title, :default)
    end

    def filter_params
      params.require(:filter).permit(:visibility, :day, :status)
    end
end
