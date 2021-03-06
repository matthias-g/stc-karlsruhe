require 'test_helper'

class Surveys::TemplatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @template = surveys_templates(:one)
  end

  test "should get index" do
    sign_in users(:admin)
    get surveys_templates_url
    assert_response :success
    assert_select '#surveys_templates.index', 1
  end

  test "should get new" do
    sign_in users(:admin)
    get new_surveys_template_url
    assert_response :success
  end

  test "should create surveys_template" do
    sign_in users(:admin)
    assert_difference('Surveys::Template.count') do
      post surveys_templates_url, params: { surveys_template: { title: @template.title } }
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'h1', @template.title
  end

  test "should show surveys_template" do
    sign_in users(:admin)
    get surveys_template_url(@template)
    assert_response :success
  end

  test "should redirect show to answer form for non admin users" do
    get surveys_template_url(@template)
    assert_redirected_to new_surveys_template_surveys_submission_path(@template)
  end

  test "should get edit" do
    sign_in users(:admin)
    get edit_surveys_template_url(@template)
    assert_response :success
  end

  test "should update surveys_template" do
    sign_in users(:admin)
    patch surveys_template_url(@template), params: { surveys_template: { title: 'new title' } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_equal 'new title', @template.reload.title
    assert_select 'h1', 'new title'
  end

  test "should destroy surveys_template" do
    sign_in users(:admin)
    assert_difference('Surveys::Template.count', -1) do
      delete surveys_template_url(@template)
    end

    assert_redirected_to surveys_templates_path
  end
end
