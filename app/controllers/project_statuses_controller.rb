class ProjectStatusesController < ApplicationController
  before_action :set_project_status, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :check_admin

  # GET /project_statuses
  # GET /project_statuses.json
  def index
    @project_statuses = ProjectStatus.all
  end

  # GET /project_statuses/1
  # GET /project_statuses/1.json
  def show
  end

  # GET /project_statuses/new
  def new
    @project_status = ProjectStatus.new
  end

  # GET /project_statuses/1/edit
  def edit
  end

  # POST /project_statuses
  # POST /project_statuses.json
  def create
    @project_status = ProjectStatus.new(project_status_params)

    respond_to do |format|
      if @project_status.save
        format.html { redirect_to @project_status, notice: 'Project status was successfully created.' }
        format.json { render action: 'show', status: :created, location: @project_status }
      else
        format.html { render action: 'new' }
        format.json { render json: @project_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_statuses/1
  # PATCH/PUT /project_statuses/1.json
  def update
    respond_to do |format|
      if @project_status.update(project_status_params)
        format.html { redirect_to @project_status, notice: 'Project status was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_statuses/1
  # DELETE /project_statuses/1.json
  def destroy
    @project_status.destroy
    respond_to do |format|
      format.html { redirect_to project_statuses_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_status
      @project_status = ProjectStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_status_params
      params.require(:project_status).permit(:title, :display_class)
    end
end
