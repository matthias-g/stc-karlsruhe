class ProjectDaysController < ApplicationController
  before_action :set_project_day, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin_user!

  # GET /project_days
  # GET /project_days.json
  def index
    @project_days = ProjectDay.all
  end

  # GET /project_days/1
  # GET /project_days/1.json
  def show
  end

  # GET /project_days/new
  def new
    @project_day = ProjectDay.new
    @project_day.project_week = ProjectWeek.default
  end

  # GET /project_days/1/edit
  def edit
  end

  # POST /project_days
  # POST /project_days.json
  def create
    @project_day = ProjectDay.new(project_day_params)

    respond_to do |format|
      if @project_day.save
        format.html { redirect_to @project_day, notice: 'Project day was successfully created.' }
        format.json { render action: 'show', status: :created, location: @project_day }
      else
        format.html { render action: 'new' }
        format.json { render json: @project_day.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_days/1
  # PATCH/PUT /project_days/1.json
  def update
    respond_to do |format|
      if @project_day.update(project_day_params)
        format.html { redirect_to @project_day, notice: 'Project day was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project_day.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_days/1
  # DELETE /project_days/1.json
  def destroy
    @project_day.destroy
    respond_to do |format|
      format.html { redirect_to project_days_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_day
      @project_day = ProjectDay.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_day_params
      params.require(:project_day).permit(:title, :date, :project_week_id)
    end
end
