require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @email_index = 0
  end

  def create_unique_email_address
    @email_index += 1
    'homer' + @email_index.to_s + '@simpsons.org'
  end


  test "full_name returns first name plus last name" do
    assert_equal 'Unrelated User', users(:unrelated).full_name
  end

  test "leads_action? is true for action leader" do
    assert users(:leader).leads_action?(actions(:default))
  end

  test "leads_action? is false for volunteer" do
    assert_not users(:volunteer).leads_action?(actions(:default))
  end

  test "leads_action? is false for unrelated user" do
    assert_not users(:unrelated).leads_action?(actions(:default))
  end

  test "initiatives_as_leader is 4 for leader" do
    assert_equal 2, users(:leader).initiatives_as_leader.count
  end

  test "actions_as_volunteer is 0 for unrelated user" do
    assert_equal 0, users(:unrelated).actions_as_volunteer.count
  end

  test "actions_as_volunteer is 1 for volunteer" do
    assert_equal 1, users(:volunteer).actions_as_volunteer.count
    assert_equal actions(:default), users(:volunteer).actions_as_volunteer.first
  end

  test "has_role?('admin') is true for admin" do
    assert users(:admin).has_role?('admin')
  end

  test "has_role? is false for user without a role" do
    assert_not users(:unrelated).has_role?('admin')
  end

  test "add_role('admin') adds the role" do
    users(:unrelated).add_role('admin')
    assert users(:unrelated).admin?
  end

  test "photographer?" do
    user = users(:unrelated)
    assert_not user.has_role?(:photographer)
    assert_not user.photographer?
    user.add_role('photographer')
    assert user.has_role?(:photographer)
    assert user.photographer?
  end

  test "clear! cleans personal data" do
    user = users(:unrelated)
    user.clear!
    assert_equal 'cleared', user.first_name
    assert_equal 'cleared', user.last_name
    assert_equal '', user.phone
    assert_not_equal 'unrelated', user.username
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

  test "merge other user's lead actions" do
    subaction = actions(:subaction)
    subaction_leader = users(:subaction_leader)
    user = users(:leader)
    user.merge_other_users_actions(subaction_leader)
    assert subaction.leader?(user)
    assert_not subaction.leader?(subaction_leader)
  end

  test "merge other user's participating events" do
    subevent = events(:subaction_event)
    subaction_volunteer = users(:subaction_volunteer)
    user = users(:volunteer)
    user.merge_other_users_actions(subaction_volunteer)
    assert subevent.volunteer?(user)
    assert_not subevent.volunteer?(subaction_volunteer)
  end

end
