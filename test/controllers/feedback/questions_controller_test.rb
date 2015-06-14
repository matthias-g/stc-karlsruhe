require 'test_helper'

class Feedback::QuestionsControllerTest < ActionController::TestCase
  setup do
    @feedback_question = feedback_questions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:feedback_questions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create feedback_question" do
    assert_difference('Feedback::Question.count') do
      post :create, feedback_question: { answer_options: @feedback_question.answer_options, parent_question_id: @feedback_question.parent_question_id, position: @feedback_question.position, survey_id: @feedback_question.survey_id, text: @feedback_question.text, question_type: @feedback_question.question_type }
    end

    assert_redirected_to feedback_question_path(assigns(:feedback_question))
  end

  test "should show feedback_question" do
    get :show, id: @feedback_question
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @feedback_question
    assert_response :success
  end

  test "should update feedback_question" do
    patch :update, id: @feedback_question, feedback_question: { answer_options: @feedback_question.answer_options, parent_question_id: @feedback_question.parent_question_id, position: @feedback_question.position, survey_id: @feedback_question.survey_id, text: @feedback_question.text, question_type: @feedback_question.question_type }
    assert_redirected_to feedback_question_path(assigns(:feedback_question))
  end

  test "should destroy feedback_question" do
    assert_difference('Feedback::Question.count', -1) do
      delete :destroy, id: @feedback_question
    end

    assert_redirected_to feedback_questions_path
  end
end
