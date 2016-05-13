require 'test_helper'

class Surveys::TemplatesControllerTest < ActionController::TestCase
  setup do
    @template = surveys_templates(:one)
  end

  test "should get index" do
    sign_in users(:admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:templates)
  end

  test "should get new" do
    sign_in users(:admin)
    get :new
    assert_response :success
  end

  test "should create surveys_template" do
    sign_in users(:admin)
    assert_difference('Surveys::Template.count') do
      post :create, surveys_template: { title: @template.title }
    end

    assert_redirected_to surveys_template_path(assigns(:template))
  end

  test "should show surveys_template" do
    sign_in users(:admin)
    get :show, id: @template
    assert_response :success
  end

  test "should redirect show to answer form for non admin users" do
    get :show, id: @template
    assert_redirected_to new_surveys_template_surveys_submission_path(@template)
  end

  test "should get edit" do
    sign_in users(:admin)
    get :edit, id: @template
    assert_response :success
  end

  test "should update surveys_template" do
    sign_in users(:admin)
    patch :update, id: @template, surveys_template: {title: @template.title }
    assert_redirected_to surveys_template_path(assigns(:template))
  end

  test "should destroy surveys_template" do
    sign_in users(:admin)
    assert_difference('Surveys::Template.count', -1) do
      delete :destroy, id: @template
    end

    assert_redirected_to surveys_templates_path
  end
end
