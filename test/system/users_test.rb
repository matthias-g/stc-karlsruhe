require "application_system_test_case"

SimpleCov.command_name "test:system"

class UsersTest < ApplicationSystemTestCase

  test "logging user in" do
    user = users(:leader)
    user.regenerate_ical_token

    visit new_user_session_url

    fill_in 'user[login]', with: user.username
    fill_in 'user[password]', with: 'testPassword'

    within 'form.new_user' do
      click_on 'Anmelden'
    end

    assert_selector 'h1', text: user.full_name
  end

end
