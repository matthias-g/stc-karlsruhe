class AddUserIdToSurveysSubmissions < ActiveRecord::Migration
  def change
    add_column :surveys_submissions, :user_id, :integer
  end
end
