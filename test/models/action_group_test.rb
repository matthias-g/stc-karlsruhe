require 'test_helper'

class ActionGroupTest < ActiveSupport::TestCase

  setup do
    @action_group = action_groups(:default)
  end

  test "date_range has correct start and end date" do
    date_range = @action_group.date_range
    assert_equal Date.current, date_range.begin
    assert_equal Date.current + 7, date_range.end
  end

end
