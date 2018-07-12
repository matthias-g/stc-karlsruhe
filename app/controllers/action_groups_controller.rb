class ActionGroupsController < ApplicationController
  before_action :set_action_group, except: [:index, :new, :create]
  before_action :authenticate_admin!, except: [:show]
  before_action :authorize_action_group, except: [:index, :new, :create]

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  respond_to :html

  def index
    @action_groups = policy_scope(ActionGroup.all)
  end

  def show
    #include_request('api_actions_path', Api::ActionsController,:index,
    #                filter: {action_group: @action_group.id})
  end

  def new
    @action_group = ActionGroup.new
    authorize_action_group
  end

  def edit
  end

  def create
    @action_group = ActionGroup.new(action_group_params)
    authorize_action_group
    @action_group.save
    respond_with @action_group
  end

  def update
    @action_group.update(action_group_params)
    respond_with @action_group
  end

  def destroy
    @action_group.destroy
    respond_with @action_group
  end

  private

  def set_action_group
    @action_group = ActionGroup.friendly.find(params[:id])
    not_found unless @action_group
  end

  def action_group_params
    params.require(:action_group).permit(:title, :default, :start_date, :end_date, :declination)
  end

  def filter_params
    params.require(:filter).permit(:visibility, :day, :after_17h)
  end

  def authorize_action_group
    authorize @action_group
  end
end
