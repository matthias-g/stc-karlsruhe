require 'test_helper'

class Feedback::SurveysControllerTest < ActionController::TestCase
  setup do
    @survey = feedback_surveys(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:feedback_surveys)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create feedback_survey" do
    assert_difference('Feedback::Survey.count') do
      post :create, feedback_survey: { title: @survey.title }
    end

    assert_redirected_to feedback_survey_path(assigns(:@survey))
  end

  test "should show feedback_survey" do
    get :show, id: @survey
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @survey
    assert_response :success
  end

  test "should update feedback_survey" do
    patch :update, id: @survey, feedback_survey: { title: @feedback_survey.title }
    assert_redirected_to feedback_survey_path(assigns(:@survey))
  end

  test "should destroy feedback_survey" do
    assert_difference('Feedback::Survey.count', -1) do
      delete :destroy, id: @feedback_survey
    end

    assert_redirected_to feedback_surveys_path
  end
end
