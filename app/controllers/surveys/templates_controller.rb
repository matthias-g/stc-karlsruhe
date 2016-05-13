class Surveys::TemplatesController < ApplicationController
  before_action :authenticate_admin_user!, except: :show
  before_action :set_template, only: [:show, :edit, :update, :destroy]
  before_action :redirect_non_admins_to_answers, only: :show

  respond_to :html

  def index
    @templates = Surveys::Template.all
    respond_with(@templates)
  end

  def show
    respond_with(@template)
  end

  def new
    @template = Surveys::Template.new
    @template.questions.build
    respond_with(@template)
  end

  def edit
  end

  def create
    @template = Surveys::Template.new(template_params)
    @template.save
    respond_with(@template)
  end

  def update
    @template.update(template_params)
    respond_with(@template)
  end

  def destroy
    @template.destroy
    respond_with(@template)
  end

  private

  def set_template
    @template = Surveys::Template.friendly.find(params[:id])
  end

  def template_params
    params.require(:surveys_template).permit(:title, questions_attributes: [:id, :text, :answer_options, :question_type, :position, :is_subquestion, :_destroy] )
  end

  def redirect_non_admins_to_answers
    unless current_user && current_user.admin?
      redirect_to new_surveys_template_surveys_submission_path(@template)
    end
  end
end
