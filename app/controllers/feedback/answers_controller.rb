class Feedback::AnswersController < ApplicationController
  before_action :set_feedback_answer, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @feedback_answers = Feedback::Answer.all
    respond_with(@feedback_answers)
  end

  def show
    respond_with(@feedback_answer)
  end

  def new
    @feedback_answer = Feedback::Answer.new
    respond_with(@feedback_answer)
  end

  def edit
  end

  def create
    @feedback_answer = Feedback::Answer.new(answer_params)
    @feedback_answer.save
    respond_with(@feedback_answer)
  end

  def update
    @feedback_answer.update(answer_params)
    respond_with(@feedback_answer)
  end

  def destroy
    @feedback_answer.destroy
    respond_with(@feedback_answer)
  end

  private
    def set_feedback_answer
      @feedback_answer = Feedback::Answer.find(params[:id])
    end

    def feedback_answer_params
      params.require(:feedback_answer).permit(:survey_answer_id, :question_id, :text)
    end
end
