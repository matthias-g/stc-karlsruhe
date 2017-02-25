require 'test_helper'

class ProjectWeekTest < ActiveSupport::TestCase
  test 'active user count for project week with users' do
    assert_equal 6, project_weeks(:one).active_user_count
  end

  test 'active user count for project week without users' do
    assert_equal 0, project_weeks(:two).active_user_count
  end

  test 'date range' do
    date_range = project_weeks(:one).date_range
    assert_equal '2015-05-07'.to_date, date_range.begin
    assert_equal '2015-05-09'.to_date, date_range.end
  end

  test 'projects of project week' do
    assert_equal 8, project_weeks(:one).projects.count
  end
end
