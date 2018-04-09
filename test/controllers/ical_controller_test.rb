require 'test_helper'

class IcalControllerTest < ActionDispatch::IntegrationTest
  setup do

  end

  test 'actions' do
    get action_ical_url(actions(:one))
  end
end
