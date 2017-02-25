require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test "getting volunteers" do
    assert_equal 1, projects(:one).volunteers.count
    assert_equal 'sabine', projects(:one).volunteers.first.username
  end

  test "getting leaders" do
    assert_equal 2, projects(:one).leaders.count
    usernames = projects(:one).leaders.collect { |user| user.username }
    assert usernames.include? 'rolf'
    assert usernames.include? 'tabea'
  end

  test "getting volunteers in subprojects" do
    volunteers = projects(:'kindergarten-party').volunteers_in_subprojects
    assert_equal 2, volunteers.count
    volunteer_names = volunteers.collect { |volunteer| volunteer.username }
    assert volunteer_names.include? 'lea'
    assert volunteer_names.include? 'peter'
  end

  test "getting aggregated volunteers of project with subprojects" do
    users = projects(:'kindergarten-party').aggregated_volunteers
    assert_equal 3, users.count
    usernames = users.collect { |user| user.username }
    assert usernames.include? 'lea'
    assert usernames.include? 'peter'
    assert usernames.include? 'sabine'
  end

  test "getting aggregated volunteers of project without subprojects" do
    users = projects(:one).aggregated_volunteers
    assert_equal 1, users.count
    usernames = users.collect { |user| user.username }
    assert usernames.include? 'sabine'
  end

  test "getting aggregated leaders of project with subprojects" do
    users = projects(:'kindergarten-party').aggregated_leaders
    assert_equal 2, users.count
    usernames = users.collect { |user| user.username }
    assert usernames.include? 'birgit'
    assert usernames.include? 'rolf'
  end

  test "getting aggregated leaders of project without subprojects" do
    users = projects(:one).aggregated_leaders
    assert_equal 2, users.count
    usernames = users.collect { |user| user.username }
    assert usernames.include? 'rolf'
    assert usernames.include? 'tabea'
  end

  test "getting aggregated_desired_team_size of project with subprojects" do
    assert_equal 10, projects(:'kindergarten-party').aggregated_desired_team_size
  end

  test "getting aggregated_desired_team_size of project without subprojects" do
    assert_equal 4, projects(:one).aggregated_desired_team_size
  end

  test "adding volunteer" do
    assert_difference 'projects(:one).volunteers.count' do
      projects(:one).add_volunteer users(:lea)
    end
  end

  test "adding volunteer leaves project status open" do
    project = Project.create title: 'title', desired_team_size: 20
    project.save!
    assert_difference 'project.volunteers.count' do
      project.add_volunteer users(:lea)
    end
    assert project.open?
  end

  test "adding volunteer changes project status to soon full" do
    project = Project.create title: 'title', desired_team_size: 2
    project.save!
    assert_difference 'project.volunteers.count' do
      project.add_volunteer users(:lea)
    end
    assert project.soon_full?
  end

  test "adding volunteer changes project status to full" do
    project = Project.create title: 'title', desired_team_size: 1
    project.save!
    assert_difference 'project.volunteers.count' do
      project.add_volunteer users(:lea)
    end
    assert project.full?
  end

  test "has_volunteer?" do
    assert projects(:one).has_volunteer? users(:sabine)
    assert_not projects(:one).has_volunteer? users(:peter)
  end

  test "has_volunteer_in_subproject?" do
    assert projects(:'kindergarten-party').has_volunteer_in_subproject? users(:peter)
    assert_not projects(:'kindergarten-party').has_volunteer_in_subproject? users(:rolf)
    assert_not projects(:'kindergarten-party').has_volunteer_in_subproject? users(:sabine)
  end

  test "deleting volunteer" do
    assert_difference 'projects(:one).volunteers.count', -1 do
      projects(:one).delete_volunteer users(:sabine)
    end
  end

  test "deleting volunteer changes project status to open" do
    project = Project.create title: 'title', desired_team_size: 3
    project.save!
    project.add_volunteer users(:sabine)
    assert project.soon_full?
    assert_difference 'project.volunteers.count', -1 do
      project.delete_volunteer users(:sabine)
    end
    assert project.open?
  end

  test "deleting volunteer changes project status to soon full" do
    project = Project.create title: 'title', desired_team_size: 1
    project.save!
    project.add_volunteer users(:sabine)
    assert project.full?
    assert_difference 'project.volunteers.count', -1 do
      project.delete_volunteer users(:sabine)
    end
    assert project.soon_full?
  end

  test "deleting volunteer leaves project status open" do
    project = Project.create title: 'title', desired_team_size: 20
    project.add_volunteer users(:sabine)
    assert project.open?
    assert_difference 'project.volunteers.count', -1 do
      project.delete_volunteer users(:sabine)
    end
    assert project.open?
  end

  test "adding leader" do
    assert_difference 'projects(:one).leaders.count' do
      projects(:one).add_leader users(:lea)
    end
  end

  test "deleting leader" do
    assert_difference 'projects(:one).leaders.count', -1 do
      projects(:one).delete_leader users(:rolf)
    end
  end

  test "has_leader?" do
    assert projects(:one).has_leader? users(:rolf)
    assert_not projects(:one).has_leader? users(:lea)
  end

  test "make visible" do
    assert_not projects(:two).visible?
    projects(:two).make_visible!
    assert projects(:two).visible?
  end

  test "make invisible" do
    assert projects(:one).visible?
    projects(:one).make_invisible!
    assert_not projects(:one).visible?
  end

  test "close project without subprojects" do
    assert projects(:one).open?
    projects(:one).close!
    assert projects(:one).closed?
  end

  test "close project with subprojects" do
    assert projects(:'kindergarten-party').open?
    assert projects(:'kindergarten-music').open?
    assert projects(:'kindergarten-kitchen').open?
    projects(:'kindergarten-party').close!
    assert projects(:'kindergarten-party').reload.closed?
    assert projects(:'kindergarten-music').reload.closed?
    assert projects(:'kindergarten-kitchen').reload.closed?
  end

  test "open project without subprojects" do
    assert projects(:closed).closed?
    projects(:closed).open!
    assert projects(:closed).open?
  end

  test "open project with subprojects" do
    assert projects(:closed_parent_project).closed?
    assert projects(:closed_subproject).closed?
    projects(:closed_parent_project).open!
    assert projects(:closed_parent_project).reload.open?
    assert projects(:closed_subproject).reload.open?
  end

  test "open full project" do
    assert projects(:full_but_closed).closed?
    projects(:full_but_closed).open!
    assert projects(:full_but_closed).full?
    assert_not projects(:full_but_closed).open?
  end

  test "open soon full project" do
    assert projects(:soon_full_but_closed).closed?
    projects(:soon_full_but_closed).open!
    assert projects(:soon_full_but_closed).soon_full?
    assert_not projects(:soon_full_but_closed).open?
  end

  test "open project with subprojects free, soon full, and full" do
    parent = projects(:closed)
    free_subproject = Project.create title: 'free', desired_team_size: 9, parent_project: parent, status: Project.statuses['closed']
    soon_full_subproject = Project.create title: 'soon_full', desired_team_size: 2, parent_project: parent, status: Project.statuses['closed']
    full_subproject = Project.create title: 'full', desired_team_size: 0, parent_project: parent, status: Project.statuses['closed']
    assert_equal 3, parent.subprojects.count
    parent.open!
    assert parent.open?
    assert free_subproject.reload.open?
    assert soon_full_subproject.reload.soon_full?
    assert full_subproject.reload.full?
  end

  test "has_free_places?" do
    assert projects(:one).has_free_places?
    assert_not projects(:full).has_free_places?
    no_team_size = Project.new title: 'test', desired_team_size: 0
    assert_not no_team_size.has_free_places?
  end

  test "is_subproject?" do
    assert_not projects(:one).is_subproject?
    assert projects(:'kindergarten-music').is_subproject?
    assert_not projects(:'kindergarten-party').is_subproject?
  end

  test "gallery is created automatically on create" do
    project = Project.create title: 'test', desired_team_size: 3
    assert_not_nil project.gallery
  end

end
