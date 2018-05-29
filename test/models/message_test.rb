require 'test_helper'

class MessageTest < ActiveSupport::TestCase

  setup do
    @message = Message.new(sender: 'berlin@stadt.de', recipient: 'hamburg@stadt.de')
  end

  test "persisted?" do
    assert_not @message.persisted?
  end

  test "message is only valid with subject, content and sender email" do
    assert_not @message.valid?
    @message.subject = 'Cities'
    @message.body = ''
    assert_not @message.valid?
    @message.body = 'Content'
    assert @message.valid?
    @message.sender = 'karlsruhe'
    assert_not @message.valid?
    @message.sender = 'test@example.org'
    assert @message.valid?
  end

end
