class AddShowInUserProfileToSurveysTemplates < ActiveRecord::Migration
  def change
    add_column :surveys_templates, :show_in_user_profile, :boolean, default: false
  end
end
