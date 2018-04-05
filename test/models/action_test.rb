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

  test 'volunteer?' do
    assert @action.volunteer? users(:sabine)
    assert_not @action.volunteer? users(:peter)
  end

  test 'add_volunteer' do
    assert_difference '@action.volunteers.count', +1 do
      @action.add_volunteer users(:lea)
    end
    assert_equal @action.team_size, @action.volunteers.count
  end

  test 'delete_volunteer' do
    assert_difference '@action.volunteers.count', -1 do
      @action.delete_volunteer users(:sabine)
    end
    assert_equal @action.team_size, @action.volunteers.count
  end

  test 'volunteers' do
    assert_equal 1, @action.volunteers.count
    assert_equal 'sabine', @action.volunteers.first.username
  end

  test 'leaders' do
    assert_equal 2, @action.leaders.count
    names = @action.leaders.collect(&:username)
    assert names.include? 'rolf'
    assert names.include? 'tabea'
  end

  test 'volunteers_in_subactions' do
    # single action
    assert_empty @action.volunteers_in_subactions
    # parent action
    users = @parent_action.volunteers_in_subactions
    assert_equal 2, users.count
    names = users.collect(&:username)
    assert names.include? 'lea'
    assert names.include? 'peter'
  end

  test 'aggregated_volunteers' do
    # single action
    users = @action.aggregated_volunteers
    assert_equal 1, users.count
    assert users.collect(&:username).include? 'sabine'
    # parent action
    users = @parent_action.aggregated_volunteers
    assert_equal 3, users.count
    names = users.collect(&:username)
    assert names.include? 'lea'
    assert names.include? 'peter'
    assert names.include? 'sabine'
  end

  test 'aggregated_leaders' do
    # single action
    users = @action.aggregated_leaders
    assert_equal 2, users.count
    names = users.collect(&:username)
    assert names.include? 'rolf'
    assert names.include? 'tabea'
    # parent action
    users = @parent_action.aggregated_leaders
    assert_equal 2, users.count
    names = users.collect(&:username)
    assert names.include? 'birgit'
    assert names.include? 'rolf'
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

  test 'free_places' do
    assert_equal 3, @action.available_places
    @action.add_volunteer users(:lea)
    assert_equal 2, @action.available_places
    assert_equal 0, actions(:full).available_places
    no_team_size = Action.new title: 'test', desired_team_size: 0
    assert_equal 0, no_team_size.available_places
  end

  test 'subaction?' do
    assert_not @action.subaction?
    assert_not @parent_action.subaction?
    assert actions(:'kindergarten-music').subaction?
  end

  test 'finished?' do
    assert_not @action.finished?
    @action.update_attribute :date, Date.yesterday
    assert @action.finished?
  end

  test 'gallery' do
    action = Action.create title: 'test', desired_team_size: 3
    assert_not_nil action.gallery
  end

  test 'status' do
    # single action
    action = Action.create title: 'title', desired_team_size: 3, date: Date.today
    assert_equal :empty, action.status
    action.add_volunteer users(:lea)
    assert_equal :soon_full, action.status
    action.update_attribute :desired_team_size, 1
    assert_equal :full, action.status
    action.delete_volunteer users(:lea)
    assert_equal :soon_full, action.status
    action.update_attribute :date, Date.yesterday
    assert_equal :finished, action.status
  end

  test 'full_title' do
    # single action
    assert_equal @action.title, @action.full_title
    # parent action
    assert_equal @parent_action.title, @parent_action.full_title
    # child action
    assert_not_equal actions(:'kindergarten-music').title, actions(:'kindergarten-music').full_title
  end

  test 'total_team_size and total_free_places and total_desired_places and status' do
    # parent action
    parent = Action.create title: 'parent', desired_team_size: 0, date: Date.today
    assert_equal 0, parent.total_desired_team_size
    assert_equal 0, parent.total_team_size
    assert_equal 0, parent.total_available_places
    assert_equal :full, parent.status

    child1 = Action.create title: 'child1', desired_team_size: 9, parent_action: parent, visible: true, date: Date.today
    child2 = Action.create title: 'child2', desired_team_size: 2, parent_action: parent, visible: true, date: Date.today
    parent = parent.reload
    assert_equal 11, parent.total_desired_team_size
    assert_equal 0, parent.total_team_size
    assert_equal 11, parent.total_available_places
    assert_equal :empty, parent.status

    child1.update_attribute 'date', Date.yesterday
    assert_equal 11, parent.total_desired_team_size
    assert_equal 0, parent.total_team_size
    assert_equal 2, parent.total_free_places
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

  test 'parsing of start and end times' do
    action = @action
    assert_nil action.start_time
    assert_nil action.end_time
    action.date = '2017-05-13'
    action.time = '10:00 - 17:00 Uhr'

    assert_equal action.date.year, action.start_time.year
    assert_equal action.date.month, action.start_time.month
    assert_equal action.date.day, action.start_time.day
    assert_equal action.date.year, action.end_time.year
    assert_equal action.date.month, action.end_time.month
    assert_equal action.date.day, action.end_time.day
    assert_equal 10, action.start_time.hour
    assert_equal 0, action.start_time.min
    assert_equal 17, action.end_time.hour
    assert_equal 0, action.end_time.min

    action.time = '10:30 - 17:45 Uhr'
    assert_equal 10, action.start_time.hour
    assert_equal 30, action.start_time.min
    assert_equal 17, action.end_time.hour
    assert_equal 45, action.end_time.min

    action.time = '10:30 - 17:45'
    assert_equal 10, action.start_time.hour
    assert_equal 30, action.start_time.min
    assert_equal 17, action.end_time.hour
    assert_equal 45, action.end_time.min

    action.time = '10:30 bis 17:45'
    assert_equal 10, action.start_time.hour
    assert_equal 30, action.start_time.min
    assert_equal 17, action.end_time.hour
    assert_equal 45, action.end_time.min

    action.time = '10:30-17:45'
    assert_equal 10, action.start_time.hour
    assert_equal 30, action.start_time.min
    assert_equal 17, action.end_time.hour
    assert_equal 45, action.end_time.min

    action.time = '10.30 - 17-45'
    assert_equal 10, action.start_time.hour
    assert_equal 30, action.start_time.min
    assert_equal 17, action.end_time.hour
    assert_equal 45, action.end_time.min

    action.time = '17:00 - ca. 19:00 Uhr'
    assert_equal 17, action.start_time.hour
    assert_equal 00, action.start_time.min
    assert_equal 19, action.end_time.hour
    assert_equal 00, action.end_time.min

    action.time = 'zwischen 14:00 - 21:00 Uhr '
    assert_equal 14, action.start_time.hour
    assert_equal 00, action.start_time.min
    assert_equal 21, action.end_time.hour
    assert_equal 00, action.end_time.min

    action.time = 'Zwischen 12 und 16 Uhr'
    assert_equal 12, action.start_time.hour
    assert_equal 00, action.start_time.min
    assert_equal 16, action.end_time.hour
    assert_equal 00, action.end_time.min

    action.time = '17:30'
    assert_equal 17, action.start_time.hour
    assert_equal 30, action.start_time.min
    assert_nil action.end_time

    action.time = 'Montag 19 Uhr / Mittwoch + Samstag 11 Uhr'
    assert_equal 19, action.start_time.hour
    assert_equal 00, action.start_time.min
    assert_nil action.end_time
  end

  test 'send notification to volunteer when volunteer enters action ' do
    action = actions(:two)
    user = users(:peter)
    assert_not action.volunteer?(user)
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      action.add_volunteer(user)
    end
    assert action.volunteer?(user)
  end

  test "don't send notification to volunteer when volunteer enters action when user doesn't want that" do
    action = actions(:two)
    user = users(:peter)
    user.receive_notifications_for_new_participation = false
    user.save!
    assert_not action.volunteer?(user)
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      action.add_volunteer(user)
    end
    assert action.volunteer?(user)
  end

  test 'send notification to leaders when volunteer enters action ' do
    action = @action
    user = users(:peter)
    user.receive_notifications_for_new_participation = false
    user.save!
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      action.add_volunteer(user)
    end
    notification_email = ActionMailer::Base.deliveries.last
    assert_equal action.leaders.first.email, notification_email.bcc.first
  end

  test "don't send notification to leader when volunteer enters action when user doesn't want that" do
    action = @action
    user = users(:peter)
    user.receive_notifications_for_new_participation = false
    user.save!
    action.leaders.each do |leader|
      leader.receive_notifications_about_volunteers = false
      leader.save!
    end
    assert_not action.volunteer?(user)
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      action.add_volunteer(user)
    end
    assert action.volunteer?(user)
  end

end
