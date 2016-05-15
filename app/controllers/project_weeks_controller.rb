class ProjectWeeksController < ApplicationController
  before_action :set_project_week, only: [:edit, :update, :destroy]
  before_action :authenticate_admin_user!, except: [:show]

  respond_to :html

  def index
    @project_weeks = ProjectWeek.all
  end

  def show
    @project_week = !params[:title] ? set_project_week : ProjectWeek.find_by_title(params[:title])
    @projects = @project_week.projects.toplevel.order(visible: :desc, status: :asc, picture_source: :desc)

    if params[:filter]
      p = filter_params
      @projects = @projects.where(visible: (p[:visibility] == 'visible')) if (p[:visibility] != '')
      @projects = @projects.in(ProjectDay.find(p[:day]).projects) if (p[:day] != '')
      @projects = @projects.where(status: Project.statuses[p[:status]]) if (p[:status] != '')
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
  end

  def update
    @project_week.update(project_week_params)
  end

  def destroy
    @project_week.destroy
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
