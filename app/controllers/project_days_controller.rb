class ProjectDaysController < ApplicationController
  before_action :set_project_day, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin_user!

  respond_to :html

  def index
    @project_days = ProjectDay.all
    respond_with(@project_days)
  end

  def show
    respond_with(@project_day)
  end

  def new
    @project_day = ProjectDay.new
    respond_with(@project_day)
  end

  def edit
    respond_with(@project_day)
  end

  def create
    @project_day = ProjectDay.new(project_day_params)
    @project_day.save
    respond_with(@project_day)
  end

  def update
    @project_day.update(project_day_params)
    respond_with(@project_day)
  end

  def destroy
    @project_day.destroy
    respond_with(@project_day)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_day
      @project_day = ProjectDay.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_day_params
      params.require(:project_day).permit(:title)
    end
end
