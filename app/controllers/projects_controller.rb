class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :enter, :leave, :edit_leaders, :add_leader, :delete_leader, :make_visible, :make_invisible, :contact_volunteers, :delete_volunteer, :open, :close]
  before_action :authenticate_user!, only: [:edit, :update, :enter, :leave, :destroy, :new, :edit_leaders, :add_leader, :delete_leader, :open, :close]
  before_action :authenticate_admin_user!, only: [:make_visible, :make_invisible, :delete_volunteer]
  before_action :redirect_non_leaders, only: [:edit, :edit_leaders, :add_leader, :delete_leader, :destroy, :update, :open, :close]
  before_action :check_visible, only: [:show, :edit, :update, :enter, :leave, :edit_leaders, :add_leader, :delete_leader, :destroy]

  respond_to :html

  def index
    visible = true
    if params[:filter] and params[:filter][:visibility] == 'hidden' and current_user.is_admin?
        visible = false
    end
    @projects = Project.where(:visible => visible).order(:status)
    @projects &= ProjectDay.find(params[:filter][:day]).projects if params[:filter] and params[:filter][:day] != ''
    @projects &= Project.where(:status => Project.statuses[params[:filter][:status]]) if params[:filter] and params[:filter][:status] != ''
    respond_with(@projects)
  end

  def show
    #Message for contact_volunteers
    @message = Message.new
    respond_with(@project)
  end

  def new
    @project = Project.new
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
    @project.update(project_params)
    respond_with(@project)
  end

  def enter
    if @project.full? or @project.closed?
      redirect_to project_url(@project), :notice => 'Dieses Projekt ist schon vollbesetzt.'
      return
    end
    @project.add_volunteer(current_user)
    redirect_to project_url(@project), :notice => 'Du nimmst jetzt an diesem Projekt teil. Der Teamleiter wird sich mit Dir in Verbindung setzen.'
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
    redirect_to @project, notice: 'Projekt wurde sichtbar gemacht.'
  end

  def make_invisible
    @project.make_invisible!
    redirect_to @project, notice: 'Projekt wurde unsichtbar gemacht.'
  end

  def open
    @project.open!
    redirect_to @project, notice: 'Projekt wurde geöffnet.'
  end

  def close
    @project.close!
    redirect_to @project, notice: 'Projekt wurde geschlossen.'
  end

  def contact_volunteers
    @message = Message.new(params[:message])
    @message.sender = current_user.email
    @message.recipient = @project.volunteers.map { |v| v.email}.join(',') + ',' + current_user.email
    if @message.valid?
      Mailer.multi_user_bcc_mail(@message, current_user.full_name, @project.title).deliver
      flash[:notice] = t('contact.volunteers.success')
      redirect_to action: :show
    else
      flash[:alert] = @message.errors.values
      render action: :show
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:title, :user_id, :status,
        :location, :latitude, :longitude, :map_latitude, :map_longitude, :map_zoom,
        :description, :short_description, :individual_tasks, :material, :requirements,
        :picture, :picture_source, :desired_team_size,  { :day_ids => [] }, :time)
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

    def send_notice_mail(title, leader)
      message = Message.new(:sender => 'no-reply@servethecity-karlsruhe.de', :subject => 'Ein neues Projekt wurde erstellt',
                            :body => "Hallo,

soeben wurde ein neues Projekt für Serve the City erstellt.

Projekttitel: #{title}
Leiter: #{leader}")
      Mailer.contact_mail(message).deliver
    end

end
