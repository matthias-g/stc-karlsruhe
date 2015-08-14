require 'test_helper'

class Feedback::SurveyAnswersControllerTest < ActionController::TestCase
  setup do
    @feedback_survey_answer = feedback_survey_answers(:one)
  end

  test "should get index" do
    sign_in users(:admin)
    get :index, feedback_survey_id: @feedback_survey_answer.survey_id
    assert_response :success
    assert_not_nil assigns(:survey_answers)
  end

  test "should get new" do
    get :new, feedback_survey_id: @feedback_survey_answer.survey_id
    assert_response :success
  end

  test "should create feedback_survey_answer" do
    assert_difference('Feedback::SurveyAnswer.count') do
      post :create, feedback_survey_id: @feedback_survey_answer.survey_id, feedback_survey_answer: { survey_id: @feedback_survey_answer.survey_id }
    end

    assert_redirected_to '/'
  end

  test "should show feedback_survey_answer" do
    sign_in users(:admin)
    get :show, feedback_survey_id: @feedback_survey_answer.survey_id, id: @feedback_survey_answer
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:admin)
    get :edit, feedback_survey_id: @feedback_survey_answer.survey_id, id: @feedback_survey_answer
    assert_response :success
  end
end
