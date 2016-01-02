class ProjectsController < ApplicationController
  before_action :set_project, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:show]
  before_action :authorize_project, except: [:index, :new, :create]

  after_action :verify_authorized , except: [:new, :create]

  respond_to :html

  def index
    authorize Project.new
    visible = true
    if params[:filter] && (params[:filter][:visibility] == 'hidden') && current_user.is_admin?
        visible = false
    end
    @projects = Project.where(visible: visible).order(:status)
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
    @project.add_volunteer(current_user)
    redirect_to project_url(@project), notice: t('project.message.participationSuccess')
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

  def contact_volunteers
    @message = Message.new(params[:message])
    Mailer.project_mail(@message, current_user, @project).deliver_later
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

end
