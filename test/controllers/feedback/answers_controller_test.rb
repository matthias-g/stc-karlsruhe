require 'test_helper'

class Feedback::AnswersControllerTest < ActionController::TestCase
  setup do
    @feedback_answer = feedback_answers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:feedback_answers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create feedback_answer" do
    assert_difference('Feedback::Answer.count') do
      post :create, feedback_answer: { question_id: @feedback_answer.question_id, survey_answer_id: @feedback_answer.survey_answer_id, text: @feedback_answer.text }
    end

    assert_redirected_to feedback_answer_path(assigns(:feedback_answer))
  end

  test "should show feedback_answer" do
    get :show, id: @feedback_answer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @feedback_answer
    assert_response :success
  end

  test "should update feedback_answer" do
    patch :update, id: @feedback_answer, feedback_answer: { question_id: @feedback_answer.question_id, survey_answer_id: @feedback_answer.survey_answer_id, text: @feedback_answer.text }
    assert_redirected_to feedback_answer_path(assigns(:feedback_answer))
  end

  test "should destroy feedback_answer" do
    assert_difference('Feedback::Answer.count', -1) do
      delete :destroy, id: @feedback_answer
    end

    assert_redirected_to feedback_answers_path
  end
end
