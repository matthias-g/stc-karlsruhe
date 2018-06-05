require 'test_helper'

class EventTest < ActiveSupport::TestCase

  setup do
    @event = events(:default)
  end


  # BOOLEAN QUERIES

  test "volunteer? is true for volunteer" do
    assert @event.volunteer? users(:volunteer)
  end

  test "volunteer? is false for non-volunteers" do
    assert_not @event.volunteer? users(:unrelated)
    assert_not @event.volunteer? users(:leader)
  end

  test "finished? is false for upcoming event" do
    assert_not @event.finished?
  end

  test "finished? is true for past event" do
    @event.update_attribute :date, Date.current - 1
    assert @event.finished?
  end


  # LIST QUERIES

  test "volunteers includes all volunteers" do
    assert_equal Set[users(:volunteer), users(:ancient_user)], @event.volunteers.to_set
  end


  # TEAM NUMBERS QUERIES

  test "available_places excludes taken places" do
    assert_equal @event.desired_team_size - @event.volunteers.count, @event.available_places
  end

  test "available_places is zero for past event" do
    @event.update_attribute :date, Date.current - 1
    assert_equal 0, @event.available_places
  end


  # OTHER QUERIES

  test "status is 'finished' for past event" do
    @event.update_attribute :date, Date.current - 1
    assert_equal :finished, @event.status
  end

  test "status is 'full' for full action" do
    @event.update_attribute :desired_team_size, @event.volunteers.count
    assert_equal :full, @event.status
  end

  test "status is 'soon_full' for action with < 3 places" do
    @event.update_attribute :desired_team_size, 3
    assert_equal :soon_full, @event.status
  end

  test "status is 'empty' for action with >= 3 places" do
    assert_equal :empty, @event.status
  end



  # SETTERS

  test "add_volunteer" do
    assert_difference '@event.volunteers.count', +1 do
      @event.add_volunteer users(:unrelated)
    end
    assert_equal 3, @event.volunteers.count
    assert_equal 3, @event.team_size
  end

  test "delete_volunteer" do
    assert_difference '@event.volunteers.count', -1 do
      @event.delete_volunteer users(:volunteer)
    end
    assert_equal 1, @event.volunteers.count
    assert_equal 1, @event.team_size
  end



  # HOOKS AND VALIDATIONS

  test "send notification to volunteer when volunteer enters event" do
    user = users(:unrelated)
    assert_difference 'ActionMailer::Base.deliveries.size', +2 do
      perform_enqueued_jobs do
        @event.add_volunteer user
      end
    end
    assert @event.volunteer?(user)
  end

  test "don't send notification to volunteer when volunteer enters event when user doesn't want that" do
    user = users(:unrelated)
    user.update_attribute :receive_notifications_for_new_participation, false
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      perform_enqueued_jobs do
        @event.add_volunteer user
      end
    end
    assert @event.volunteer?(user)
  end

  test "send notification to leaders when volunteer enters event" do
    leaders = @event.initiative.leaders.pluck(:email).to_set
    user = users(:unrelated)
    user.update_attribute :receive_notifications_for_new_participation, false
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      perform_enqueued_jobs do
        @event.add_volunteer user
      end
    end
    notification_email = ActionMailer::Base.deliveries.last
    assert leaders.superset? notification_email.to.to_set
  end

  test "don't send notification to leader when volunteer enters event when user doesn't want that" do
    user = users(:unrelated)
    user.update_attribute :receive_notifications_for_new_participation, false
    leader = users(:leader)
    leader.update_attribute :receive_notifications_about_volunteers, false
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      @event.add_volunteer user
    end
    assert @event.volunteer?(user)
  end

  test "parsing of start and end times" do
    event = @event
    assert_nil event.send(:parse_start_time)
    assert_nil event.send(:parse_end_time)
    event.date = '2017-05-13'
    event.time = '10:00 - 17:00 Uhr'

    assert_equal event.date.year, event.send(:parse_start_time).year
    assert_equal event.date.month, event.send(:parse_start_time).month
    assert_equal event.date.day, event.send(:parse_start_time).day
    assert_equal event.date.year, event.send(:parse_end_time).year
    assert_equal event.date.month, event.send(:parse_end_time).month
    assert_equal event.date.day, event.send(:parse_end_time).day
    assert_equal 10, event.send(:parse_start_time).hour
    assert_equal 0, event.send(:parse_start_time).min
    assert_equal 17, event.send(:parse_end_time).hour
    assert_equal 0, event.send(:parse_end_time).min

    event.time = '10:30 - 17:45 Uhr'
    assert_equal 10, event.send(:parse_start_time).hour
    assert_equal 30, event.send(:parse_start_time).min
    assert_equal 17, event.send(:parse_end_time).hour
    assert_equal 45, event.send(:parse_end_time).min

    event.time = '10:30 - 17:45'
    assert_equal 10, event.send(:parse_start_time).hour
    assert_equal 30, event.send(:parse_start_time).min
    assert_equal 17, event.send(:parse_end_time).hour
    assert_equal 45, event.send(:parse_end_time).min

    event.time = '10:30 bis 17:45'
    assert_equal 10, event.send(:parse_start_time).hour
    assert_equal 30, event.send(:parse_start_time).min
    assert_equal 17, event.send(:parse_end_time).hour
    assert_equal 45, event.send(:parse_end_time).min

    event.time = '10:30-17:45'
    assert_equal 10, event.send(:parse_start_time).hour
    assert_equal 30, event.send(:parse_start_time).min
    assert_equal 17, event.send(:parse_end_time).hour
    assert_equal 45, event.send(:parse_end_time).min

    event.time = '10.30 - 17-45'
    assert_equal 10, event.send(:parse_start_time).hour
    assert_equal 30, event.send(:parse_start_time).min
    assert_equal 17, event.send(:parse_end_time).hour
    assert_equal 45, event.send(:parse_end_time).min

    event.time = '17:00 - ca. 19:00 Uhr'
    assert_equal 17, event.send(:parse_start_time).hour
    assert_equal 00, event.send(:parse_start_time).min
    assert_equal 19, event.send(:parse_end_time).hour
    assert_equal 00, event.send(:parse_end_time).min

    event.time = '17-19:30 Uhr'
    assert_equal 17, event.send(:parse_start_time).hour
    assert_equal 00, event.send(:parse_start_time).min
    assert_equal 19, event.send(:parse_end_time).hour
    assert_equal 30, event.send(:parse_end_time).min

    event.time = '17:30-19 Uhr'
    assert_equal 17, event.send(:parse_start_time).hour
    assert_equal 30, event.send(:parse_start_time).min
    assert_equal 19, event.send(:parse_end_time).hour
    assert_equal 00, event.send(:parse_end_time).min

    event.time = 'zwischen 14:00 - 21:00 Uhr '
    assert_equal 14, event.send(:parse_start_time).hour
    assert_equal 00, event.send(:parse_start_time).min
    assert_equal 21, event.send(:parse_end_time).hour
    assert_equal 00, event.send(:parse_end_time).min

    event.time = 'Zwischen 12 und 16 Uhr'
    assert_equal 12, event.send(:parse_start_time).hour
    assert_equal 00, event.send(:parse_start_time).min
    assert_equal 16, event.send(:parse_end_time).hour
    assert_equal 00, event.send(:parse_end_time).min

    event.time = '17:30'
    assert_equal 17, event.send(:parse_start_time).hour
    assert_equal 30, event.send(:parse_start_time).min
    assert_nil event.send(:parse_end_time)

    event.time = 'Montag 19 Uhr / Mittwoch + Samstag 11 Uhr'
    assert_equal 19, event.send(:parse_start_time).hour
    assert_equal 00, event.send(:parse_start_time).min
    assert_nil event.send(:parse_end_time)
  end

end