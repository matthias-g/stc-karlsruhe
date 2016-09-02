class Surveys::SubmissionsController < ApplicationController
  before_action :authenticate_admin_user!, except: [:new, :create]
  before_action :set_submission, only: [:show, :edit, :update, :destroy]
  before_action :authorize_submission, except: [:index, :new, :create]

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  respond_to :html

  def index
    @template = Surveys::Template.friendly.find(params[:surveys_template_id])
    @submissions = policy_scope(@template.submissions.order(created_at: :desc))
    respond_with(@submissions)
  end

  def show
    respond_with(@submission)
  end

  def new
    template = Surveys::Template.friendly.find(params[:surveys_template_id])
    @submission = Surveys::Submission.create_for_template(template)
    authorize_submission
    respond_with(@submission)
  end

  def edit
  end

  def create
    @submission = Surveys::Submission.new(submission_params)
    @submission.user_id = current_user.id if current_user && @submission.template.show_in_user_profile
    authorize_submission
    @submission.save
    redirect_to '/', notice: t('surveys.message.answerCreated')
  end

  def update
    @submission.update(submission_params)
    respond_with(@submission)
  end

  def destroy
    @submission.destroy
    respond_with(@submission)
  end

  private

  def set_submission
    @submission = Surveys::Submission.find(params[:id])
  end

  def submission_params
    params.require(:surveys_submission).permit(:template_id, answers_attributes: [:id, :question_id, :text])
  end

  def authorize_submission
    authorize @submission
  end
end
