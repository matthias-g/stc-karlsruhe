class RenameColumnTypeInQuestion < ActiveRecord::Migration
  def change
    rename_column :feedback_questions, :type, :question_type
  end
end
