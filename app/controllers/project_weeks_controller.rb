class ProjectWeeksController < ApplicationController
  before_action :set_project_week, except: [:index, :new, :create]
  before_action :authenticate_admin!, except: [:show]
  before_action :authorize_project_week, except: [:index, :new, :create]

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  respond_to :html

  def index
    @project_weeks = policy_scope(ProjectWeek)
  end

  def show
    @projects = @project_week.projects.toplevel.order(visible: :desc, status: :asc, picture_source: :desc)

    if params[:filter]
      p = filter_params
      @projects = @projects.where(visible: (p[:visibility] != 'hidden')) unless p[:visibility].blank?
      @projects = @projects.merge(ProjectDay.find(p[:day]).projects) unless p[:day].blank?
      @projects = @projects.where(status: Project.statuses[p[:status]]) unless p[:status].blank?
    end

    @projects = policy_scope(@projects)
  end

  def new
    @project_week = ProjectWeek.new
    authorize_project_week
  end

  def edit
  end

  def create
    @project_week = ProjectWeek.new(project_week_params)
    authorize_project_week
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
    @project_week = params[:title] ? ProjectWeek.find_by_title(params[:title]) : ProjectWeek.find(params[:id])
    not_found unless @project_week
  end

  def project_week_params
    params.require(:project_week).permit(:title, :default)
  end

  def filter_params
    params.require(:filter).permit(:visibility, :day, :status)
  end

  def authorize_project_week
    authorize @project_week
  end
end
