require 'test_helper'

class Api::ActionsControllerTest < ActionDispatch::IntegrationTest

  def sign_in(user)
    user.save!
    @headers['X-User-Email'] = user.email
    @headers['X-User-Token'] = user.authentication_token
  end

  setup do
    @action = actions(:one)
    @headers = { Accept: 'application/vnd.api+json', 'Content-Type': 'application/vnd.api+json' }
  end

  test 'should show visible action' do
    assert @action.visible
    get api_action_path(@action), headers: @headers
    assert_response :success
    response_data = JSON.parse(@response.body)['data']
    assert_equal @action.id, response_data['id'].to_i
  end

  test 'should not show invisible action' do
    @action = actions(:three)
    assert_not @action.visible
    get api_action_path(@action), headers: @headers
    assert_response :not_found
  end

  test 'should show invisible action if current user leads it' do
    user = users(:rolf)
    sign_in user
    @action = actions(:three)
    assert user.leads_action?(@action)
    assert_not @action.visible
    get api_action_path(@action), headers: @headers
    assert_response :success
  end

  test 'action leader should be able to update title' do
    user = users(:rolf)
    sign_in user
    @action = actions(:three)
    assert user.leads_action?(@action)
    assert_not @action.visible
    new_title = 'New title'
    data = {
        'data': {
            'type': 'actions',
            'id': @action.id,
            'attributes': {
                'title': new_title
            }
        }
    }
    patch api_action_path(@action), params: data, headers: @headers, as: :json
    assert_response :success
    assert_equal new_title, @action.reload.title
  end

  test 'unrelated user should not be able to update title' do
    user = users(:sabine)
    sign_in user
    @action = actions(:three)
    assert_not user.leads_action?(@action)
    assert_not @action.visible
    new_title = 'New title'
    old_title = @action.title
    data = {
        'data': {
            'type': 'actions',
            'id': @action.id,
            'attributes': {
                'title': new_title
            }
        }
    }
    patch api_action_path(@action), params: data, headers: @headers, as: :json
    assert_response :not_found
    assert_equal old_title, @action.reload.title
  end
end
