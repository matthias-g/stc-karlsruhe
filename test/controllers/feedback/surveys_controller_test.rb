require 'test_helper'

class Feedback::SurveysControllerTest < ActionController::TestCase
  setup do
    @survey = feedback_surveys(:one)
  end

  test "should get index" do
    sign_in users(:admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:surveys)
  end

  test "should get new" do
    sign_in users(:admin)
    get :new
    assert_response :success
  end

  test "should create feedback_survey" do
    sign_in users(:admin)
    assert_difference('Feedback::Survey.count') do
      post :create, feedback_survey: { title: @survey.title }
    end

    assert_redirected_to feedback_survey_path(assigns(:survey))
  end

  test "should show feedback_survey" do
    sign_in users(:admin)
    get :show, id: @survey
    assert_response :success
  end

  test "should redirect show to answer form for non admin users" do
    get :show, id: @survey
    assert_redirected_to new_feedback_survey_feedback_survey_answer_path(@survey)
  end

  test "should get edit" do
    sign_in users(:admin)
    get :edit, id: @survey
    assert_response :success
  end

  test "should update feedback_survey" do
    sign_in users(:admin)
    patch :update, id: @survey, feedback_survey: { title: @survey.title }
    assert_redirected_to feedback_survey_path(assigns(:survey))
  end

  test "should destroy feedback_survey" do
    sign_in users(:admin)
    assert_difference('Feedback::Survey.count', -1) do
      delete :destroy, id: @survey
    end

    assert_redirected_to feedback_surveys_path
  end
end
