require 'test_helper'

class IcalControllerTest < ActionDispatch::IntegrationTest
  setup do

  end

  test "actions" do
    get action_ical_url(actions(:default))
  end

  test "get action without event" do
    action = actions(:default)
    action.events.first.destroy
    get action_ical_url(action)
  end

end
