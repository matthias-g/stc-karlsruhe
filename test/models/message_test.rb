require 'test_helper'

class MessageTest < ActiveSupport::TestCase

  setup do
    @message = Message.new sender: 'berlin@stadt.de', recipient: 'hamburg@stadt.de'
  end

  test 'persisted?' do
    assert_not @message.persisted?
  end

  test 'initialization' do
    assert_equal 'berlin@stadt.de', @message.sender
    assert_equal 'hamburg@stadt.de', @message.recipient
  end

  test 'validation' do
    assert_not @message.valid?
    @message.subject = 'Cities'
    @message.body = ''
    assert_not @message.valid?
    @message.body = 'Content'
    assert @message.valid?
    @message.sender = 'karlsruhe'
    assert_not @message.valid?
  end

end
