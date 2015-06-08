class Feedback::SurveysController < ApplicationController
  before_action :set_feedback_survey, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @feedback_surveys = Feedback::Survey.all
    respond_with(@feedback_surveys)
  end

  def show
    respond_with(@feedback_survey)
  end

  def new
    @feedback_survey = Feedback::Survey.new
    @feedback_survey.questions.build
    respond_with(@feedback_survey)
  end

  def edit
  end

  def create
    @feedback_survey = Feedback::Survey.new(survey_params)
    @feedback_survey.save
    respond_with(@feedback_survey)
  end

  def update
    @feedback_survey.update(survey_params)
    respond_with(@feedback_survey)
  end

  def destroy
    @feedback_survey.destroy
    respond_with(@feedback_survey)
  end

  private
    def set_feedback_survey
      @feedback_survey = Feedback::Survey.find(params[:id])
    end

    def feedback_survey_params
      params.require(:feedback_survey).permit(:title)
    end
end
