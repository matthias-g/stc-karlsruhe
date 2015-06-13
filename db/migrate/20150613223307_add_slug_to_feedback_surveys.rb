class AddSlugToFeedbackSurveys < ActiveRecord::Migration
  def change
    add_column :feedback_surveys, :slug, :string
    add_index :feedback_surveys, :slug, unique: true
  end
end
