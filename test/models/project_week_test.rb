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

  test 'vacancy count for project with subprojects' do
    project_week = ProjectWeek.create(title: 2017)
    parent_project = Project.create(title: 'parent project', desired_team_size: 0, visible: true, project_week: project_week)
    child1 = Project.create(title: 'child 1', desired_team_size: 5, parent_project: parent_project, visible: true, project_week: project_week)
    child2 = Project.create(title: 'child 2', desired_team_size: 3, parent_project: parent_project, visible: true, project_week: project_week)
    assert_equal 8, project_week.vacancy_count
    child1.close!
    assert_equal 3, project_week.vacancy_count
    child2.add_volunteer(users(:rolf))
    assert_equal 2, project_week.vacancy_count
    parent_project.reload.close!
    assert_equal 0, project_week.vacancy_count
  end
end
