require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:one)
  end

  test 'volunteer should enter event' do
    user = users(:peter)
    sign_in user
    assert_not @event.volunteer?(user)
    get enter_event_url(@event)
    @event = Event.find(@event.id)
    assert_redirected_to action_path(@event.initiative)
    assert @event.volunteer?(user)
  end

  test 'volunteer should leave event' do
    user = users(:peter)
    sign_in user
    @event.add_volunteer(user)
    assert @event.volunteer?(user)
    get leave_event_url(@event)
    assert_redirected_to @event.initiative
    assert_not @event.volunteer?(user)
    assert User.exists?(user.id)
  end

  test 'send notification when volunteer leaves event' do
    user = users(:peter)
    sign_in user
    @event.add_volunteer(user)
    assert @event.volunteer?(user)
    assert_changes 'ActionMailer::Base.deliveries.size' do
      get leave_event_url(@event)
    end
    assert_redirected_to @event.initiative
    assert_not @event.volunteer?(user)
  end
end