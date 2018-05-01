require 'test_helper'

class ActionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @action = actions(:one)
  end

  test 'should not get new as user' do
    sign_in users(:sabine)
    get new_action_url
    assert_redirected_to root_path
  end

  test 'should get new as admin' do
    sign_in users(:admin)
    get new_action_url
    assert_response :success
  end

  test 'should get index as admin' do
    sign_in users(:admin)
    get actions_url
    assert_response :success
  end

  test 'should create only for admin action' do
    sign_in users(:rolf)
    assert_no_difference('Action.count') do
      post actions_url, params: {the_action: {description: 'Description', individual_tasks: 'Tasks', title: 'Title' } }
    end
    sign_out users(:rolf)

    sign_in users(:admin)
    assert_difference('Action.count') do
      post actions_url, params: {the_action: {description: 'Description', individual_tasks: 'Tasks', title: 'Title' } }
    end
  end

  test 'create action without title should show form again' do
    sign_in users(:admin)
    description = 'This is the description for this new action.'
    post actions_url, params: {the_action: {description: description,
                                        individual_tasks: 'Tasks',
                                        action_group_id: action_groups(:one).id } }
    assert_response :success
    assert_select '#error_explanation' do |elements|
      elements.each do |element|
        assert_select element, 'li', 'Aktionstitel darf nicht leer sein'
      end
    end
    assert_select '#the_action_description', description
  end

  test 'should show visible action' do
    assert @action.visible
    get action_url(@action)
    assert_response :success
  end

  test 'should redirect when trying to show invisible action' do
    @action = actions(:two)
    assert_not @action.visible
    get action_url(@action)
    assert_redirected_to new_user_session_url
  end

  test 'should show invisible action if current user leads it' do
    user = users(:rolf)
    sign_in user
    @action = actions(:three)
    assert user.leads_action?(@action)
    assert_not @action.visible
    get action_url(@action)
    assert_response :success
  end

  test 'should show action with subaction without picture' do
    @action = actions(:'kindergarten-party')
    assert @action.subactions.select { |p| !p.show_picture? }.count > 0
    assert @action.visible
    get action_url(@action)
    assert_response :success
  end

  test 'should show action with subactions with start time and without' do
    @action = actions(:'kindergarten-party')
    assert @action.subactions.select { |p| p.start_time == nil }.count > 0
    assert @action.subactions.select { |p| p.start_time != nil }.count > 0
    get action_url(@action)
    assert_response :success
  end

  test 'should show action with parent action without picture' do
    @action = actions(:'kindergarten-kitchen')
    assert @action.visible
    assert_not @action.parent_action.show_picture?
    get action_url(@action)
    assert_response :success
  end

  test 'should show link to register for participation when no user logged in' do
    get action_url(@action)
    assert_select "a[href=\"#{register_for_participation_event_path(@action.events.first)}\"]", 1
  end

  test 'should show undated action' do
    get action_url(actions(:undated))
    assert_response :success
  end

  test 'should redirect when getting edit with no user logged in' do
    get edit_action_url(@action)
    assert_redirected_to new_user_session_path
  end

  test "should redirect when getting edit if user doesn't lead action" do
    sign_in users(:sabine)
    get edit_action_url(@action)
    assert_response :redirect
  end

  test 'should get edit if user leads action' do
    sign_in users(:rolf)
    get edit_action_url(@action)
    assert_response :success
  end

  test 'should update action' do
    sign_in users(:rolf)
    patch action_url(@action), params: {the_action: {description: 'New Description', title: @action.title } }
    assert_equal I18n.t('action.message.updated'), flash[:notice]
    assert_response :redirect
    follow_redirect!
    assert_response :success
    @action.reload
    assert_select 'h1', @action.title
    assert_equal 'New Description', @action.description
    assert_select '.description', 'New Description'
  end

  test 'should not destroy action if no user logged in' do
    assert_no_difference('Action.count') do
      delete action_url(@action)
    end

    assert_redirected_to new_user_session_path
  end

  test 'should destroy action' do
    sign_in users(:rolf)
    assert users(:rolf).leads_action? @action
    assert_difference('Action.count', -1) do
      delete action_url(@action)
    end

    assert_redirected_to @action.action_group
  end

  test 'admin should make action visible' do
    sign_in users(:admin)
    @action = actions(:three)
    assert_not @action.visible?
    get make_visible_action_url(@action)
    @action = Action.find(@action.id)
    assert @action.visible?
  end

  test 'non-admin should not make action visible' do
    sign_in users(:rolf)
    @action = actions(:three)
    assert_not @action.visible?
    get make_visible_action_url(@action)
    assert_not @action.visible?
  end

  test 'not signed in user should not make action visible' do
    @action = actions(:three)
    assert_not @action.visible?
    get make_visible_action_url(@action)
    assert_not @action.visible?
    assert_redirected_to new_user_session_path
  end

  test 'admin should make action invisible' do
    sign_in users(:admin)
    assert @action.visible?
    get make_invisible_action_url(@action)
    @action = Action.find(@action.id)
    assert_not @action.visible?
  end

  test 'non-admin should not make action invisible' do
    sign_in users(:rolf)
    assert @action.visible?
    get make_invisible_action_url(@action)
    assert @action.visible?
  end

  test 'not signed in user should not make action invisible' do
    assert @action.visible?
    get make_invisible_action_url(@action)
    assert @action.visible?
    assert_redirected_to new_user_session_path
  end

end
