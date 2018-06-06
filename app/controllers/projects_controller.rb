class ProjectsController < ApplicationController

  before_action :set_project, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:show]
  before_action :authorize_project, except: [:index, :new, :create, :delete_volunteer]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  respond_to :html

  def index
    @projects = policy_scope(Project.all)
  end

  def show
    # Message for contact_volunteers or contact_leaders
    @message = Message.new
    pics = @project.gallery.gallery_pictures
    pics.build if pics.any?
  end

  def new
    @project = Project.new
    @project.events.build
    authorize_project
  end

  def edit; end

  def create
    @project = Project.new(project_params)
    authorize_project
    @project.add_leader(current_user)
    @project.visible = false
    @project.events.each {|event| event.initiative = @project}
    @project.save
    respond_with(@project)
  end

  def update
    if @project.update(project_params)
      flash[:notice] = t('project.message.updated')
    end
    respond_with(@project)
  end

  def destroy
    @project.destroy
    respond_with :root
  end

  def delete_leader
    @project.delete_leader User.find(params[:user_id])
    redirect_to @project, notice: t('project.message.leaderRemoved')
  end

  def make_visible
    @project.make_visible!
    redirect_to @project, notice: t('project.message.madeVisible')
  end

  def make_invisible
    @project.make_invisible!
    redirect_to @project, notice: t('project.message.madeInvisible')
  end

  def crop_picture
    @project.crop_picture(params[:crop_x].to_f, params[:crop_y].to_f,
                         params[:crop_w].to_f, params[:crop_h].to_f,
                         params[:crop_target].to_sym)
    redirect_to @project, notice: t('project.message.imageCropped')
  end

  def crop_picture_modal
    @crop_target_symbol = params[:crop_target].to_sym
    case @crop_target_symbol
    when :thumb
      @crop_target_title = t('project.heading.cropTarget.thumb')
      @crop_target_ratio = 75.0/60
    when :card
      @crop_target_title = t('project.heading.cropTarget.card')
      @crop_target_ratio = 318.0/220
    when :large
      @crop_target_title = t('project.heading.cropTarget.large')
      @crop_target_ratio = 775.0/350
    end
    respond_with @project do |format|
      format.html { render layout: false }
    end
  end

  def contact_leaders
    @message = Message.new(params[:message])
    recipients = @project.leaders + [current_user]
    recipients.uniq.each do |recipient|
      Mailer.contact_leaders_mail(@message.body, @message.subject,
                                  current_user, recipient, @project).deliver_later
    end
    redirect_to @project, notice: t('mailer.contact_leaders_mail.success')
  end

  def contact_volunteers
    @message = Message.new(params[:message])
    recipients = @project.volunteers + @project.leaders + [current_user]
    recipients.uniq.each do |recipient|
      Mailer.contact_volunteers_mail(@message.body, @message.subject,
                                     current_user, recipient, @project).deliver_later
    end
    redirect_to @project, notice: t('mailer.contact_volunteers_mail.success')
  end

  private

  def set_project
    @project = Project.friendly.find(params[:id])
  end

  def authorize_project
    authorize @project
  end

  def project_params
    params.require(:the_project).permit(:title, :user_id,
       :location, :latitude, :longitude, :map_latitude, :map_longitude, :map_zoom,
       :description, :short_description, :individual_tasks, :material, :requirements,
       :picture, :picture_source, :icon,
       events_attributes: [:id, :desired_team_size, :date, :time, :_destroy])
  end

end
