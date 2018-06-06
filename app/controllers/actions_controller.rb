class ActionsController < ApplicationController

  before_action :set_action, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:show]
  before_action :authorize_action, except: [:index, :new, :create, :delete_volunteer]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  respond_to :html

  def index
    authorize Action.new
    @actions = policy_scope(Action.toplevel).order(visible: :desc, picture_source: :desc)
    if params.key?(:filter) && params[:filter].key?(:day)
      @actions = @actions.where(date: Date.parse(filter_params[:day]))
    end
  end

  def show
    # Message for contact_volunteers or contact_leaders
    @message = Message.new
    pics = @action.gallery.gallery_pictures
    pics.build if pics.any?
  end

  def new
    @action = Action.new
    @action.events.build
    authorize_action
  end

  def clone
    redirect_to edit_action_path(@action.clone)
  end

  def edit; end

  def create
    @action = Action.new(action_params)
    authorize_action
    @action.add_leader(current_user)
    @action.visible = false
    @action.events.each {|event| event.initiative = @action}
    @action.save
    respond_with(@action)
  end

  def update
    if @action.update(action_params)
      flash[:notice] = t('action.message.updated')
    end
    respond_with(@action)
  end

  def destroy
    @action.destroy
    respond_with @action.action_group
  end

  def delete_leader
    @action.delete_leader User.find(params[:user_id])
    redirect_to @action, notice: t('action.message.leaderRemoved')
  end

  def make_visible
    @action.make_visible!
    redirect_to @action, notice: t('action.message.madeVisible')
  end

  def make_invisible
    @action.make_invisible!
    redirect_to @action, notice: t('action.message.madeInvisible')
  end

  def crop_picture
    @action.crop_picture(params[:crop_x].to_f, params[:crop_y].to_f,
                         params[:crop_w].to_f, params[:crop_h].to_f,
                         params[:crop_target].to_sym)
    redirect_to @action, notice: t('action.message.imageCropped')
  end

  def crop_picture_modal
    @crop_target_symbol = params[:crop_target].to_sym
    case @crop_target_symbol
    when :thumb
      @crop_target_title = t('action.heading.cropTarget.thumb')
      @crop_target_ratio = 75.0/60
    when :card
      @crop_target_title = t('action.heading.cropTarget.card')
      @crop_target_ratio = 318.0/220
    when :large
      @crop_target_title = t('action.heading.cropTarget.large')
      @crop_target_ratio = 775.0/350
    end
    respond_with @action do |format|
      format.html { render layout: false }
    end
  end

  def contact_leaders
    @message = Message.new(params[:message])
    recipients = @action.leaders + [current_user]
    recipients.uniq.each do |recipient|
      Mailer.contact_leaders_mail(@message.body, @message.subject,
                                  current_user, recipient, @action).deliver_later
    end
    redirect_to @action, notice: t('mailer.contact_leaders_mail.success')
  end

  def contact_volunteers
    @message = Message.new(params[:message])
    recipients = @action.volunteers + @action.leaders + [current_user]
    if @message.recipient_scope == 'action_and_subactions'
      recipients += @action.volunteers_in_subactions + @action.leaders_in_subactions
    end
    recipients.uniq.each do |recipient|
      Mailer.contact_volunteers_mail(@message.body, @message.subject,
                                     current_user, recipient, @action).deliver_later
    end
    redirect_to @action, notice: t('mailer.contact_volunteers_mail.success')
  end

  
  private

  def set_action
    @action = Action.friendly.find(params[:id])
  end

  def authorize_action
    authorize @action
  end

  def action_params
    params.require(:the_action).permit(:title, :user_id,
       :location, :latitude, :longitude, :map_latitude, :map_longitude, :map_zoom,
       :description, :short_description, :individual_tasks, :material, :requirements,
       :picture, :picture_source,  :action_group_id, :parent_action_id,
       events_attributes: [:id, :desired_team_size, :date, :time, :_destroy])
  end

  def filter_params
    params.require(:filter).permit(:date)
  end

end
