class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :enter, :leave, :edit_leaders, :add_leader, :delete_leader, :make_visible, :make_invisible]
  before_action :authenticate_user!, only: [:edit, :update, :enter, :leave, :destroy, :new, :edit_leaders, :add_leader, :delete_leader, :make_visible, :make_invisible]
  before_action :redirect_non_leaders, only: [:edit, :edit_leaders, :add_leader, :delete_leader, :destroy, :update]
  before_action :check_admin, only: [:make_visible, :make_invisible]
  before_action :check_visible, only: [:show, :edit, :update, :enter, :leave, :edit_leaders, :add_leader, :delete_leader, :destroy]

  # GET /projects
  # GET /projects.json
  #/projects?utf8=%E2%9C%93&filter[day]=1&filter[status]=open&filter[visibility]=visible&commit=Filter
  def index
    visible = true
    if params[:filter] and params[:filter][:visibility] == 'hidden' and current_user.is_admin?
        visible = false
    end
    @projects = Project.where(:visible => visible)
    @projects &= ProjectDay.find(params[:filter][:day]).projects if params[:filter] and params[:filter][:day]
    @projects &= Project.where(:status => Project.statuses[params[:filter][:status]]) if params[:filter] and params[:filter][:status]
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
    @project.add_leader(current_user)
    @project.adjust_status!
    @project.visible = false

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: t('project.message.created') }
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
        @project.adjust_status!
        format.html { redirect_to @project, notice: t('project.message.updated')}
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def enter
    if @project.full? or @project.closed?
      redirect_to project_url(@project), :notice => 'Dieses Projekt ist schon vollbesetzt.'
      return
    end
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
    redirect_to edit_leaders_project_url(@project), notice: t('project.message.leaderAdded')
  end

  def delete_leader
    leader = User.find(params[:user_id])
    @project.delete_leader(leader)
    redirect_to edit_leaders_project_url(@project), notice: t('project.message.leaderRemoved')
  end

  def make_visible
    @project.make_visible!
    redirect_to @project, notice: 'Projekt wurde sichtbar gemacht.'
  end

  def make_invisible
    @project.make_invisible!
    redirect_to @project, notice: 'Projekt wurde unsichtbar gemacht.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:title, :description, :short_description, :location, :latitude, :longitude, :individual_tasks, :material, :requirements,
                                      :user_id, :picture, :desired_team_size, :status, { :day_ids => [] }, :time)
    end

    def redirect_non_leaders
      unless current_user.leads_project?(@project) or current_user.is_admin?
        redirect_to @project
      end
    end

    def check_visible
      unless @project.visible or (user_signed_in? and current_user.is_admin?)
        redirect_to projects_path
      end
    end
end
