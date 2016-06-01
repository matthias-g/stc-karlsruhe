class AddExplanationToSurveysQuestion < ActiveRecord::Migration
  def change
    add_column :surveys_questions, :explanation, :text
  end
end
