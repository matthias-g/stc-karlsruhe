require 'test_helper'

class Api::ActionsControllerTest < ActionDispatch::IntegrationTest

  def sign_in(user)
    user.save!
    @headers['X-User-Email'] = user.email
    @headers['X-User-Token'] = user.authentication_token
  end

  setup do
    @action = actions(:default)
    @event = @action.events.first
    @headers = { Accept: 'application/vnd.api+json', 'Content-Type': 'application/vnd.api+json' }
  end


  # VISITOR ACCESS

  test "should show visible action" do
    get api_action_path(@action), headers: @headers
    assert_response :success
    response_data = JSON.parse(@response.body)['data']
    assert_equal @action.id, response_data['id'].to_i
  end

  test "should not show invisible action" do
    @action.update_attribute :visible, false
    assert_not @action.visible
    get api_action_path(@action), headers: @headers
    assert_response :not_found
  end

  test "volunteer should not update invisible action" do
    @action.update_attribute :visible, false
    sign_in users(:volunteer)
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



  # LEADER ACCESS

  test "leader should show invisible action" do
    sign_in users(:leader)
    @action.update_attribute :visible, false
    get api_action_path(@action), headers: @headers
    assert_response :success
  end

  test "leader should update invisible action" do
    @action.update_attribute :visible, false
    sign_in users(:leader)
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

  test "leader should add volunteer" do
    sign_in users(:leader)
    params = {data: [type: User.model_name.plural, id: users(:unrelated).id]}
    post api_event_relationships_volunteers_path(@event), params: params, headers: @headers, as: :json
    assert_response :success
    assert_equal 3, @event.reload.volunteers.count
    assert_equal 3, @event.team_size
  end

  test "leader should remove volunteer" do
    sign_in users(:leader)
    volunteer = users(:volunteer)
    assert @event.volunteer?(volunteer)
    params = {data: [type: User.model_name.plural, id: volunteer.id]}
    delete api_event_relationships_volunteers_path(@event), params: params, headers: @headers, as: :json
    assert_response :success
    assert_equal 1, @event.reload.volunteers.count
    assert_equal 1, @event.team_size
  end

  test "leader should add other leader" do
    sign_in users(:leader)
    params = {data: [type: User.model_name.plural, id: users(:unrelated).id]}
    post api_action_relationships_leaders_path(@action), params: params, headers: @headers, as: :json
    assert_response :success
    assert_equal 2, @action.reload.leaders.count
  end

  test "leader should remove self" do
    sign_in users(:leader)
    params = {data: [type: User.model_name.plural, id: users(:leader).id]}
    delete api_action_relationships_leaders_path(@action), params: params, headers: @headers, as: :json
    assert_response :success
    assert_equal 0, @action.reload.leaders.count
  end


end
