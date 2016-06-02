class Surveys::SubmissionsController < ApplicationController
  before_action :authenticate_admin_user!, except: [:new, :create]
  before_action :set_submission, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    template = Surveys::Template.friendly.find(params[:surveys_template_id])
    @submissions = template.submissions
    respond_with(@submissions)
  end

  def show
    respond_with(@submission)
  end

  def new
    template = Surveys::Template.friendly.find(params[:surveys_template_id])
    @submission = Surveys::Submission.create_for_template(template)
    respond_with(@submission)
  end

  def edit
  end

  def create
    @submission = Surveys::Submission.new(submission_params)
    @submission.user_id = current_user.id if current_user
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
end
