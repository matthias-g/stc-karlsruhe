require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:rolf)
  end

  # TODO test that clear! is persisted with save!

end
