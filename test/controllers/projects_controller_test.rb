require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  setup do
    @project = projects(:one)
  end

  test 'should get new' do
    sign_in users(:sabine)
    get :new
    assert_response :success
  end

  test 'should create project' do
    sign_in users(:rolf)
    assert_difference('Project.count') do
      post :create, project: { description: 'Description', individual_tasks: 'Tasks', title: 'Title', desired_team_size: '6' }
    end

    assert_redirected_to project_path(assigns(:project))
  end

  test 'should show visible project' do
    get :show, id: @project
    assert_response :success
  end

  test 'should redirect when trying to show invisible project' do
    @project = projects(:two)
    get :show, id: @project
    assert_response :redirect
  end

  test 'should get edit' do
    sign_in users(:rolf)
    get :edit, id: @project
    assert_response :success
  end

  test 'should update project' do
    sign_in users(:rolf)
    patch :update, id: @project, project: { description: 'New Description', title: @project.title, desired_team_size: @project.desired_team_size }
    assert_equal I18n.t('project.message.updated'), flash[:notice]
    assert_redirected_to project_path(assigns(:project))
  end

  test 'should destroy project' do
    sign_in users(:rolf)
    assert users(:rolf).leads_project? @project
    assert_difference('Project.count', -1) do
      delete :destroy, id: @project
    end

    assert_redirected_to projects_path
  end
end
