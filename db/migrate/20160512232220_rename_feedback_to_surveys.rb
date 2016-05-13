class RenameFeedbackToSurveys < ActiveRecord::Migration
  def change
    rename_table :feedback_templates, :surveys_templates
    rename_table :feedback_submissions, :surveys_submissions
    rename_table :feedback_answers, :surveys_answers
    rename_table :feedback_questions, :surveys_questions
  end
end
