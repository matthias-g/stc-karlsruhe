class UsersController < ApplicationController
  before_action :set_user, except: [:index, :login_or_register]
  before_action :authorize_user, except: [:index, :login_or_register]
  after_action :verify_authorized, except: [:login_or_register]

  respond_to :html

  def index
    authorize User.new
    @users = User.all
    respond_with(@users)
  end

  def show
    if @user.id === current_user.id
      template = Surveys::Template.joins('LEFT JOIN surveys_submissions ON surveys_submissions.template_id = surveys_templates.id')
                     .where(show_in_user_profile: true)
                     .where('surveys_submissions.user_id != ? or surveys_submissions.user_id is null', current_user.id)
                     .order('RANDOM()').first
      # TODO using Rails 5 say something like: .where.not('surveys_submissions.user_id': @current_user.id).or('surveys_submissions.user_id = NULL')
      @submission = Surveys::Submission.create_for_template(template) if template
    else
      #Message for contact_user
      @message = Message.new
    end
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
    if @user.valid_password?(params[:confirm_delete_password]) || current_user.admin?
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
    Mailer.user_mail(@message, current_user, @user).deliver_now
    flash[:notice] = t('contact.user.success', recipient: @user.full_name)
    redirect_to action: :show
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

  def authorize_user
    authorize @user
  end

end
