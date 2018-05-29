require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:unrelated)
  end

  # TODO test that clear! is persisted with save!

end
