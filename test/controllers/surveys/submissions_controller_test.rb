require 'test_helper'

class Surveys::SubmissionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @surveys_submission = surveys_submissions(:one)
  end

  test "should get index" do
    sign_in users(:admin)
    get surveys_template_surveys_submissions_url(@surveys_submission.template_id)
    assert_response :success
    assert_select 'table tr', 2
  end

  test "should get new" do
    get new_surveys_template_surveys_submission_url(@surveys_submission.template_id)
    assert_response :success
  end

  test "should create surveys_submission" do
    assert_difference('Surveys::Submission.count') do
      post surveys_template_surveys_submissions_url(@surveys_submission.template_id), params: { surveys_submission: {template_id: @surveys_submission.template_id } }
    end

    assert_redirected_to '/'
  end

  test "should show surveys_submission" do
    sign_in users(:admin)
    get surveys_template_surveys_submission_url(@surveys_submission.template_id, @surveys_submission)
    assert_response :success
  end

  test "should not get edit" do
    sign_in users(:admin)
    get edit_surveys_template_surveys_submission_url(@surveys_submission.template_id, @surveys_submission)
    assert_redirected_to '/'
  end
end
