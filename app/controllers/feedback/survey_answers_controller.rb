class Feedback::SurveyAnswersController < ApplicationController
  before_action :set_survey_answer, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    survey = Feedback::Survey.friendly.find(params[:feedback_survey_id])
    @survey_answers = survey.survey_answers
    respond_with(@survey_answers)
  end

  def show
    respond_with(@survey_answer)
  end

  def new
    survey = Feedback::Survey.friendly.find(params[:feedback_survey_id])
    @survey_answer = Feedback::SurveyAnswer.new(survey: survey)
    @survey_answer.survey = survey
    survey.questions.each do |question|
      @survey_answer.answers.build(question: question)
    end
    respond_with(@survey_answer)
  end

  def edit
  end

  def create
    @survey_answer = Feedback::SurveyAnswer.new(survey_answer_params)
    @survey_answer.save
    respond_with([@survey_answer.survey, @survey_answer])
  end

  def update
    @survey_answer.update(survey_answer_params)
    respond_with(@survey_answer)
  end

  def destroy
    @survey_answer.destroy
    respond_with(@survey_answer)
  end

  private
    def set_survey_answer
      @survey_answer = Feedback::SurveyAnswer.find(params[:id])
    end

    def survey_answer_params
      params.require(:feedback_survey_answer).permit(:survey_id, answers_attributes: [:id, :question_id, :text])
    end
end
