require 'test_helper'

class Api::SubscriptionsControllerTest < ActionDispatch::IntegrationTest

  def sign_in(user)
    user.save!
    @headers['X-User-Email'] = user.email
    @headers['X-User-Token'] = user.authentication_token
  end

  setup do
    @headers = { Accept: 'application/vnd.api+json', 'Content-Type': 'application/vnd.api+json' }
  end

  def create_subscription_creation_data(email)
    {
        'data': {
            'type': 'subscriptions',
            'attributes': {
                'name': 'Max Mustermann',
                'email': email,
                'receive-emails-about-action-groups': true,
                'receive-emails-about-other-projects': true,
                'receive-other-emails-from-orga': true
            }
        }
    }
  end

  test "should create unconfirmed subscription for non-existing user" do
    data = create_subscription_creation_data('max@example.com')
    post api_subscriptions_path, params: data, headers: @headers, as: :json
    assert_response :success
    subscription = Subscription.find_by_email('max@example.com')
    assert_not_nil subscription
    assert_not subscription.confirmed?
  end

  test "should create unconfirmed subscription for existing unconfirmed user" do
    user = users(:unconfirmed_user)
    data = create_subscription_creation_data(user.email)
    post api_subscriptions_path, params: data, headers: @headers, as: :json
    assert_response :success
    subscription = Subscription.find_by_email(user.email)
    assert_not_nil subscription
    assert_not subscription.confirmed?
  end

  test "should create unconfirmed subscription for existing confirmed user when not logged in" do
    user = users(:confirmed_user)
    data = create_subscription_creation_data(user.email)
    post api_subscriptions_path, params: data, headers: @headers, as: :json
    assert_response :success
    subscription = Subscription.find_by_email(user.email)
    assert_not_nil subscription
    assert_not subscription.confirmed?
  end

  test "should create unconfirmed subscription for existing confirmed user when other user logged in" do
    user = users(:confirmed_user)
    sign_in(users(:unrelated))
    data = create_subscription_creation_data(user.email)
    post api_subscriptions_path, params: data, headers: @headers, as: :json
    assert_response :success
    subscription = Subscription.find_by_email(user.email)
    assert_not_nil subscription
    assert_not subscription.confirmed?
  end

  test "should create confirmed subscription for existing confirmed user when this user logged in" do
    user = users(:confirmed_user)
    assert user.confirmed?
    sign_in(user)
    data = create_subscription_creation_data(user.email)
    data[:data][:attributes][:'confirmed-at'] = 5.minutes.ago.to_s
    post api_subscriptions_path, params: data, headers: @headers, as: :json
    assert_response :success
    subscription = Subscription.find_by_email(user.email)
    assert_not_nil subscription
    assert subscription.confirmed?
  end

  test "should create unconfirmed subscription when sending confirmed_at for not logged in user" do
    user = users(:unconfirmed_user)
    assert_not user.confirmed?
    data = create_subscription_creation_data(user.email)
    data[:data][:attributes][:'confirmed-at'] = 5.minutes.ago.to_s
    post api_subscriptions_path, params: data, headers: @headers, as: :json
    assert_response :success
    subscription = Subscription.find_by_email(user.email)
    assert_not_nil subscription
    assert_not subscription.confirmed?
  end

  test "should create unconfirmed subscription when sending confirmed_at for other user" do
    user = users(:confirmed_user)
    sign_in(users(:unrelated))
    data = create_subscription_creation_data(user.email)
    data[:data][:attributes][:'confirmed-at'] = 5.minutes.ago.to_s
    post api_subscriptions_path, params: data, headers: @headers, as: :json
    assert_response :success
    subscription = Subscription.find_by_email(user.email)
    assert_not_nil subscription
    assert_not subscription.confirmed?
  end

end
