require 'test_helper'

class ProjectWeeksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project_week = project_weeks(:one)
  end

  test "should get index" do
    sign_in users(:admin)
    get project_weeks_url
    assert_response :success
    assert_select 'tbody tr', 2
  end

  test "should get new" do
    sign_in users(:admin)
    get new_project_week_url
    assert_response :success
  end

  test "should create project_week" do
    sign_in users(:admin)
    assert_difference('ProjectWeek.count') do
      post project_weeks_url, params: { project_week: { default: false, title: '2020' } }
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'h1', 'Projektwoche 2020'
  end

  test "should show project_week" do
    get project_week_url(@project_week)
    assert_response :success
    assert_select 'h1', 'Projektwoche 2015'
  end

  test "project should show short description if available" do
    get project_week_url(@project_week)
    assert_select '.project-description', projects(:one).short_description
  end

  test "project should show description if no short description available" do
    get project_week_url(@project_week)
    assert_select '.project-description', projects(:four).description
  end

  test "should get edit" do
    sign_in users(:admin)
    get edit_project_week_url(@project_week)
    assert_response :success
  end

  test "should update project_week" do
    sign_in users(:admin)
    patch project_week_url(@project_week), params: { project_week: { default: @project_week.default, title: '2020' } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'h1', 'Projektwoche 2020'
  end

  test "should destroy project_week" do
    sign_in users(:admin)
    assert_difference('ProjectWeek.count', -1) do
      delete project_week_url(@project_week)
    end

    assert_response :redirect
  end
end
