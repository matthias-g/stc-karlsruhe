class Api::ProjectsController < Api::ApiController

  acts_as_token_authentication_handler_for User, except: [:show]

  before_action :set_project
  before_action :authorize_project
  after_action :verify_authorized

  def show
    respond_with(@project)
  end

  def enter
    @project.add_volunteer(current_user)
    render action: :show, formats: [:json]
  end

  def leave
    @project.delete_volunteer(current_user)
    render action: :show, formats: [:json]
  end

  def add_leader
    new_leader = User.find(params[:user_id])
    @project.add_volunteer(new_leader)
    @project.add_leader(new_leader)
    render action: :show, formats: [:json]
  end

  private

    def set_project
      @project = Project.friendly.find(params[:id])
    end

    def authorize_project
      authorize @project
    end

end
