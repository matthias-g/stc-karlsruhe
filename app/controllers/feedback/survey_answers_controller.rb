class Feedback::SurveyAnswersController < ApplicationController
  before_action :set_feedback_survey_answer, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @feedback_survey_answers = Feedback::SurveyAnswer.all
    respond_with(@feedback_survey_answers)
  end

  def show
    respond_with(@feedback_survey_answer)
  end

  def new
    @feedback_survey_answer = Feedback::SurveyAnswer.new
    respond_with(@feedback_survey_answer)
  end

  def edit
  end

  def create
    @feedback_survey_answer = Feedback::SurveyAnswer.new(survey_answer_params)
    @feedback_survey_answer.save
    respond_with(@feedback_survey_answer)
  end

  def update
    @feedback_survey_answer.update(survey_answer_params)
    respond_with(@feedback_survey_answer)
  end

  def destroy
    @feedback_survey_answer.destroy
    respond_with(@feedback_survey_answer)
  end

  private
    def set_feedback_survey_answer
      @feedback_survey_answer = Feedback::SurveyAnswer.find(params[:id])
    end

    def feedback_survey_answer_params
      params.require(:feedback_survey_answer).permit(:survey_id)
    end
end
