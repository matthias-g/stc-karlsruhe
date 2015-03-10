class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin_user!

  respond_to :html

  def index
    @roles = Role.all
    respond_with(@role)
  end

  def show
    respond_with(@role)
  end

  def new
    @role = Role.new
    respond_with(@role)
  end

  def edit
    respond_with(@role)
  end

  def create
    @role = Role.new(role_params)
    @role.save
    respond_with(@role)
  end

  def update
    @role.update(role_params)
    respond_with(@role)
  end

  def destroy
    @role.destroy
    respond_with(@role)
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

end
