require 'test_helper'

class Api::ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = projects(:one)
  end

  test 'should show visible project' do
    assert @project.visible
    get project_url(@project)
    assert_response :success
  end
end
