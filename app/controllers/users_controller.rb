class UsersController < ApplicationController
  before_action :set_user, only: [:show, :contact_user, :edit, :update]
  before_action :authenticate_user!, except: [:login_or_register]
  before_action :authenticate_admin_user!, only: [:index]
  before_action :own_user_or_authenticate_admin_user!, only: [:edit, :update]

  respond_to :html

  def index
    @users = User.all
    respond_with(@user)
  end

  def show
    #Message for contact_user
    @message = Message.new
    respond_with(@user)
  end

  def edit
    respond_with(@user)
  end

  def update
    @user.update(user_params)
    respond_with(@user)
  end

  def contact_user
    @message = Message.new(params[:messages])
    @message.sender = current_user.email
    @message.recipient = @user.email
    if @message.valid?
      Mailer.single_user_mail(@message, current_user.first_name, @user.first_name).deliver
      flash[:notice] = t('contact.user.success', recipient: @user.full_name)
      redirect_to action: :show
    else
      flash[:alert] = @message.errors.values
      render action: :show
    end
  end

  def login_or_register
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :first_name, :last_name, :email, :phone)
    end

    def own_user_or_authenticate_admin_user!
      unless @user == current_user
        authenticate_admin_user!
      end
    end

end
