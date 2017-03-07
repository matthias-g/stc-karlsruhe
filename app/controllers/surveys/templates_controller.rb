class Surveys::TemplatesController < ApplicationController
  before_action :authenticate_admin_or_coordinator!, except: :show
  before_action :set_template, only: [:show, :edit, :update, :destroy]
  before_action :redirect_non_admins_to_answers, only: :show
  before_action :authorize_template, except: [:index, :new, :create]

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  respond_to :html

  def index
    @templates = policy_scope(Surveys::Template)
    respond_with(@templates)
  end

  def show
    respond_with(@template)
  end

  def new
    @template = Surveys::Template.new
    @template.questions.build
    authorize_template
    respond_with(@template)
  end

  def edit
  end

  def create
    @template = Surveys::Template.new(template_params)
    authorize_template
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
    params.require(:surveys_template).permit(:title, :show_in_user_profile, questions_attributes:
        [:id, :text, :explanation, :answer_options, :question_type, :position, :is_subquestion, :_destroy] )
  end

  def authorize_template
    authorize @template
  end

  def redirect_non_admins_to_answers
    unless current_user && (current_user.admin? || current_user.coordinator?)
      redirect_to new_surveys_template_surveys_submission_path(@template)
    end
  end
end
