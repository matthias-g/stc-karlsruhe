class ProjectWeeksController < ApplicationController
  before_action :set_project_week, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin_user!

  respond_to :html

  def index
    @project_weeks = ProjectWeek.all
    respond_with(@project_weeks)
  end

  def show
    respond_with(@project_week)
  end

  def new
    @project_week = ProjectWeek.new
    respond_with(@project_week)
  end

  def edit
  end

  def create
    @project_week = ProjectWeek.new(project_week_params)
    @project_week.save
    respond_with(@project_week)
  end

  def update
    @project_week.update(project_week_params)
    respond_with(@project_week)
  end

  def destroy
    @project_week.destroy
    respond_with(@project_week)
  end

  private
    def set_project_week
      @project_week = ProjectWeek.find(params[:id])
    end

    def project_week_params
      params.require(:project_week).permit(:title, :default)
    end
end
