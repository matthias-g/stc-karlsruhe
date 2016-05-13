class RenameSurveyToTemplate < ActiveRecord::Migration
  def change
    rename_table :feedback_surveys, :feedback_templates
    rename_column :feedback_questions, :survey_id, :template_id
    rename_column :feedback_submissions, :survey_id, :template_id
  end
end
