class Api::ProjectsController < ApplicationController
  before_action :set_project, only: [:show]

  respond_to :json

  def show
    respond_with(@project)
  end

  private

    def set_project
      @project = Project.friendly.find(params[:id])
    end

end
