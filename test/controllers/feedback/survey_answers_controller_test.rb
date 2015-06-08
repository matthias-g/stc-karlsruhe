require 'test_helper'

class Feedback::SurveyAnswersControllerTest < ActionController::TestCase
  setup do
    @feedback_survey_answer = feedback_survey_answers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:feedback_survey_answers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create feedback_survey_answer" do
    assert_difference('Feedback::SurveyAnswer.count') do
      post :create, feedback_survey_answer: { survey_id: @feedback_survey_answer.survey_id }
    end

    assert_redirected_to feedback_survey_answer_path(assigns(:feedback_survey_answer))
  end

  test "should show feedback_survey_answer" do
    get :show, id: @feedback_survey_answer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @feedback_survey_answer
    assert_response :success
  end

  test "should update feedback_survey_answer" do
    patch :update, id: @feedback_survey_answer, feedback_survey_answer: { survey_id: @feedback_survey_answer.survey_id }
    assert_redirected_to feedback_survey_answer_path(assigns(:feedback_survey_answer))
  end

  test "should destroy feedback_survey_answer" do
    assert_difference('Feedback::SurveyAnswer.count', -1) do
      delete :destroy, id: @feedback_survey_answer
    end

    assert_redirected_to feedback_survey_answers_path
  end
end
