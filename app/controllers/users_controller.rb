class UsersController < ApplicationController
  before_action :set_user, only: [:show, :contact_user]
  before_action :authenticate_user!
  before_action :check_admin, only: [:index]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    #Message for contac_user
    @message = Message.new
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(current_user.id)
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to action: :show, notice: t('user.message.profileUpdated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def contact_user
    @message = Message.new(params[:message])
    @message.sender = current_user.email
    @message.recipient = @user.email
    if @message.valid?
      Mailer.single_user_mail(@message).deliver
      flash[:notice] = t('contact.user.success', recipient: @user.full_name)
      redirect_to action: :show
    else
      flash[:alert] = @message.errors.values
      redirect_to action: :show
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :first_name, :last_name, :email)
    end

end
