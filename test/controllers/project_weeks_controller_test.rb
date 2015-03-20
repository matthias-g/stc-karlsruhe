require 'test_helper'

class ProjectWeeksControllerTest < ActionController::TestCase
  setup do
    sign_in(:admin)
    @project_week = project_weeks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:project_weeks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project_week" do
    assert_difference('ProjectWeek.count') do
      post :create, project_week: { default: @project_week.default, title: @project_week.title }
    end

    assert_redirected_to project_week_path(assigns(:project_week))
  end

  test "should show project_week" do
    get :show, id: @project_week
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @project_week
    assert_response :success
  end

  test "should update project_week" do
    patch :update, id: @project_week, project_week: { default: @project_week.default, title: @project_week.title }
    assert_redirected_to project_week_path(assigns(:project_week))
  end

  test "should destroy project_week" do
    assert_difference('ProjectWeek.count', -1) do
      delete :destroy, id: @project_week
    end

    assert_redirected_to project_weeks_path
  end
end
