class CreateSubscriptions < ActiveRecord::Migration[5.2]

  class User < ActiveRecord::Base
  end
  class Subscription < ActiveRecord::Base
  end

  def change
    create_table :subscriptions do |t|
      t.string :email, index: true, unique: true
      t.string :name
      t.boolean :receive_emails_about_action_groups, default: true, index: true
      t.boolean :receive_emails_about_other_projects, default: true, index: true
      t.boolean :receive_other_emails_from_orga, default: true, index: true

      t.timestamps
    end

    reversible do |change|
      change.up do
        User.find_each do |user|
          next unless user.receive_other_emails_from_orga || user.receive_emails_about_other_projects || user.receive_emails_about_action_groups
          Subscription.create!(email: user.email, name: user.first_name,
                               receive_emails_about_action_groups: user.receive_emails_about_action_groups,
                               receive_emails_about_other_projects: user.receive_emails_about_other_projects,
                               receive_other_emails_from_orga: user.receive_other_emails_from_orga)
        end
      end
    end

    remove_column :users, :receive_emails_about_action_groups, :boolean
    remove_column :users, :receive_emails_about_other_projects, :boolean
    remove_column :users, :receive_other_emails_from_orga, :boolean
  end
end
