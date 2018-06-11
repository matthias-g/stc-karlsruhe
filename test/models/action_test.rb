require 'test_helper'

class ActionTest < ActiveSupport::TestCase

  setup do
    @action = actions(:default)
    @parent_action = actions(:parent_action)
    @subaction = actions(:subaction)
    @event = events(:default)
  end


  # BOOLEAN QUERIES

  test "leader? is true for leader" do
    assert @action.leader? users(:leader)
  end

  test "leader? is false for non-leaders" do
    assert_not @action.leader? users(:volunteer)
    assert_not @action.leader? users(:unrelated)
  end

  test "volunteer? is true for volunteer" do
    assert @action.volunteer? users(:volunteer)
  end

  test "volunteer? is false for non-volunteers" do
    assert_not @action.volunteer? users(:leader)
    assert_not @action.volunteer? users(:unrelated)
  end

  test "subaction? is true for a subaction" do
    assert @subaction.subaction?
  end

  test "subaction? is false for a non-subaction" do
    assert_not @action.subaction?
    assert_not @parent_action.subaction?
  end

  test "finished? is false for action with upcoming events" do
    assert_not @action.finished?
    assert_not @parent_action.finished?
  end

  test "finished? is true for action with only past events" do
    @event.update_attribute :date, Date.current - 1
    assert @action.reload.finished?
  end


  # LIST QUERIES

  test "volunteers includes action volunteers" do
    assert_equal [users(:volunteer), users(:ancient_user)].to_set, @action.volunteers.to_set
  end

  test "volunteers doesn't include subaction volunteers" do
    assert_empty @parent_action.volunteers
  end

  test "volunteers_in_subactions is empty for single action" do
    assert_empty @action.volunteers_in_subactions
  end

  test "volunteers_in_subactions contains subaction volunteers" do
    users = @parent_action.volunteers_in_subactions
    assert_equal Set[users(:subaction_volunteer), users(:subaction_2_volunteer)], users.to_set
  end

  test "leaders_in_subactions is empty for single action" do
    assert_empty @action.leaders_in_subactions
  end

  test "leaders_in_subactions contains subaction leaders" do
    users = @parent_action.leaders_in_subactions
    assert_equal Set[users(:subaction_leader)], users.to_set
  end


  # TEAM NUMBERS QUERIES

  test "desired_team_size includes past events" do
    assert_equal 10, @subaction.desired_team_size
  end

  test "team_size includes past events" do
    assert_equal 1, @subaction.team_size
    events(:subaction_event).update_attribute :date, Date.current - 1
    assert_equal 1, @subaction.reload.team_size
  end

  test "available_places includes only upcoming events" do
    assert_equal 9, @subaction.available_places
    events(:subaction_event).update_attribute :date, Date.current - 1
    assert_equal 5, @subaction.reload.available_places
  end

  test "total_desired_team_size == team_size for single action" do
    assert_equal @action.desired_team_size, @action.total_desired_team_size
  end

  test "total_team_size == team_size for single action" do
    assert_equal @action.team_size, @action.total_team_size
  end

  test "total_available_places == available_places for single action" do
    assert_equal @action.available_places, @action.total_available_places
  end

  test "total_desired_team_size includes visible subactions" do
    assert_equal 15, @parent_action.total_desired_team_size
  end

  test "total_team_size includes visible subactions" do
    assert_equal 2, @parent_action.total_team_size
  end

  test "total_available_places includes visible subactions" do
    assert_equal 13, @parent_action.total_available_places
  end


  # OTHER QUERIES

  test "full_title equals title for non-subactions" do
    assert_equal @action.title, @action.full_title
    assert_equal @parent_action.title, @parent_action.full_title
  end

  test "full_title includes parent action title" do
    assert_not_equal @subaction.title, @subaction.full_title
  end

  test "all_dates includes visible subaction dates" do
    assert_equal 0, @parent_action.events.count
    assert_equal 3, @parent_action.all_dates.count
  end

  test "all_events includes visible subaction events" do
    assert_equal 3, @parent_action.all_events.count
  end

  test "status is 'finished' for past action" do
    @event.update_attribute :date, Date.current - 1
    assert_equal :finished, @action.reload.status
  end

  test "status is 'full' for full action" do
    @event.update_attribute :desired_team_size, @event.volunteers.count
    assert_equal :full, @action.reload.status
  end

  test "status is 'soon_full' for action with < 3 places" do
    @event.update_attribute :desired_team_size, 3
    assert_equal :soon_full, @action.reload.status
  end

  test "status is 'empty' for action with >= 3 places" do
    assert_equal :empty, @action.status
  end

  test "date is not nil for action with multiple events" do
    action = actions(:subaction)
    assert_operator action.events.count, :>, 1
    assert_not_nil action.date
  end

  test "date is not nil for action without events" do
    action = actions(:without_events)
    assert_equal 0, action.events.count
    assert_nil action.date
  end



  # SETTERS

  test "add_leader adds a leader" do
    assert_difference '@action.leaders.count', +1 do
      @action.add_leader users(:unrelated)
    end
    assert_includes @action.leaders, users(:unrelated)
  end

  test "delete_leader removes a leader" do
    assert_difference '@action.leaders.count', -1 do
      @action.delete_leader users(:leader)
    end
    assert_not_includes @action.leaders, users(:leader)
  end

  test "make_visible! makes an action visible" do
    action = actions(:subaction_3_invisible)
    action.make_visible!
    assert action.visible?
  end

  test "make_invisible! makes an action invisible" do
    @action.make_invisible!
    assert_not @action.visible?
  end



  # OTHER METHODS

  test "clone prepends 'Copy of' to title" do
    assert_equal I18n.t('general.label.copyOf', title: @action.title), @action.clone.title
  end

  test "clone doesn't clone subactions" do
    assert @parent_action.clone.subactions.empty?
  end

  test "clone drops parent action association" do
    assert_not @subaction.clone.subaction?
  end

  test "clone (or destroying a clone) doesn't affect original" do
    leaders_count = @action.leaders.count
    events_count = @action.events.count
    assert_not_nil @action.gallery
    @action.clone.destroy!
    @action.reload
    assert_equal leaders_count, @action.leaders.count
    assert_equal events_count, @action.events.count
    assert_not_nil @action.gallery
  end



  # HOOKS AND VALIDATIONS

  test "gallery is created automatically on create" do
    action = Action.create!(title: 'test', action_group: action_groups(:default))
    assert_not_nil action.gallery
  end

  test "parent action cannot be same action" do
    @action.parent_action = @action
    assert_not @action.valid?
  end

  test "parent action cannot be a subaction" do
    @parent_action.parent_action = @subaction
    assert_not @parent_action.valid?
  end

end
