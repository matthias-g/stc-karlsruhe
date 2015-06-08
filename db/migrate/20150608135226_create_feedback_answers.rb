class CreateFeedbackAnswers < ActiveRecord::Migration
  def change
    create_table :feedback_answers do |t|
      t.integer :survey_answer_id
      t.integer :question_id
      t.text :text

      t.timestamps
    end
    add_index :feedback_answers, :survey_answer_id
    add_index :feedback_answers, :question_id
  end
end
