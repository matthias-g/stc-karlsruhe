require 'test_helper'

class ProjectWeeksControllerTest < ActionController::TestCase
  setup do
    @project_week = project_weeks(:one)
  end

  test "should get index" do
    sign_in users(:admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:project_weeks)
  end

  test "should get new" do
    sign_in users(:admin)
    get :new
    assert_response :success
  end

  test "should create project_week" do
    sign_in users(:admin)
    assert_difference('ProjectWeek.count') do
      post :create, project_week: { default: false, title: 'First project week' }
    end

    assert_redirected_to project_week_path(assigns(:project_week))
  end

  test "should show project_week" do
    get :show, id: @project_week
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:admin)
    get :edit, id: @project_week
    assert_response :success
  end

  test "should update project_week" do
    sign_in users(:admin)
    patch :update, id: @project_week, project_week: { default: @project_week.default, title: @project_week.title }
    assert_redirected_to project_week_path(assigns(:project_week))
  end

  test "should destroy project_week" do
    sign_in users(:admin)
    assert_difference('ProjectWeek.count', -1) do
      delete :destroy, id: @project_week
    end

    assert_redirected_to project_weeks_path
  end
end
