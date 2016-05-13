class RenameSurveyAnswerToSubmission < ActiveRecord::Migration
  def change
    rename_table :feedback_survey_answers, :feedback_submissions
    rename_column :feedback_answers, :survey_answer_id, :submission_id
  end
end
