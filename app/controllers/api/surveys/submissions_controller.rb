class Api::Surveys::SubmissionsController < Api::ApiController

  acts_as_token_authentication_handler_for User, except: [:show]

  after_action :verify_authorized

  def create
    @submission = Surveys::Submission.new(submission_params)
    authorize @submission
    @submission.user_id = current_user.id if current_user && @submission.template.show_in_user_profile
    @submission.save
    respond_with :api, @submission.template, @submission
  end

  private

  def submission_params
    params.require(:surveys_submission).permit(:template_id, answers_attributes: [:id, :question_id, :text])
  end

end
