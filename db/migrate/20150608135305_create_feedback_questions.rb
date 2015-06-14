class CreateFeedbackQuestions < ActiveRecord::Migration
  def change
    create_table :feedback_questions do |t|
      t.integer :survey_id
      t.text :text
      t.text :answer_options
      t.integer :type
      t.integer :position
      t.integer :parent_question_id

      t.timestamps
    end
    add_index :feedback_questions, :survey_id
    add_index :feedback_questions, :parent_question_id
  end
end
