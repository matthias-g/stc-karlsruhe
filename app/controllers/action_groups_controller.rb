class ActionGroupsController < ApplicationController
  before_action :set_action_group, except: [:index, :new, :create]
  before_action :authenticate_admin!, except: [:show]
  before_action :authorize_action_group, except: [:index, :new, :create]

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  respond_to :html

  def index
    @action_groups = policy_scope(ActionGroup)
  end

  def show
    @actions = policy_scope(@action_group.actions.toplevel).order(visible: :desc, picture_source: :desc)
    return unless params[:filter]
    p = filter_params
    @actions = @actions.where(visible: (p[:visibility] != 'hidden')) unless p[:visibility].blank?
    @actions = @actions.where(date: Date.parse(p[:day])) unless p[:day].blank? || !p[:day].match(/\A\d{2,4}-\d{1,2}-\d{1,2}\z/)
    @actions = @actions.select { |a| a.start_time && a.start_time.hour >= 17 } if p[:after_17h] == '1'
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
    @action_group = params[:title] ? ActionGroup.find_by_title(params[:title]) : ActionGroup.find(params[:id])
    not_found unless @action_group
  end

  def action_group_params
    params.require(:action_group).permit(:title, :default, :start_date, :end_date)
  end

  def filter_params
    params.require(:filter).permit(:visibility, :day, :after_17h)
  end

  def authorize_action_group
    authorize @action_group
  end
end
