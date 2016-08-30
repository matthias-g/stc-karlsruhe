require 'test_helper'

class OrgaMessageTest < ActiveSupport::TestCase
  test 'sent?' do
    assert_not orga_messages(:one).sent?
    assert orga_messages(:three).sent?
  end

  test 'send_message' do
    message = orga_messages(:one)
    message.send_message users(:rolf)
    assert message.sent?
    assert message.sent_at > 10.seconds.ago
    assert message.sent_at < Time.now
    assert_equal users(:rolf), message.sender
  end
end
