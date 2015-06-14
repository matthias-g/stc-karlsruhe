class CreateFeedbackSurveys < ActiveRecord::Migration
  def change
    create_table :feedback_surveys do |t|
      t.string :title

      t.timestamps
    end
  end
end
