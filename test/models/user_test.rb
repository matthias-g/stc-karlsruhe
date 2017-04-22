require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @email_index = 0
  end

  def create_unique_email_address
    @email_index += 1
    'homer' + @email_index.to_s + '@simpsons.org'
  end

  test "getting full name" do
    assert_equal 'Rolf Meier', users(:rolf).full_name
  end

  test "user leads project" do
    assert users(:rolf).leads_project?(projects(:one))
  end

  test "user doesn't lead project, but participates in project" do
    assert_not users(:sabine).leads_project?(projects(:two))
  end

  test "user doesn't lead project" do
    assert_not users(:lea).leads_project?(projects(:one))
  end

  test "projects as leader" do
    projects = users(:rolf).projects_as_leader
    assert_equal 4, projects.count
  end

  test "projects as volunteer is zero" do
    projects = users(:rolf).projects_as_volunteer
    assert_equal 0, projects.count
  end

  test "projects as volunteer" do
    projects = users(:lea).projects_as_volunteer
    assert_equal 1, projects.count
    assert_equal 'Musik bei Kindergarten-Fest', projects.first.title
  end

  test "has_role? given a String" do
    assert users(:admin).has_role?('admin')
  end

  test "has_role? given a Role" do
    assert_raise ArgumentError do
      users(:admin).has_role?(roles(:admin))
    end
  end

  test "has_role? if user doesn't have role" do
    assert_not users(:rolf).has_role?('admin')
  end

  test "add_role given a String" do
    assert_not users(:rolf).admin?
    users(:rolf).add_role('admin')
    assert users(:rolf).admin?
  end

  test "add_role given a Role" do
    assert_raise ArgumentError do
      users(:rolf).add_role(roles(:admin))
    end
  end

  test "photographer?" do
    assert_not users(:sabine).has_role?(:photographer)
    assert_not users(:sabine).photographer?
    users(:sabine).add_role('photographer')
    assert users(:sabine).has_role?(:photographer)
    assert users(:sabine).photographer?
  end

  test "clear! cleans personal data" do
    user = users(:rolf)
    user.clear!
    assert_equal 'cleared', user.first_name
    assert_equal 'cleared', user.last_name
    assert_equal '', user.phone
    assert_not_equal 'rolf', user.username
    assert user.email.ends_with?('@cleared.servethecity-karlsruhe.de')
    assert user.cleared
  end

  test "set_default_username_if_blank!" do
    user1 = User.create first_name: 'Homer', last_name: 'Simpson', email: create_unique_email_address, password: 'password'
    assert_equal 'Homer', user1.username
    assert user1.valid?

    user2 = User.create first_name: 'Homer', last_name: 'Simpson', email: create_unique_email_address, password: 'password'
    assert_equal 'HomerS', user2.username
    assert user2.valid?

    user3 = User.create first_name: 'Homer', last_name: 'Simpson', email: create_unique_email_address, password: 'password'
    assert_equal 'HomerSimpson', user3.username
    assert user3.valid?

    user4 = User.create first_name: 'Homer', last_name: 'Simpson', email: create_unique_email_address, password: 'password'
    assert user4.valid?

    user5 = User.create first_name: 'Homer', last_name: 'Simpson', email: create_unique_email_address, password: 'password'
    assert user5.valid?
  end

  test "merge other user's lead projects" do
    project = projects(:'kindergarten-music')
    user = users(:peter)
    other_user = users(:birgit)
    assert project.has_leader?(other_user)
    user.merge_other_users_projects(other_user)

    assert project.has_leader?(user)
    assert_not project.has_leader?(other_user)
  end

  test "merge other user's participating projects" do
    project = projects(:'kindergarten-kitchen')
    user = users(:birgit)
    other_user = users(:peter)
    assert project.has_volunteer?(other_user)
    user.merge_other_users_projects(other_user)

    assert project.has_volunteer?(user)
    assert_not project.has_volunteer?(other_user)
  end

end
