require 'test_helper'

class ParticipationTest < ActiveSupport::TestCase
  test 'active user count' do
    assert_equal 5, Participation.active_user_count
  end
end
