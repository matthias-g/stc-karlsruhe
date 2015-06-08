class CreateFeedbackSurveyAnswers < ActiveRecord::Migration
  def change
    create_table :feedback_survey_answers do |t|
      t.integer :survey_id

      t.timestamps
    end
    add_index :feedback_survey_answers, :survey_id
  end
end
