require 'test_helper'

class ActionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @action = actions(:default)
  end


  # REDIRECTS

  test "should redirect 'new' to root (as non-admin)" do
    sign_in users(:leader)
    get new_action_url
    assert_redirected_to root_path
  end

  test "should redirect 'edit' (as non-leader)" do
    sign_in users(:volunteer)
    get edit_action_url(@action)
    assert_response :redirect
  end

  test "should redirect 'show' to login for invisible action (as visitor)" do
    get action_url(actions(:subaction_3_invisible))
    assert_redirected_to new_user_session_url
  end

  test "should redirect 'edit' to login (as visitor)" do
    get edit_action_url(@action)
    assert_redirected_to new_user_session_path
  end

  test "should redirect 'destroy' to login (as visitor)" do
    assert_no_difference('Action.count') do
      delete action_url(@action)
    end
    assert_redirected_to new_user_session_path
  end

  test "should redirect 'make visible' to login (as visitor)" do
    action = actions(:subaction_3_invisible)
    get make_invisible_action_url(action)
    assert_not action.visible?
    assert_redirected_to new_user_session_path
  end

  test "should redirect 'make invisible' to login (as visitor)" do
    get make_invisible_action_url(@action)
    assert @action.visible?
    assert_redirected_to new_user_session_path
  end



  # VISITOR ACCESS

  test "visitor should get single action" do
    get action_url(@action)
    assert_response :success
  end

  test "visitor should get parent action" do
    action = actions(:parent_action)
    get action_url(action)
    assert_response :success
  end

  test "visitor should get subaction" do
    action = actions(:subaction)
    get action_url(action)
    assert_response :success
  end

  test "visitor should get undated action" do
    @action.events.first.destroy!
    get action_url(@action.reload)
    assert_response :success
  end

  test "visitor should see registration link on action 'show'" do
    get action_url(@action)
    assert_select "a[href=\"#{register_for_participation_event_path(@action.events.first)}\"]", 1
  end


  # VOLUNTEER ACCESS

  test "volunteer should send message to leaders" do
    sign_in users(:volunteer)
    assert_mails_sent(2) do
      post contact_leaders_action_path(@action),
           params: { message: { subject: 'Test', body: 'Hey, how are you?' } }
    end
  end


  # LEADER ACCESS

  test "leader should 'show' invisible action" do
    sign_in users(:subaction_leader)
    get action_url(actions(:subaction_3_invisible))
    assert_response :success
  end

  test "leader should 'edit' action" do
    sign_in users(:leader)
    get edit_action_url(@action)
    assert_response :success
  end

  test "leader should 'update' action" do
    sign_in users(:leader)
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

  test "leader should 'destroy' action" do
    sign_in users(:leader)
    assert_difference('Action.count', -1) do
      delete action_url(@action)
    end
    assert_redirected_to @action.action_group
  end

  test "leader should not make action visible" do
    sign_in users(:subaction_leader)
    action = actions(:subaction_3_invisible)
    get make_visible_action_url(action)
    assert_not action.visible?
  end

  test "leader should not make action invisible" do
    sign_in users(:leader)
    get make_invisible_action_url(@action)
    assert @action.visible?
  end

  test "leader should send message to volunteers" do
    sign_in users(:leader)
    assert_mails_sent(3) do
      post contact_volunteers_action_path(@action), params: {
          message: { subject: 'Test', body: 'Hey, how are you?', recipient_scope: 'this_action' } }
    end
    assert_equal all_mails(:volunteer, :ancient_user, :leader), mail_recipients
  end

  test "leader should send message to volunteers of action and subactions" do
    @action = actions(:parent_action)
    sign_in users(:leader)
    assert_mails_sent(4) do
      post contact_volunteers_action_path(@action), params: {
          message: { subject: 'Test', body: 'Hey, how are you?', recipient_scope: 'action_and_subactions' } }
    end
    assert_equal all_mails(:subaction_volunteer, :subaction_2_volunteer, :leader, :subaction_leader), mail_recipients
  end



  # ADMIN / COORDINATOR ACCESS

  test "coordinator should show past action" do
    sign_in users(:coordinator)
    @action.events.first.update_attribute :date, 2.days.ago
    get action_url(@action.reload)
    assert_response :success
  end

  test "coordinator should get 'new'" do
    sign_in users(:coordinator)
    get new_action_url
    assert_response :success
  end

  test "coordinator should index actions" do
    sign_in users(:coordinator)
    get actions_url
    assert_response :success
  end

  test "coordinator should create action" do
    sign_in users(:coordinator)
    assert_difference'Action.count', +1 do
      post actions_url, params: {the_action: {title: 'Title', action_group_id: action_groups(:default).id}}
    end
  end

  test "coordinator should make action visible" do
    sign_in users(:coordinator)
    action = actions(:subaction_3_invisible)
    get make_visible_action_url(action)
    assert action.reload.visible?
  end

  test "coordinator should make action invisible" do
    sign_in users(:coordinator)
    get make_invisible_action_url(@action)
    assert_not @action.reload.visible?
  end



  # VALIDATIONS

  test "create without title should show form again" do
    sign_in users(:admin)
    action_params = {description: 'This is the description for this new action.',
                     action_group_id: action_groups(:default).id }
    post actions_url, params: {the_action: action_params}
    assert_response :success
    assert_select '#error_explanation' do |elements|
      elements.each do |element|
        assert_select element, 'li', 'Aktionstitel darf nicht leer sein'
      end
    end
    assert_select '#the_action_description', action_params[:description]
  end

end
