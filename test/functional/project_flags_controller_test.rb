require 'test_helper'

class ProjectFlagsControllerTest < ActionController::TestCase
  setup do
    @project_flag = project_flags(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:project_flags)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project_flag" do
    assert_difference('ProjectFlag.count') do
      post :create, project_flag: { name: @project_flag.name, type: @project_flag.type }
    end

    assert_redirected_to project_flag_path(assigns(:project_flag))
  end

  test "should show project_flag" do
    get :show, id: @project_flag
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @project_flag
    assert_response :success
  end

  test "should update project_flag" do
    put :update, id: @project_flag, project_flag: { name: @project_flag.name, type: @project_flag.type }
    assert_redirected_to project_flag_path(assigns(:project_flag))
  end

  test "should destroy project_flag" do
    assert_difference('ProjectFlag.count', -1) do
      delete :destroy, id: @project_flag
    end

    assert_redirected_to project_flags_path
  end
end
