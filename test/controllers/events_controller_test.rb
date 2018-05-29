require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:default)
  end

  test "volunteer should enter event" do
    user = users(:unrelated)
    sign_in user
    get enter_event_url(@event)
    assert_redirected_to @event.reload.initiative
    assert @event.volunteer?(user)
  end

  test "volunteer should leave event" do
    user = users(:volunteer)
    sign_in user
    get leave_event_url(@event)
    assert_redirected_to @event.reload.initiative
    assert_not @event.volunteer?(user)
    assert User.exists?(user.id)
  end

  test "send notification when volunteer leaves event" do
    user = users(:volunteer)
    sign_in user
    assert_changes 'ActionMailer::Base.deliveries.size' do
      get leave_event_url(@event)
    end
    assert_redirected_to @event.reload.initiative
    assert_not @event.volunteer?(user)
  end
end