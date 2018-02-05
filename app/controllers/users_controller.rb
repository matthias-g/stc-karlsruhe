class UsersController < ApplicationController
  before_action :set_user, except: [:index, :login_or_register]
  before_action :authorize_user, except: [:index, :login_or_register]
  after_action :verify_authorized, except: [:login_or_register]

  respond_to :html

  def index
    authorize User.new
    @users = User.all.order(:created_at)
    respond_with(@users)
  end

  def show
    if @user.id === current_user.id
      template = Surveys::Template.where(show_in_user_profile: true).order('RANDOM()').first
      if template && !template.submissions.where(user_id: current_user.id).exists?
        @submission = Surveys::Submission.create_for_template(template)
      end
    else
      # Message for contact_user
      @message = Message.new
    end
    @past_actions = @user.actions.finished
    @actions_as_leader = @user.actions_as_leader - @past_actions
    @actions_as_volunteer = @user.actions_as_volunteer - @actions_as_leader - @past_actions
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
    params.require(:user).permit(:username, :first_name, :last_name, :email, :phone,
                                 :receive_emails_about_action_groups, :receive_emails_about_my_action_groups, :receive_emails_about_other_projects,
                                 :receive_other_emails_from_orga, :receive_emails_from_other_users)
  end

  def authorize_user
    authorize @user
  end

end
