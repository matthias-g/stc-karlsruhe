class ProjectsController < ApplicationController
  before_action :set_project, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:show]
  before_action :authorize_project, except: [:index, :new, :create, :delete_volunteer]

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  respond_to :html

  def index
    authorize Project.new
    @projects = policy_scope(Project.all).order(:status)
    if params[:filter]
      p = filter_params
      @projects = @projects.where(visible: (p[:visibility] != 'hidden')) unless p[:visibility].blank?
      @projects = @projects.merge(ProjectDay.find(p[:day]).projects) unless p[:day].blank?
      @projects = @projects.where(status: Project.statuses[p[:status]]) unless p[:status].blank?
    end
    @projects = policy_scope(@projects)
  end

  def show
    #Message for contact_volunteers or contact_leaders
    @message = Message.new
    if @project.gallery.gallery_pictures.count == 0
      @project.gallery.gallery_pictures.build
    end
  end

  def new
    @project = Project.new
    authorize_project
    @project.project_week = ProjectWeek.all.order(title: :desc).first
  end

  def edit
  end

  def create
    @project = Project.new(project_params)
    authorize_project
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
    @project.add_volunteer(current_user)
    redirect_to project_url(@project), notice: t('project.message.participationSuccess')
  end

  def leave
    @project.delete_volunteer(current_user)
    redirect_to project_url(@project)
  end

  def destroy
    @project.destroy
    respond_with(@project.project_week)
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
    authorize_delete_volunteer(volunteer)
    @project.delete_volunteer(volunteer)
    redirect_to edit_leaders_project_url(@project), notice: t('project.message.volunteerRemoved')
  end

  def make_visible
    @project.make_visible!
    if @project.subprojects
      @project.subprojects.each { |project| project.make_visible! }
    end
    redirect_to @project, notice: t('project.message.madeVisible')
  end

  def make_invisible
    @project.make_invisible!
    if @project.subprojects
      @project.subprojects.each { |project| project.make_invisible! }
    end
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

  def crop_picture
    if params.has_key?(:crop_x)
      @project.crop_picture(params[:crop_x].to_i, params[:crop_y].to_i,
                            params[:crop_w].to_i, params[:crop_h].to_i,
                            params[:crop_target].to_sym)
      redirect_to @project, notice: t('project.message.imageCropped')
    else
      @crop_target_symbol = params[:crop_target].to_sym
      case @crop_target_symbol
        when :project_list
          @crop_target_title = t('project.label.listviewImage')
          @crop_target_ratio = 200.0/165
        when :project_view
          @crop_target_title = t('project.label.projectImage')
          @crop_target_ratio = 522.0/261
        when :thumbnail
          @crop_target_title = t('project.label.thumbnailImage')
          @crop_target_ratio = 100.0/100
      end
      respond_with @project do |format|
        format.html { render :layout => false}
      end
    end
  end

  def contact_leaders
    @message = Message.new(params[:message])
    Mailer.project_mail_to_leaders(@message, current_user, @project).deliver_now
    flash[:notice] = t('contact.leaders.success')
    redirect_to action: :show
  end

  def contact_volunteers
    @message = Message.new(params[:message])
    Mailer.project_mail(@message, current_user, @project).deliver_now
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

  def authorize_project
    authorize @project
  end

  def authorize_delete_volunteer(volunteer)
    unless policy(@project).allow_remove_volunteer_from_project?(volunteer, @project)
      raise Pundit::NotAuthorizedError, "not allowed to delete #{volunteer.full_name} from #{@project.title}"
    end
    skip_authorization
  end

  def filter_params
    params.require(:filter).permit(:visibility, :day, :status)
  end

end
