require 'test_helper'

class Api::ProjectsControllerTest < ActionDispatch::IntegrationTest

  def sign_in(user)
    user.save!
    @headers['X-User-Email'] = user.email
    @headers['X-User-Token'] = user.authentication_token
  end

  setup do
    @project = projects(:one)
    @headers = { Accept: 'application/vnd.api+json', 'Content-Type': 'application/vnd.api+json' }
  end

  test 'should show visible project' do
    assert @project.visible
    get api_project_path(@project), headers: @headers
    assert_response :success
    response_data = JSON.parse(@response.body)['data']
    assert_equal @project.id, response_data['id'].to_i
  end

  test 'should not show invisible project' do
    @project = projects(:three)
    assert_not @project.visible
    get api_project_path(@project), headers: @headers
    assert_response :not_found
  end

  test 'should show invisible project if current user leads it' do
    user = users(:rolf)
    sign_in user
    @project = projects(:three)
    assert user.leads_project?(@project)
    assert_not @project.visible
    get api_project_path(@project), headers: @headers
    assert_response :success
  end

  test 'project leader should be able to update title' do
    user = users(:rolf)
    sign_in user
    @project = projects(:three)
    assert user.leads_project?(@project)
    assert_not @project.visible
    new_title = 'New title'
    data = {
        'data': {
            'type': 'projects',
            'id': @project.id,
            'attributes': {
                'title': new_title
            }
        }
    }
    patch api_project_path(@project), params: data, headers: @headers, as: :json
    assert_response :success
    assert_equal new_title, @project.reload.title
  end

  test 'unrelated user should not be able to update title' do
    user = users(:sabine)
    sign_in user
    @project = projects(:three)
    assert_not user.leads_project?(@project)
    assert_not @project.visible
    new_title = 'New title'
    old_title = @project.title
    data = {
        'data': {
            'type': 'projects',
            'id': @project.id,
            'attributes': {
                'title': new_title
            }
        }
    }
    patch api_project_path(@project), params: data, headers: @headers, as: :json
    assert_response :not_found
    assert_equal old_title, @project.reload.title
  end
end
