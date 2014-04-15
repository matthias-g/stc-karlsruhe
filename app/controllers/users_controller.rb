class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :authenticate_user!
  before_action :check_admin, only: [:index]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  def my_profile
    @user = current_user
  end

  # GET /users/1
  # GET /users/1.json
  def show
    set_user
    if current_user == @user
        redirect_to profile_path
    end
  end

  # # GET /users/new
  # def new
  #   @user = User.new
  # end

  def edit_my_profile
    @user = current_user
  end

  # # POST /users
  # # POST /users.json
  # def create
  #   @user = User.new(user_params)
  #
  #   respond_to do |format|
  #     if @user.save
  #       format.html { redirect_to @user, notice: 'User was successfully created.' }
  #       format.json { render action: 'show', status: :created, location: @user }
  #     else
  #       format.html { render action: 'new' }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def update_my_profile
    @user = User.find(current_user.id)
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to action: :my_profile, notice: t('user.message.profileUpdated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit_my_profile' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy_my_profile
    @user = User.find(current_user.id)
    @user.destroy
    respond_to do |format|
      format.html { redirect_to '/' }
      format.json { head :no_content }
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
