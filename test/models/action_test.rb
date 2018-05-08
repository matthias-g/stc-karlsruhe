require 'test_helper'

class ActionTest < ActiveSupport::TestCase

  setup do
    @action = actions(:one)
    @parent_action = actions(:'kindergarten-party')
  end

  test 'leader?' do
    assert @action.leader? users(:rolf)
    assert_not @action.leader? users(:lea)
  end

  test 'add_leader' do
    assert_difference '@action.leaders.count' do
      @action.add_leader users(:lea)
    end
  end

  test 'delete_leader' do
    assert_difference '@action.leaders.count', -1 do
      @action.delete_leader users(:rolf)
    end
  end

  test 'leaders' do
    assert_equal 2, @action.leaders.count
    names = @action.leaders.pluck(:username)
    assert names.include? 'rolf'
    assert names.include? 'tabea'
  end

  test 'volunteers_in_subactions' do
    # single action
    assert_empty @action.volunteers_in_subactions
    # parent action
    users = @parent_action.volunteers_in_subactions
    assert_equal 2, users.count
    names = users.pluck(:username)
    assert names.include? 'lea'
    assert names.include? 'peter'
  end

  test 'total_desired_team_size' do
    # single action
    assert_equal @action.desired_team_size, @action.total_desired_team_size
    # parent action
    assert_equal 10, @parent_action.total_desired_team_size
  end

  test 'make_visible!' do
    assert_not actions(:two).visible?
    actions(:two).make_visible!
    assert actions(:two).visible?
  end

  test 'make_invisible!' do
    assert @action.visible?
    @action.make_invisible!
    assert_not @action.visible?
  end

  test 'subaction?' do
    assert_not @action.subaction?
    assert_not @parent_action.subaction?
    assert actions(:'kindergarten-music').subaction?
  end

  test 'gallery' do
    action = Action.create title: 'test'
    assert_not_nil action.gallery
  end

  test 'full_title' do
    # single action
    assert_equal @action.title, @action.full_title
    # parent action
    assert_equal @parent_action.title, @parent_action.full_title
    # child action
    assert_not_equal actions(:'kindergarten-music').title, actions(:'kindergarten-music').full_title
  end

  test 'clone' do
    # single action
    assert_equal I18n.t('general.label.copyOf', title: @action.title), @action.clone.title
    # parent action
    assert @parent_action.clone.subactions.empty?
    # child action
    assert actions(:'kindergarten-music').clone.parent_action.nil?
  end

  test 'total_team_size and total_available_places and total_desired_places and status' do
    parent = Action.create(title: 'parent')
    parent_event = Event.create(desired_team_size: 0, date: Date.current, initiative: parent)
    parent.reload
    assert_equal 0, parent.total_desired_team_size
    assert_equal 0, parent.total_team_size
    assert_equal 0, parent.total_available_places
    assert_equal :full, parent.status

    child1 = Action.create(title: 'child1', parent_action: parent, visible: true)
    child1_event = Event.create(desired_team_size: 9, date: Date.current, initiative: child1)
    child2 = Action.create(title: 'child2', parent_action: parent, visible: true)
    child2_event = Event.create(desired_team_size: 2, date: Date.current, initiative: child2)
    parent.reload
    assert_equal 11, parent.total_desired_team_size
    assert_equal 0, parent.total_team_size
    assert_equal 11, parent.total_available_places
    assert_equal :empty, parent.status

    child1_event.update_attribute 'date', Date.yesterday
    assert_equal 11, parent.total_desired_team_size
    assert_equal 0, parent.total_team_size
    assert_equal 2, parent.total_available_places
    assert_equal :soon_full, parent.status
  end

  test 'parent action cannot be same action' do
    assert @action.valid?
    @action.parent_action = @action
    assert_not @action.valid?
  end

  test 'parent action cannot be a subaction' do
    assert @action.valid?
    @action.parent_action = actions(:'kindergarten-kitchen')
    assert_not @action.valid?
  end

  test "dates doesn't include nil" do
    action = actions(:undated)
    assert_nil action.date
    assert_not_nil action.dates
    assert_equal 0, action.dates.size
  end

end
