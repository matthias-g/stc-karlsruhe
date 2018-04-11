require 'test_helper'

class IcalControllerTest < ActionDispatch::IntegrationTest
  setup do

  end

  test 'actions' do
    get action_ical_url(actions(:one))
  end

  test 'get action with event without date' do
    action = actions(:undated)
    get action_ical_url(action)
  end
end
