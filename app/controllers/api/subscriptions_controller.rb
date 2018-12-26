class Api::SubscriptionsController < Api::ApiController

  include JSONAPI::ActsAsResourceController

  def create
    if current_user&.confirmed? && current_user.email == params['data']['attributes']['email']
      params['data']['attributes']['confirmed-at'] = DateTime.now
    else
      params['data']['attributes'].delete('confirmed-at')
    end
    process_request
  end

  private

  def context
    { user: current_user }
  end

end