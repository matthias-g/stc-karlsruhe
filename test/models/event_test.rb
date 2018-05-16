require 'test_helper'

class EventTest < ActiveSupport::TestCase

  setup do
    @event = events(:one)
  end

  test 'volunteer?' do
    assert @event.volunteer? users(:sabine)
    assert_not @event.volunteer? users(:peter)
  end

  test 'add_volunteer' do
    assert_difference '@event.volunteers.count', +1 do
      @event.add_volunteer users(:lea)
    end
    assert_equal @event.team_size, @event.volunteers.count
  end

  test 'delete_volunteer' do
    assert_difference '@event.volunteers.count', -1 do
      @event.delete_volunteer users(:sabine)
    end
    assert_equal @event.team_size, @event.volunteers.count
  end

  test 'volunteers' do
    assert_equal 1, @event.volunteers.count
    assert_equal 'sabine', @event.volunteers.first.username
  end

  test 'available_places' do
    assert_equal 3, @event.available_places
    @event.add_volunteer users(:lea)
    assert_equal 2, @event.available_places
    assert_equal 0, events(:full).available_places
    no_team_size = Event.new(desired_team_size: 0)
    assert_equal 0, no_team_size.available_places
  end

  test 'finished?' do
    assert_not @event.finished?
    @event.update_attribute :date, Date.yesterday
    assert @event.finished?
  end

  test 'status' do
    # single event
    event = Event.create(desired_team_size: 3, date: Date.current, initiative: actions(:one))
    assert_equal :empty, event.status
    event.add_volunteer users(:lea)
    assert_equal :soon_full, event.status
    event.update_attribute :desired_team_size, 1
    assert_equal :full, event.status
    event.delete_volunteer users(:lea)
    assert_equal :soon_full, event.status
    event.update_attribute :date, Date.yesterday
    assert_equal :finished, event.status
  end


  test 'send notification to volunteer when volunteer enters event ' do
    event = events(:two)
    user = users(:peter)
    assert_not event.volunteer?(user)
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      event.add_volunteer(user)
    end
    assert event.volunteer?(user)
  end

  test "don't send notification to volunteer when volunteer enters event when user doesn't want that" do
    event = events(:two)
    user = users(:peter)
    user.receive_notifications_for_new_participation = false
    user.save!
    assert_not event.volunteer?(user)
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      event.add_volunteer(user)
    end
    assert event.volunteer?(user)
  end

  test 'send notification to leaders when volunteer enters event ' do
    event = @event
    user = users(:peter)
    user.receive_notifications_for_new_participation = false
    user.save!
    assert_changes 'ActionMailer::Base.deliveries.size' do
      event.add_volunteer(user)
    end
    notification_email = ActionMailer::Base.deliveries.last
    assert event.initiative.leaders.pluck(:email).to_set.superset? notification_email.to.to_set
  end

  test "don't send notification to leader when volunteer enters event when user doesn't want that" do
    event = @event
    user = users(:peter)
    user.receive_notifications_for_new_participation = false
    user.save!
    event.initiative.leaders.each do |leader|
      leader.receive_notifications_about_volunteers = false
      leader.save!
    end
    assert_not event.volunteer?(user)
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      event.add_volunteer(user)
    end
    assert event.volunteer?(user)
  end

  test 'parsing of start and end times' do
    event = @event
    assert_nil event.start_time
    assert_nil event.end_time
    event.date = '2017-05-13'
    event.time = '10:00 - 17:00 Uhr'

    assert_equal event.date.year, event.start_time.year
    assert_equal event.date.month, event.start_time.month
    assert_equal event.date.day, event.start_time.day
    assert_equal event.date.year, event.end_time.year
    assert_equal event.date.month, event.end_time.month
    assert_equal event.date.day, event.end_time.day
    assert_equal 10, event.start_time.hour
    assert_equal 0, event.start_time.min
    assert_equal 17, event.end_time.hour
    assert_equal 0, event.end_time.min

    event.time = '10:30 - 17:45 Uhr'
    assert_equal 10, event.start_time.hour
    assert_equal 30, event.start_time.min
    assert_equal 17, event.end_time.hour
    assert_equal 45, event.end_time.min

    event.time = '10:30 - 17:45'
    assert_equal 10, event.start_time.hour
    assert_equal 30, event.start_time.min
    assert_equal 17, event.end_time.hour
    assert_equal 45, event.end_time.min

    event.time = '10:30 bis 17:45'
    assert_equal 10, event.start_time.hour
    assert_equal 30, event.start_time.min
    assert_equal 17, event.end_time.hour
    assert_equal 45, event.end_time.min

    event.time = '10:30-17:45'
    assert_equal 10, event.start_time.hour
    assert_equal 30, event.start_time.min
    assert_equal 17, event.end_time.hour
    assert_equal 45, event.end_time.min

    event.time = '10.30 - 17-45'
    assert_equal 10, event.start_time.hour
    assert_equal 30, event.start_time.min
    assert_equal 17, event.end_time.hour
    assert_equal 45, event.end_time.min

    event.time = '17:00 - ca. 19:00 Uhr'
    assert_equal 17, event.start_time.hour
    assert_equal 00, event.start_time.min
    assert_equal 19, event.end_time.hour
    assert_equal 00, event.end_time.min

    event.time = '17-19:30 Uhr'
    assert_equal 17, event.start_time.hour
    assert_equal 00, event.start_time.min
    assert_equal 19, event.end_time.hour
    assert_equal 30, event.end_time.min

    event.time = '17:30-19 Uhr'
    assert_equal 17, event.start_time.hour
    assert_equal 30, event.start_time.min
    assert_equal 19, event.end_time.hour
    assert_equal 00, event.end_time.min

    event.time = 'zwischen 14:00 - 21:00 Uhr '
    assert_equal 14, event.start_time.hour
    assert_equal 00, event.start_time.min
    assert_equal 21, event.end_time.hour
    assert_equal 00, event.end_time.min

    event.time = 'Zwischen 12 und 16 Uhr'
    assert_equal 12, event.start_time.hour
    assert_equal 00, event.start_time.min
    assert_equal 16, event.end_time.hour
    assert_equal 00, event.end_time.min

    event.time = '17:30'
    assert_equal 17, event.start_time.hour
    assert_equal 30, event.start_time.min
    assert_nil event.end_time

    event.time = 'Montag 19 Uhr / Mittwoch + Samstag 11 Uhr'
    assert_equal 19, event.start_time.hour
    assert_equal 00, event.start_time.min
    assert_nil event.end_time
  end

end