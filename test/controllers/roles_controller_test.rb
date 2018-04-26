require 'test_helper'

class RolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @role = roles(:default)
    sign_in users(:admin)
  end

  test "should get new" do
    get new_role_url
    assert_response :success
  end

  test "should create role" do
    assert_difference('Role.count') do
      post roles_url, params: { role: { title: @role.title } }
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

  test "should get edit" do
    get edit_role_url(@role)
    assert_response :success
  end

  test "should update role" do
    patch role_url(@role), params: { role: { title: 'New title' } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_equal 'New title', @role.reload.title
  end

  test "should destroy role" do
    assert_difference('Role.count', -1) do
      delete role_url(@role)
    end

    assert_redirected_to roles_path
  end
end
