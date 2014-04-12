require 'test_helper'

class ProjectDaysControllerTest < ActionController::TestCase
  setup do
    @project_day = project_days(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:project_days)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project_day" do
    assert_difference('ProjectDay.count') do
      post :create, project_day: { title: @project_day.title }
    end

    assert_redirected_to project_day_path(assigns(:project_day))
  end

  test "should show project_day" do
    get :show, id: @project_day
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @project_day
    assert_response :success
  end

  test "should update project_day" do
    patch :update, id: @project_day, project_day: { title: @project_day.title }
    assert_redirected_to project_day_path(assigns(:project_day))
  end

  test "should destroy project_day" do
    assert_difference('ProjectDay.count', -1) do
      delete :destroy, id: @project_day
    end

    assert_redirected_to project_days_path
  end
end
