require 'test_helper'

class ActionTest < ActiveSupport::TestCase

  setup do
    Action.all.each(&:save!)
  end

  test 'getting volunteers' do
    assert_equal 1, actions(:one).volunteers.count
    assert_equal 'sabine', actions(:one).volunteers.first.username
  end

  test 'getting leaders' do
    assert_equal 2, actions(:one).leaders.count
    names = actions(:one).leaders.collect(&:username)
    assert names.include? 'rolf'
    assert names.include? 'tabea'
  end

  test 'getting volunteers in subactions' do
    users = actions(:'kindergarten-party').volunteers_in_subactions
    assert_equal 2, users.count
    names = users.collect(&:username)
    assert names.include? 'lea'
    assert names.include? 'peter'
  end

  test 'getting aggregated volunteers of action with subactions' do
    users = actions(:'kindergarten-party').aggregated_volunteers
    assert_equal 3, users.count
    names = users.collect(&:username)
    assert names.include? 'lea'
    assert names.include? 'peter'
    assert names.include? 'sabine'
  end

  test 'getting aggregated volunteers of action without subactions' do
    users = actions(:one).aggregated_volunteers
    assert_equal 1, users.count
    assert users.collect(&:username).include? 'sabine'
  end

  test 'getting aggregated leaders of action with subactions' do
    users = actions(:'kindergarten-party').aggregated_leaders
    assert_equal 2, users.count
    names = users.collect(&:username)
    assert names.include? 'birgit'
    assert names.include? 'rolf'
  end

  test 'getting aggregated leaders of action without subactions' do
    users = actions(:one).aggregated_leaders
    assert_equal 2, users.count
    names = users.collect(&:username)
    assert names.include? 'rolf'
    assert names.include? 'tabea'
  end

  test 'getting total_desired_team_size of action with subactions' do
    assert_equal 10, actions(:'kindergarten-party').total_desired_team_size
  end

  test 'getting total_desired_team_size of action without subactions' do
    assert_equal actions(:one).desired_team_size, actions(:one).total_desired_team_size
  end

  test 'adding volunteer' do
    assert_difference 'actions(:one).volunteers.count' do
      actions(:one).add_volunteer users(:lea)
    end
  end

  test 'adding volunteer leaves action status empty' do
    action = Action.create title: 'title', desired_team_size: 20, date: Date.today
    action.save!
    assert_difference 'action.volunteers.count' do
      action.add_volunteer users(:lea)
    end
    assert_equal :empty, action.status
  end

  test 'adding volunteer changes action status to soon full' do
    action = Action.create title: 'title', desired_team_size: 2, date: Date.today
    action.save!
    assert_difference 'action.volunteers.count' do
      action.add_volunteer users(:lea)
    end
    assert_equal :soon_full, action.status
  end

  test 'adding volunteer changes action status to full' do
    action = Action.create title: 'title', desired_team_size: 1, date: Date.today
    action.save!
    assert_difference 'action.volunteers.count' do
      action.add_volunteer users(:lea)
    end
    assert_equal :full, action.status
  end

  test 'volunteer?' do
    assert actions(:one).volunteer? users(:sabine)
    assert_not actions(:one).volunteer? users(:peter)
  end

  test 'deleting volunteer' do
    assert_difference 'actions(:one).volunteers.count', -1 do
      actions(:one).delete_volunteer users(:sabine)
    end
  end

  test 'deleting volunteer changes action status to empty' do
    action = Action.create title: 'title', desired_team_size: 3, date: Date.today
    action.save!
    action.add_volunteer users(:sabine)
    assert_equal :soon_full, action.status
    assert_difference 'action.volunteers.count', -1 do
      action.delete_volunteer users(:sabine)
    end
    assert_equal :empty, action.status
  end

  test 'deleting volunteer changes action status to soon full' do
    action = Action.create title: 'title', desired_team_size: 1, date: Date.today
    action.save!
    action.add_volunteer users(:sabine)
    assert_equal :full, action.status
    assert_difference 'action.volunteers.count', -1 do
      action.delete_volunteer users(:sabine)
    end
    assert_equal :soon_full, action.status
  end

  test 'deleting volunteer leaves action status empty' do
    action = Action.create title: 'title', desired_team_size: 20, date: Date.today
    action.add_volunteer users(:sabine)
    assert_equal :empty, action.status
    assert_difference 'action.volunteers.count', -1 do
      action.delete_volunteer users(:sabine)
    end
    assert_equal :empty, action.status
  end

  test 'adding leader' do
    assert_difference 'actions(:one).leaders.count' do
      actions(:one).add_leader users(:lea)
    end
  end

  test 'deleting leader' do
    assert_difference 'actions(:one).leaders.count', -1 do
      actions(:one).delete_leader users(:rolf)
    end
  end

  test 'leader?' do
    assert actions(:one).leader? users(:rolf)
    assert_not actions(:one).leader? users(:lea)
  end

  test 'make visible' do
    assert_not actions(:two).visible?
    actions(:two).make_visible!
    assert actions(:two).visible?
  end

  test 'make invisible' do
    assert actions(:one).visible?
    actions(:one).make_invisible!
    assert_not actions(:one).visible?
  end

  test 'adding sub actions affects "total_ method" and "status" returns' do
    parent = Action.create title: 'parent', desired_team_size: 0, date: Date.today
    assert_equal 0, parent.total_desired_team_size
    assert_equal 0, parent.total_team_size
    assert_equal 0, parent.total_free_places
    assert_equal :full, parent.status

    child1 = Action.create title: 'child1', desired_team_size: 9, parent_action: parent, visible: true, date: Date.today
    child2 = Action.create title: 'child2', desired_team_size: 2, parent_action: parent, visible: true, date: Date.today
    parent = parent.reload
    assert_equal 11, parent.total_desired_team_size
    assert_equal 0, parent.total_team_size
    assert_equal 11, parent.total_free_places
    assert_equal :empty, parent.status

    child1.update_attribute 'date', Date.yesterday
    assert_equal 11, parent.total_desired_team_size
    assert_equal 0, parent.total_team_size
    assert_equal 2, parent.total_free_places
    assert_equal :soon_full, parent.status
  end

  test 'free_places' do
    assert_equal 3, actions(:one).free_places
    assert_equal 0, actions(:full).free_places
    no_team_size = Action.new title: 'test', desired_team_size: 0
    assert_equal 0, no_team_size.free_places
  end

  test 'subaction?' do
    assert_not actions(:one).subaction?
    assert actions(:'kindergarten-music').subaction?
    assert_not actions(:'kindergarten-party').subaction?
  end

  test 'gallery is created automatically on create' do
    action = Action.create title: 'test', desired_team_size: 3
    assert_not_nil action.gallery
  end

  test 'parent action cannot be same action' do
    action = actions(:one)
    assert action.valid?
    action.parent_action = actions(:one)
    assert_not action.valid?
  end

  test 'parent action cannot be a subaction' do
    action = actions(:one)
    assert action.valid?
    action.parent_action = actions(:'kindergarten-kitchen')
    assert_not action.valid?
  end

  test 'parsing of start and end times' do
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
    assert action.volunteer?(user)
  end

  test "dates doesn't include nil" do
    action = actions(:undated)
    assert_nil action.date
    assert_not_nil action.dates
    assert_equal 0, action.dates.size
  end

end
