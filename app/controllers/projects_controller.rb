class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :enter, :leave, :edit_leaders, :add_leader, :delete_leader, :make_visible, :make_invisible, :contact_volunteers, :delete_volunteer, :open, :close]
  before_action :authenticate_user!, only: [:edit, :update, :enter, :leave, :destroy, :new, :edit_leaders, :add_leader, :delete_leader, :open, :close]
  before_action :authenticate_admin_user!, only: [:index, :make_visible, :make_invisible, :delete_volunteer]
  before_action :redirect_non_leaders, only: [:edit, :edit_leaders, :add_leader, :delete_leader, :destroy, :update, :open, :close]
  before_action :check_visible, only: [:show, :edit, :update, :enter, :leave, :edit_leaders, :add_leader, :delete_leader, :destroy]

  respond_to :html

  def index
    visible = true
    if params[:filter] && (params[:filter][:visibility] == 'hidden') && current_user.is_admin?
        visible = false
    end
    @projects = Project.visible.order(:status)
    @projects &= ProjectDay.find(params[:filter][:day]).projects if params[:filter] && (params[:filter][:day] != '')
    @projects &= Project.where(:status => Project.statuses[params[:filter][:status]]) if params[:filter] && (params[:filter][:status] != '')
    respond_with(@projects)
  end

  def show
    #Message for contact_volunteers
    @message = Message.new
    if @project.gallery.gallery_pictures.count == 0
      @project.gallery.gallery_pictures.build
    end
    respond_with(@project)
  end

  def new
    @project = Project.new
    @project.project_week = ProjectWeek.all.order(title: :desc).first
    respond_with(@project)
  end

  def edit
    respond_with(@project)
  end

  def create
    @project = Project.new(project_params)
    @project.add_leader(current_user)
    @project.visible = false
    @project.save
    respond_with(@project)
  end

  def update
    if @project.update(project_params)
      flash[:notice] = t('project.message.updated')
    end
    respond_with(@project)
  end

  def enter
    if @project.full? or @project.closed?
      redirect_to project_url(@project), :notice => t('project.message.isFull')
      return
    end
    @project.add_volunteer(current_user)
    redirect_to project_url(@project), :notice => t('project.message.participationSuccess')
  end

  def leave
    @project.delete_volunteer(current_user)
    redirect_to project_url(@project)
  end

  def destroy
    @project.destroy
    respond_with(@project)
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

  def delete_volunteer
    volunteer = User.find(params[:user_id])
    @project.delete_volunteer(volunteer)
    redirect_to edit_leaders_project_url(@project), notice: t('project.message.volunteerRemoved')
  end

  def make_visible
    @project.make_visible!
    redirect_to @project, notice: t('project.message.madeVisible')
  end

  def make_invisible
    @project.make_invisible!
    redirect_to @project, notice: t('project.message.madeInvisible')
  end

  def open
    @project.open!
    redirect_to @project, notice: t('project.message.opened')
  end

  def close
    @project.close!
    redirect_to @project, notice: t('project.message.closed')
  end

  def contact_volunteers
    # TODO: make it work with just one email:
    #@message = Message.new(params[:message])
    #Mailer.project_mail(@message, current_user, @project).deliver

    recipients = (@project.aggregated_volunteers + @project.aggregated_leaders).uniq
    recipients.each do |r|
      @message = Message.new(params[:message])
      @message.sender = current_user.email
      @message.recipient = r.email
      Mailer.generic_mail(@message, true).deliver
    end

    flash[:notice] = t('contact.team.success')
    redirect_to action: :show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:title, :user_id, :status,
        :location, :latitude, :longitude, :map_latitude, :map_longitude, :map_zoom,
        :description, :short_description, :individual_tasks, :material, :requirements,
        :picture, :picture_source, :desired_team_size,  :project_week_id, { :day_ids => [] }, :time, :parent_project_id)
    end

    def redirect_non_leaders
      unless current_user.leads_project?(@project) or current_user.is_admin?
        redirect_to @project
      end
    end

    def check_visible
      unless @project.visible or (user_signed_in? and current_user.is_admin?) or (user_signed_in? and current_user.leads_project?(@project))
        if user_signed_in?
          redirect_to projects_path
        else
          redirect_to new_user_session_path
        end
      end
    end

end
