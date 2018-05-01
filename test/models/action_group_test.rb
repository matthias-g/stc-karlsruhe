require 'test_helper'

class ActionGroupTest < ActiveSupport::TestCase

  test 'actions of action group' do
    assert_equal 8, action_groups(:one).actions.count
  end

  test 'active user count for action group with users' do
    assert_equal 6, action_groups(:one).active_user_count
  end

  test 'active user count for action group without users' do
    assert_equal 0, action_groups(:two).active_user_count
  end

  test 'date range' do
    date_range = action_groups(:one).date_range
    assert_equal '2015-06-06'.to_date, date_range.begin
    assert_equal '2015-06-13'.to_date, date_range.end
  end

  test 'vacancy count' do
    action_group = ActionGroup.create!(title: 2017, start_date: '2017-06-11', end_date: '2017-06-19')
    parent_action = Action.create!(title: 'parent action', visible: true, action_group: action_group)
    parent_event = Event.create!(date: Date.current, initiative: parent_action, desired_team_size: 1)
    child1 = Action.create!(title: 'child 1', parent_action: parent_action, visible: true, action_group: action_group)
    child1_event = Event.create!(date: Date.current, initiative: child1, desired_team_size: 5)
    child2 = Action.create!(title: 'child 2', parent_action: parent_action, visible: true, action_group: action_group)
    child2_event = Event.create!(date: Date.current, initiative: child2, desired_team_size: 3)
    assert_equal 9, action_group.vacancy_count
    child1_event.update_attribute 'date', Date.yesterday
    assert_equal 4, action_group.vacancy_count
    child2_event.add_volunteer(users(:rolf))
    assert_equal 3, action_group.vacancy_count
    parent_event.update_attribute 'date', Date.yesterday
    assert_equal 2, action_group.vacancy_count
  end

end
