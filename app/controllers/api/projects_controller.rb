module Api
  class ProjectsController < Api::ApiController

    include JSONAPI::ActsAsResourceController

    private

    def context
      { user: current_user }
    end

  end
end