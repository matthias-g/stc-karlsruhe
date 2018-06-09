class OrgaMessagesController < ApplicationController
  before_action :authenticate_admin_or_coordinator!
  before_action :set_message, except: [:index, :new, :create]
  before_action :authorize_message, except: [:index, :new, :create]

  after_action :verify_authorized

  respond_to :html

  def index
    authorize OrgaMessage.new
    @messages = OrgaMessage.all.order(created_at: :desc)
  end

  def show
    if @message.newsletter?
      @subscription = Subscription.find_by_email(current_user.email)
    else
      @user = current_user
    end
  end

  def new
    @message = OrgaMessage.new
    authorize_message
  end

  def create
    @message = OrgaMessage.new(message_params)
    authorize_message
    @message.author = current_user
    if @message.valid?
      @message.save
    else
      flash[:alert] = @message.errors.full_messages
    end
    respond_with @message
  end

  def edit

  end

  def update
    if @message.update(message_params)
      flash[:notice] = t('orga_message.message.updated')
    else
      flash[:alert] = @message.errors.full_messages
    end
    respond_with @message
  end

  def destroy
    @message.destroy
    redirect_to orga_messages_path
  end

  def send_message
    if @message.sent?
      flash[:alert] = t('orga_message.message.message_already_sent')
      return redirect_to action: :show
    end
    if @message.valid?
      @message.send_message current_user
      flash[:notice] = t('orga_message.message.send_success')
      redirect_to action: :show
    else
      flash[:alert] = @message.errors.full_messages
      redirect_to action: :show
    end
  end

  private

  def set_message
    @message = OrgaMessage.find(params[:id])
  end

  def message_params
    params.require(:orga_message).permit(:from, :recipient, :action_group_id, :content_type, :subject, :body)
  end

  def authorize_message
    authorize @message
  end

end
