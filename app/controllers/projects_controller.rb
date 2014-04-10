class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :enter, :leave, :edit_leaders, :add_leader, :delete_leader]
  before_action :authenticate_user!, only: [:edit, :update, :enter, :leave, :destroy, :new, :edit_leaders, :add_leader, :delete_leader]
  before_action :redirect_non_leaders, only: [:edit, :edit_leaders, :add_leader, :delete_leader, :destroy, :update]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: t('project.creation_successful') }
        format.json { render action: 'show', status: :created, location: @project }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: t('project.update_successful')}
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def enter
    @project.add_volunteer(current_user)
    redirect_to project_url(@project)
  end

  def leave
    @project.delete_volunteer(current_user)
    redirect_to project_url(@project)
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  def edit_leaders
  end

  def add_leader
    new_leader = User.find(params[:user_id])
    @project.add_leader(new_leader)
    redirect_to edit_leaders_project_url(@project), notice: t('project.leader.added')
  end

  def delete_leader
    leader = User.find(params[:user_id])
    @project.delete_leader(leader)
    redirect_to edit_leaders_project_url(@project), notice: t('project.leader.removed')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:title, :description, :location, :latitude, :longitude, :individual_tasks, :material, :requirements, :visible, :user_id)
    end

    def redirect_non_leaders
      unless current_user.leads_project?(@project)
        redirect_to @project
      end
    end
end
