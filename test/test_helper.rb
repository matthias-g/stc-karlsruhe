require 'simplecov'
SimpleCov.command_name 'rails test'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  include ActiveJob::TestHelper
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # asserts that a given number of emails is sent in the block
  def assert_mails_sent(count, &block)
    ActionMailer::Base.deliveries = []
    assert_difference 'ActionMailer::Base.deliveries.size', count do
      perform_enqueued_jobs(&block)
    end
  end

  # set of all mail addresses that received an email
  def mail_recipients
    ActionMailer::Base.deliveries.map(&:to).flatten.to_set
  end

  # set of all mail addresses of the given user fixtures
  def all_mails(*user_fixtures)
    user_fixtures.map{|u| users(u).email}.to_set
  end

  # set of all registered user mail addresses, minus the given user fixtures
  def all_other_mails(*user_fixtures)
    (User.all - user_fixtures.map{|u| users(u)}).pluck(:email).to_set
  end

end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end
