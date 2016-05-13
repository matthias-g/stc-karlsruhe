require 'test_helper'

class Surveys::SubmissionsControllerTest < ActionController::TestCase
  setup do
    @surveys_submission = surveys_submissions(:one)
  end

  test "should get index" do
    sign_in users(:admin)
    get :index, surveys_template_id: @surveys_submission.template_id
    assert_response :success
    assert_not_nil assigns(:submissions)
  end

  test "should get new" do
    get :new, surveys_template_id: @surveys_submission.template_id
    assert_response :success
  end

  test "should create surveys_submission" do
    assert_difference('Surveys::Submission.count') do
      post :create, surveys_template_id: @surveys_submission.template_id, surveys_submission: {template_id: @surveys_submission.template_id }
    end

    assert_redirected_to '/'
  end

  test "should show surveys_submission" do
    sign_in users(:admin)
    get :show, surveys_template_id: @surveys_submission.template_id, id: @surveys_submission
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:admin)
    get :edit, surveys_template_id: @surveys_submission.template_id, id: @surveys_submission
    assert_response :success
  end
end
