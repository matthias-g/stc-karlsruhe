require 'test_helper'

class ActionGroupsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @action_group = action_groups(:default)
    @action = actions(:default)
  end


  # VISITOR ACCESS

  test "should show action group" do
    get show_action_group_url(@action_group)
    assert_response :success
    assert_select 'h1', @action_group.title
    expected_titles = @action_group.actions.visible.toplevel.pluck(:title)
    assert_select '.action-card .card-title' do |titles|
      assert_equal expected_titles.length, titles.length
      actual_titles = titles.collect{|title| title.text}
      expected_titles.each do |title|
        assert_includes actual_titles, title
      end
    end
  end

  test "action should show short description" do
    get show_action_group_url(@action_group)
    assert_select '.action-card .card-text', @action.short_description
  end

  test "action should show description if no short description available" do
    @action.update_attribute :short_description, ''
    get show_action_group_url(@action_group)
    assert_select '.action-card .card-text', @action.description
  end

  test "should show filtered action group" do
    get show_action_group_url(@action_group, filter: {day: '2017-07-03'})
    assert_response :success
  end



  # LEADER ACCESS

  test "leader should see own invisible action" do
    sign_in users(:leader)
    @action.update_attribute :visible, false
    get show_action_group_url(@action_group)
    assert_response :success
    assert_select '.action-card .card-title', @action.title
  end



  # ADMIN ACCESS

  test "admin should 'index' action groups" do
    sign_in users(:admin)
    get action_groups_url
    assert_response :success
    assert_select 'tbody tr', ActionGroup.all.count
  end

  test "should get 'new'" do
    sign_in users(:admin)
    get new_action_group_url
    assert_response :success
  end

  test "admin should 'create' action group" do
    sign_in users(:admin)
    assert_difference('ActionGroup.count') do
      post action_groups_url, params: {
          action_group: {default: false, title: 'Aktionswoche 2020',
                         start_date: '2020-05-13', end_date: '2020-05-20' } }
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'h1', 'Aktionswoche 2020'
  end

  test "admin should see all actions in action group" do
    sign_in users(:admin)
    get show_action_group_url(@action_group)
    assert_response :success
    assert_select 'h1', @action_group.title
    expected_titles = @action_group.actions.toplevel.pluck(:title)
    assert_select '.action-card .card-title' do |titles|
      assert_equal expected_titles.length, titles.length
      actual_titles = titles.collect{|title| title.text}
      expected_titles.each do |title|
        assert_includes actual_titles, title
      end
    end
  end

  test "admin should 'edit' action group" do
    sign_in users(:admin)
    get edit_action_group_url(@action_group)
    assert_response :success
  end

  test "admin should 'update' action group" do
    sign_in users(:admin)
    patch action_group_url(@action_group), params: {
        action_group: {default: @action_group.default, title: 'Aktionswoche 2020' } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'h1', 'Aktionswoche 2020'
  end

  test "admin should 'destroy' action group" do
    sign_in users(:admin)
    assert_difference('ActionGroup.count', -1) do
      delete action_group_url(@action_group)
    end
    assert_response :redirect
  end

end
