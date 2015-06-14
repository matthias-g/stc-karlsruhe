class Feedback::SurveysController < ApplicationController
  before_action :authenticate_admin_user!, except: :show
  before_action :set_survey, only: [:show, :edit, :update, :destroy]
  before_action :redirect_non_admins_to_answers, only: :show

  respond_to :html

  def index
    @surveys = Feedback::Survey.all
    respond_with(@surveys)
  end

  def show
    respond_with(@survey)
  end

  def new
    @survey = Feedback::Survey.new
    @survey.questions.build
    respond_with(@survey)
  end

  def edit
  end

  def create
    @survey = Feedback::Survey.new(survey_params)
    @survey.save
    respond_with(@survey)
  end

  def update
    @survey.update(survey_params)
    respond_with(@survey)
  end

  def destroy
    @survey.destroy
    respond_with(@survey)
  end

  private

  def set_survey
    @survey = Feedback::Survey.friendly.find(params[:id])
  end

  def survey_params
    params.require(:feedback_survey).permit(:title, questions_attributes: [:id, :text, :answer_options, :question_type, :position, :is_subquestion, :_destroy] )
  end

  def redirect_non_admins_to_answers
    unless current_user && current_user.is_admin?
      redirect_to new_feedback_survey_feedback_survey_answer_path(@survey)
    end
  end
end
