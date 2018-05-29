require 'test_helper'

class ActionGroupTest < ActiveSupport::TestCase

  setup do
    @action_group = action_groups(:default)
  end


  test "active_user_count includes leaders and volunteers of visible actions" do
    assert_equal 6, @action_group.active_user_count
  end

  test "date_range has correct start and end date" do
    date_range = @action_group.date_range
    assert_equal Date.current, date_range.begin
    assert_equal Date.current + 7, date_range.end
  end

  test "vacancy_count doesn't include invisible actions" do
    assert_equal 16, @action_group.vacancy_count
  end

  test "vacancy_count doesn't include past events" do
    events(:default).update_attribute :date, Date.current - 1
    assert_equal 13, @action_group.vacancy_count
  end

end
