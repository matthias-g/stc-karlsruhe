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
    return unless params[:filter]
    p = filter_params
    @actions = @actions.where(visible: (p[:visibility] != 'hidden')) unless p[:visibility].blank?
    @actions = @actions.where(date: Date.parse(p[:day])) unless p[:day].blank?
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
    @action.action_group = ActionGroup.all.order(start_date: :desc).first
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
    respond_with(@action.action_group)
  end

  def delete_leader
    leader = User.find(params[:user_id])
    @action.delete_leader(leader)
    redirect_to @action, notice: t('action.message.leaderRemoved')
  end

  def make_visible
    @action.make_visible!
    if @action.subactions
      @action.subactions.each { |action| action.make_visible! }
    end
    redirect_to @action, notice: t('action.message.madeVisible')
  end

  def make_invisible
    @action.make_invisible!
    if @action.subactions
      @action.subactions.each { |action| action.make_invisible! }
    end
    redirect_to @action, notice: t('action.message.madeInvisible')
  end

  def crop_picture
    if params.has_key?(:crop_x)
      @action.crop_picture(params[:crop_x].to_i, params[:crop_y].to_i,
                           params[:crop_w].to_i, params[:crop_h].to_i,
                           params[:crop_target].to_sym)
      redirect_to @action, notice: t('action.message.imageCropped')
    else
      @crop_target_symbol = params[:crop_target].to_sym
      case @crop_target_symbol
      when :action_list
        @crop_target_title = t('action.heading.cropTarget.action_list')
        @crop_target_ratio = 200.0/165
      when :action_view
        @crop_target_title = t('action.heading.cropTarget.action_view')
        @crop_target_ratio = 522.0/261
      when :thumbnail
        @crop_target_title = t('action.heading.cropTarget.thumbnail')
        @crop_target_ratio = 100.0/100
      end
      respond_with @action do |format|
        format.html { render :layout => false}
      end
    end
  end

  def contact_leaders
    @message = Message.new(params[:message])
    Mailer.action_mail_to_leaders(@message, current_user, @action).deliver_now
    flash[:notice] = t('mailer.action_mail_to_leaders.success')
    redirect_to action: :show
  end

  def contact_volunteers
    @message = Message.new(params[:message])
    Mailer.action_mail(@message, current_user, @action).deliver_now
    flash[:notice] = t('mailer.action_mail.success')
    redirect_to action: :show
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_action
    @action = Action.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def action_params
    params.require(:the_action).permit(:title, :user_id,
                                       :location, :latitude, :longitude, :map_latitude, :map_longitude, :map_zoom,
                                       :description, :short_description, :individual_tasks, :material, :requirements,
                                       :picture, :picture_source,  :action_group_id, :parent_action_id,
                                       events_attributes: [:id, :desired_team_size, :date, :time, :_destroy])
  end

  def authorize_action
    authorize @action
  end

  def filter_params
    params.require(:filter).permit(:visibility, :date)
  end

end
