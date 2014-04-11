require 'test_helper'

class ViewControllerTest < ActionController::TestCase
  test "should get Contact" do
    get :Contact
    assert_response :success
  end

end
