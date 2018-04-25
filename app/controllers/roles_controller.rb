class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!
  before_action :authorize_role, except: [:index, :new, :create]

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  respond_to :html

  def index
    @roles = policy_scope(Role)
  end

  def new
    @role = Role.new
    authorize_role
  end

  def edit
  end

  def create
    @role = Role.new(role_params)
    authorize_role
    @role.save
    redirect_to roles_path
  end

  def update
    @role.update(role_params)
    redirect_to roles_path
  end

  def destroy
    @role.destroy
    redirect_to roles_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_role
    @role = Role.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def role_params
    params.require(:role).permit(:title)
  end

  def authorize_role
    authorize @role
  end

end
