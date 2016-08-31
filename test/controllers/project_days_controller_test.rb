require 'test_helper'

class ProjectDaysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project_day = project_days(:one)
    sign_in users(:admin)
  end

  test "should get index" do
    get project_days_url
    assert_response :success
    assert_select 'tbody tr', 3
  end

  test "should get new" do
    get new_project_day_url
    assert_response :success
  end

  test "should create project_day" do
    assert_difference('ProjectDay.count') do
      post project_days_url, params: { project_day: { title: @project_day.title } }
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'h1', @project_day.title
  end

  test "should show project_day" do
    get project_day_url(@project_day)
    assert_response :success
  end

  test "should get edit" do
    get edit_project_day_url(@project_day)
    assert_response :success
  end

  test "should update project_day" do
    patch project_day_url(@project_day), params: { project_day: { title: 'new title' } }
    assert_redirected_to project_day_path(@project_day.reload)
    assert_equal 'new title', @project_day.title
  end

  test "should destroy project_day" do
    assert_difference('ProjectDay.count', -1) do
      delete project_day_url(@project_day)
    end

    assert_redirected_to project_days_path
  end
end
