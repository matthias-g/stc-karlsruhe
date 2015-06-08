class Feedback::QuestionsController < ApplicationController
  before_action :set_feedback_question, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @feedback_questions = Feedback::Question.all
    respond_with(@feedback_questions)
  end

  def show
    respond_with(@feedback_question)
  end

  def new
    @feedback_question = Feedback::Question.new
    respond_with(@feedback_question)
  end

  def edit
  end

  def create
    @feedback_question = Feedback::Question.new(question_params)
    @feedback_question.save
    respond_with(@feedback_question)
  end

  def update
    @feedback_question.update(question_params)
    respond_with(@feedback_question)
  end

  def destroy
    @feedback_question.destroy
    respond_with(@feedback_question)
  end

  private
    def set_feedback_question
      @feedback_question = Feedback::Question.find(params[:id])
    end

    def feedback_question_params
      params.require(:feedback_question).permit(:survey_id, :text, :answer_options, :type, :position, :parent_question_id)
    end
end
