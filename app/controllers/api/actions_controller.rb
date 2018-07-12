class Api::ActionsController < Api::ApiController

  def index
    params[:include] = 'parent-action,action-group,tags' if params[:include].nil?
    super
  end

end