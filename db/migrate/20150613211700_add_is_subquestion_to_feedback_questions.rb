class AddIsSubquestionToFeedbackQuestions < ActiveRecord::Migration
  def up
    add_column :feedback_questions, :is_subquestion, :boolean, default: false
    remove_index :feedback_questions, :parent_question_id
    remove_column :feedback_questions, :parent_question_id
  end

  def down
    remove_column :feedback_questions, :is_subquestion
    add_column :feedback_questions, :parent_question_id, :integer
    add_index :feedback_questions, :parent_question_id
  end
end
