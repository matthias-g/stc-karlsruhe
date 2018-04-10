require 'test_helper'

class ActionGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @action_group = action_groups(:one)
  end

  test "should get index" do
    sign_in users(:admin)
    get action_groups_url
    assert_response :success
    assert_select 'tbody tr', 2
  end

  test "should get new" do
    sign_in users(:admin)
    get new_action_group_url
    assert_response :success
  end

  test "should create action group" do
    sign_in users(:admin)
    assert_difference('ActionGroup.count') do
      post action_groups_url, params: {action_group: {default: false, title: 'Aktionswoche 2020', start_date: '2020-05-13', end_date: '2020-05-20' } }
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'h1', 'Aktionswoche 2020'
  end

  test "should show action group" do
    get show_action_group_url(@action_group)
    assert_response :success
    assert_select 'h1', 'Aktionswoche 2015'
    expected_titles = ['Kostenlose Fahrradreparatur in der Innenstadt', 'Ausflug in den Zoo', 'Fest im Kindergarten', 'Volle Aktion']
    assert_select '.action-card .card-title' do |titles|
      assert_equal expected_titles.length, titles.length
      actual_titles = titles.collect{|title| title.text}
      expected_titles.each do |title|
        assert_includes actual_titles, title
      end
    end
  end

  test "rolf should see one more action in action group" do
    sign_in users(:rolf)
    get show_action_group_url(@action_group)
    assert_response :success
    assert_select 'h1', 'Aktionswoche 2015'
    expected_titles = ['Action 3', 'Kostenlose Fahrradreparatur in der Innenstadt', 'Ausflug in den Zoo', 'Fest im Kindergarten', 'Volle Aktion']
    assert_select '.action-card .card-title' do |titles|
      assert_equal expected_titles.length, titles.length
      actual_titles = titles.collect{|title| title.text}
      expected_titles.each do |title|
        assert_includes actual_titles, title
      end
    end
  end

  test "admin should see all actions in action group" do
    sign_in users(:admin)
    get show_action_group_url(@action_group)
    assert_response :success
    assert_select 'h1', 'Aktionswoche 2015'
    expected_titles = ['Action 2', 'Action 3', 'Kostenlose Fahrradreparatur in der Innenstadt', 'Ausflug in den Zoo', 'Fest im Kindergarten', 'Volle Aktion']
    assert_select '.action-card .card-title' do |titles|
      assert_equal expected_titles.length, titles.length
      actual_titles = titles.collect{|title| title.text}
      expected_titles.each do |title|
        assert_includes actual_titles, title
      end
    end
  end

  test "action should show short description if available" do
    get show_action_group_url(@action_group)
    assert_select '.action-card .card-text', actions(:one).short_description
  end

  test "action should show description if no short description available" do
    get show_action_group_url(@action_group)
    assert_select '.action-card .card-text', actions(:four).description
  end

  test "should get edit" do
    sign_in users(:admin)
    get edit_action_group_url(@action_group)
    assert_response :success
  end

  test "should update action group" do
    sign_in users(:admin)
    patch action_group_url(@action_group), params: {action_group: {default: @action_group.default, title: 'Aktionswoche 2020' } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'h1', 'Aktionswoche 2020'
  end

  test "should destroy action group" do
    sign_in users(:admin)
    assert_difference('ActionGroup.count', -1) do
      delete action_group_url(@action_group)
    end

    assert_response :redirect
  end
end
