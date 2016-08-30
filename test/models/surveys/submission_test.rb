require 'test_helper'

class Surveys::SubmissionTest < ActiveSupport::TestCase

  test 'create for template' do
    template = surveys_templates(:one)
    submission = Surveys::Submission.create_for_template template
    assert_equal template, submission.template
    assert_equal 2, template.questions.count
    assert_equal 2, submission.answers.size     # correct number of answers created
    assert_equal 0, submission.answers.count    # but nothing stored in database
    assert_equal template.questions[0], submission.answers[0].question
    assert_equal template.questions[1], submission.answers[1].question
  end
end
