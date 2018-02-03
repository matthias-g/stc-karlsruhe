require 'test_helper'

class ActionTest < ActiveSupport::TestCase
  test "getting volunteers" do
    assert_equal 1, actions(:one).volunteers.count
    assert_equal 'sabine', actions(:one).volunteers.first.username
  end

  test "getting leaders" do
    assert_equal 2, actions(:one).leaders.count
    usernames = actions(:one).leaders.collect { |user| user.username }
    assert usernames.include? 'rolf'
    assert usernames.include? 'tabea'
  end

  test "getting volunteers in subactions" do
    volunteers = actions(:'kindergarten-party').volunteers_in_subactions
    assert_equal 2, volunteers.count
    volunteer_names = volunteers.collect { |volunteer| volunteer.username }
    assert volunteer_names.include? 'lea'
    assert volunteer_names.include? 'peter'
  end

  test "getting aggregated volunteers of action with subactions" do
    users = actions(:'kindergarten-party').aggregated_volunteers
    assert_equal 3, users.count
    usernames = users.collect { |user| user.username }
    assert usernames.include? 'lea'
    assert usernames.include? 'peter'
    assert usernames.include? 'sabine'
  end

  test "getting aggregated volunteers of action without subactions" do
    users = actions(:one).aggregated_volunteers
    assert_equal 1, users.count
    usernames = users.collect { |user| user.username }
    assert usernames.include? 'sabine'
  end

  test "getting aggregated leaders of action with subactions" do
    users = actions(:'kindergarten-party').aggregated_leaders
    assert_equal 2, users.count
    usernames = users.collect { |user| user.username }
    assert usernames.include? 'birgit'
    assert usernames.include? 'rolf'
  end

  test "getting aggregated leaders of action without subactions" do
    users = actions(:one).aggregated_leaders
    assert_equal 2, users.count
    usernames = users.collect { |user| user.username }
    assert usernames.include? 'rolf'
    assert usernames.include? 'tabea'
  end

  test "getting total_desired_team_size of action with subactions" do
    assert_equal 10, actions(:'kindergarten-party').total_desired_team_size
  end

  test "getting total_desired_team_size of action without subactions" do
    assert_equal 4, actions(:one).total_desired_team_size
  end

  test "adding volunteer" do
    assert_difference 'actions(:one).volunteers.count' do
      actions(:one).add_volunteer users(:lea)
    end
  end

  test "adding volunteer leaves action status open" do
    action = Action.create title: 'title', desired_team_size: 20
    action.save!
    assert_difference 'action.volunteers.count' do
      action.add_volunteer users(:lea)
    end
    assert action.open?
  end

  test "adding volunteer changes action status to soon full" do
    action = Action.create title: 'title', desired_team_size: 2
    action.save!
    assert_difference 'action.volunteers.count' do
      action.add_volunteer users(:lea)
    end
    assert action.soon_full?
  end

  test "adding volunteer changes action status to full" do
    action = Action.create title: 'title', desired_team_size: 1
    action.save!
    assert_difference 'action.volunteers.count' do
      action.add_volunteer users(:lea)
    end
    assert action.full?
  end

  test "has_volunteer?" do
    assert actions(:one).volunteer? users(:sabine)
    assert_not actions(:one).volunteer? users(:peter)
  end

  test "has_volunteer_in_subaction?" do
    assert actions(:'kindergarten-party').volunteer_in_subaction? users(:peter)
    assert_not actions(:'kindergarten-party').volunteer_in_subaction? users(:rolf)
    assert_not actions(:'kindergarten-party').volunteer_in_subaction? users(:sabine)
  end

  test "deleting volunteer" do
    assert_difference 'actions(:one).volunteers.count', -1 do
      actions(:one).delete_volunteer users(:sabine)
    end
  end

  test "deleting volunteer changes action status to open" do
    action = Action.create title: 'title', desired_team_size: 3
    action.save!
    action.add_volunteer users(:sabine)
    assert action.soon_full?
    assert_difference 'action.volunteers.count', -1 do
      action.delete_volunteer users(:sabine)
    end
    assert action.open?
  end

  test "deleting volunteer changes action status to soon full" do
    action = Action.create title: 'title', desired_team_size: 1
    action.save!
    action.add_volunteer users(:sabine)
    assert action.full?
    assert_difference 'action.volunteers.count', -1 do
      action.delete_volunteer users(:sabine)
    end
    assert action.soon_full?
  end

  test "deleting volunteer leaves action status open" do
    action = Action.create title: 'title', desired_team_size: 20
    action.add_volunteer users(:sabine)
    assert action.open?
    assert_difference 'action.volunteers.count', -1 do
      action.delete_volunteer users(:sabine)
    end
    assert action.open?
  end

  test "adding leader" do
    assert_difference 'actions(:one).leaders.count' do
      actions(:one).add_leader users(:lea)
    end
  end

  test "deleting leader" do
    assert_difference 'actions(:one).leaders.count', -1 do
      actions(:one).delete_leader users(:rolf)
    end
  end

  test "has_leader?" do
    assert actions(:one).leader? users(:rolf)
    assert_not actions(:one).leader? users(:lea)
  end

  test "make visible" do
    assert_not actions(:two).visible?
    actions(:two).make_visible!
    assert actions(:two).visible?
  end

  test "make invisible" do
    assert actions(:one).visible?
    actions(:one).make_invisible!
    assert_not actions(:one).visible?
  end

  test "close action without subactions" do
    assert actions(:one).open?
    actions(:one).close!
    assert actions(:one).finished?
  end

  test "close action with subactions" do
    assert actions(:'kindergarten-party').open?
    assert actions(:'kindergarten-music').open?
    assert actions(:'kindergarten-kitchen').open?
    actions(:'kindergarten-party').close!
    assert actions(:'kindergarten-party').reload.finished?
    assert actions(:'kindergarten-music').reload.finished?
    assert actions(:'kindergarten-kitchen').reload.finished?
  end

  test "open action without subactions" do
    assert actions(:closed).finished?
    actions(:closed).open!
    assert actions(:closed).open?
  end

  test "open action with subactions" do
    assert actions(:closed_parent_action).finished?
    assert actions(:closed_subaction).finished?
    actions(:closed_parent_action).open!
    assert actions(:closed_parent_action).reload.open?
    assert actions(:closed_subaction).reload.open?
  end

  test "open full action" do
    assert actions(:full_but_closed).finished?
    actions(:full_but_closed).open!
    assert actions(:full_but_closed).full?
    assert_not actions(:full_but_closed).open?
  end

  test "open soon full action" do
    assert actions(:soon_full_but_closed).finished?
    actions(:soon_full_but_closed).open!
    assert actions(:soon_full_but_closed).soon_full?
    assert_not actions(:soon_full_but_closed).open?
  end

  test "open action with subactions free, soon full, and full" do
    parent = actions(:closed)
    free_subaction = Action.create title: 'free', desired_team_size: 9, parent_action: parent, status: Action.statuses['closed']
    soon_full_subaction = Action.create title: 'soon_full', desired_team_size: 2, parent_action: parent, status: Action.statuses['closed']
    full_subaction = Action.create title: 'full', desired_team_size: 0, parent_action: parent, status: Action.statuses['closed']
    assert_equal 3, parent.subactions.count
    parent.open!
    assert parent.open?
    assert free_subaction.reload.open?
    assert soon_full_subaction.reload.soon_full?
    assert full_subaction.reload.full?
  end

  test 'adjust parent status when subaction changes' do
    parent = Action.create title: 'parent', desired_team_size: 0
    child1 = Action.create title: 'child1', desired_team_size: 9, parent_action: parent, visible: true
    child2 = Action.create title: 'child2', desired_team_size: 2, parent_action: parent, visible: true
    assert_equal 'open', parent.reload.status
    child1.close!
    assert_equal 'soon_full', parent.reload.status
  end

  test "has_free_places?" do
    assert actions(:one).free_places?
    assert_not actions(:full).free_places?
    no_team_size = Action.new title: 'test', desired_team_size: 0
    assert_not no_team_size.free_places?
  end

  test "is_subaction?" do
    assert_not actions(:one).subaction?
    assert actions(:'kindergarten-music').subaction?
    assert_not actions(:'kindergarten-party').subaction?
  end

  test "gallery is created automatically on create" do
    action = Action.create title: 'test', desired_team_size: 3
    assert_not_nil action.gallery
  end

  test "parent action cannot be same action" do
    action = actions(:one)
    assert action.valid?
    action.parent_action = actions(:one)
    assert_not action.valid?
  end

  test "parent action cannot be a subaction" do
    action = actions(:one)
    assert action.valid?
    action.parent_action = actions(:'kindergarten-kitchen')
    assert_not action.valid?
  end

  test "parsing of start and end times" do
    action = actions(:one)
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
    assert action.has_volunteer?(user)
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
    assert action.has_volunteer?(user)
  end

  test 'send notification to leaders when volunteer enters action ' do
    action = actions(:one)
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
    action = actions(:one)
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
    assert action.has_volunteer?(user)
  end

  test "dates doesn't include nil" do
    action = actions(:one)
    assert_nil action.date
    assert_not_nil action.dates
    assert_equal 0, action.dates.size
  end

end
