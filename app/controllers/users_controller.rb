class UsersController < ApplicationController
  before_action :set_user, only: [:show, :contact_user, :edit, :update, :confirm_delete, :destroy]
  before_action :authenticate_user!, except: [:login_or_register]
  before_action :authenticate_admin_user!, only: [:index]
  before_action :own_user_or_authenticate_admin_user!, only: [:edit, :update, :destroy]

  respond_to :html

  def index
    @users = User.all
    respond_with(@user)
  end

  def show
    if @user.cleared && !current_user.is_admin?
      not_found
    end
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

  def confirm_delete
    respond_with(@user)
  end

  def destroy
    if @user.valid_password?(params[:confirm_delete_password]) || current_user.is_admin?
      @user.clear!
      @user.save!
      sign_out
      redirect_to root_path, notice: t('user.message.accountDeleted')
    else
      redirect_to action: :confirm_delete, alert: t('user.message.invalidPassword')
    end
  end

  def contact_user
    @message = Message.new(params[:message])
    @message.sender = current_user.email
    @message.recipient = @user.email
    if @message.valid?
      Mailer.single_user_mail(@message, current_user.first_name, @user.first_name).deliver
      redirect_to action: :show, notice: t('contact.user.success', recipient: @user.full_name)
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
