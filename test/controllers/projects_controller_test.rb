require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = projects(:one)
  end

  test 'should not get new as user' do
    sign_in users(:sabine)
    get new_project_url
    assert_redirected_to root_path
  end

  test 'should get new as admin' do
    sign_in users(:admin)
    get new_project_url
    assert_response :success
  end

  test 'should get index as admin' do
    sign_in users(:admin)
    get projects_url
    assert_response :success
  end

  test 'should create only for admin project' do
    sign_in users(:rolf)
    assert_no_difference('Project.count') do
      post projects_url, params: { project: { description: 'Description', individual_tasks: 'Tasks', title: 'Title', desired_team_size: '6' } }
    end
    sign_out users(:rolf)

    sign_in users(:admin)
    assert_difference('Project.count') do
      post projects_url, params: { project: { description: 'Description', individual_tasks: 'Tasks', title: 'Title', desired_team_size: '6' } }
    end
  end

  test 'create project without title should show form again' do
    sign_in users(:admin)
    description = 'This is the description for this new project.'
    post projects_url, params: { project: { description: description,
                                            individual_tasks: 'Tasks',
                                            desired_team_size: '6',
                                            project_week_id: project_weeks(:one).id } }
    assert_response :success
    assert_select '#error_explanation' do |elements|
      elements.each do |element|
        assert_select element, 'li', 'Aktionstitel darf nicht leer sein'
      end
    end
    assert_select '#project_description', description
  end

  test 'should show visible project' do
    assert @project.visible
    get project_url(@project)
    assert_response :success
  end

  test 'should redirect when trying to show invisible project' do
    @project = projects(:two)
    assert_not @project.visible
    get project_url(@project)
    assert_redirected_to login_or_register_url
  end

  test 'should show invisible project if current user leads it' do
    user = users(:rolf)
    sign_in user
    @project = projects(:three)
    assert user.leads_project?(@project)
    assert_not @project.visible
    get project_url(@project)
    assert_response :success
  end

  test 'should redirect when getting edit with no user logged in' do
    get edit_project_url(@project)
    assert_redirected_to login_or_register_path
  end

  test "should redirect when getting edit if user doesn't lead project" do
    sign_in users(:sabine)
    get edit_project_url(@project)
    assert_response :redirect
  end

  test 'should get edit if user leads project' do
    sign_in users(:rolf)
    get edit_project_url(@project)
    assert_response :success
  end

  test 'should update project' do
    sign_in users(:rolf)
    patch project_url(@project), params: { project: { description: 'New Description', title: @project.title, desired_team_size: @project.desired_team_size } }
    assert_equal I18n.t('project.message.updated'), flash[:notice]
    assert_response :redirect
    follow_redirect!
    assert_response :success
    @project.reload
    assert_select 'h1', @project.title
    assert_equal 'New Description', @project.description
    assert_select '.description', 'New Description'
  end

  test 'should not destroy project if no user logged in' do
    assert_no_difference('Project.count') do
      delete project_url(@project)
    end

    assert_redirected_to login_or_register_path
  end

  test 'should destroy project' do
    sign_in users(:rolf)
    assert users(:rolf).leads_project? @project
    assert_difference('Project.count', -1) do
      delete project_url(@project)
    end

    assert_redirected_to @project.project_week
  end

  test 'volunteer should enter project' do
    user = users(:peter)
    sign_in user
    assert_not @project.has_volunteer?(user)
    get enter_project_url(@project)
    @project = Project.find(@project.id)
    assert_redirected_to project_path(@project)
    assert @project.has_volunteer?(user)
  end

  test 'volunteer should leave project' do
    user = users(:peter)
    sign_in user
    @project.add_volunteer(user)
    assert @project.has_volunteer?(user)
    get leave_project_url(@project)
    assert_redirected_to @project
    assert_not @project.has_volunteer?(user)
    assert User.exists?(user.id)
  end

  test 'send notification when volunteer leaves project ' do
    user = users(:peter)
    sign_in user
    @project.add_volunteer(user)
    assert @project.has_volunteer?(user)
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      get leave_project_url(@project)
    end
    assert_redirected_to @project
    assert_not @project.has_volunteer?(user)
  end

  test 'admin should make project visible' do
    sign_in users(:admin)
    @project = projects(:three)
    assert_not @project.visible?
    get make_visible_project_url(@project)
    @project = Project.find(@project.id)
    assert @project.visible?
  end

  test 'non-admin should not make project visible' do
    sign_in users(:rolf)
    @project = projects(:three)
    assert_not @project.visible?
    get make_visible_project_url(@project)
    assert_not @project.visible?
  end

  test 'not signed in user should not make project visible' do
    @project = projects(:three)
    assert_not @project.visible?
    get make_visible_project_url(@project)
    assert_not @project.visible?
    assert_redirected_to login_or_register_path
  end

  test 'admin should make project invisible' do
    sign_in users(:admin)
    assert @project.visible?
    get make_invisible_project_url(@project)
    @project = Project.find(@project.id)
    assert_not @project.visible?
  end

  test 'non-admin should not make project invisible' do
    sign_in users(:rolf)
    assert @project.visible?
    get make_invisible_project_url(@project)
    assert @project.visible?
  end

  test 'not signed in user should not make project invisible' do
    assert @project.visible?
    get make_invisible_project_url(@project)
    assert @project.visible?
    assert_redirected_to login_or_register_path
  end

end
