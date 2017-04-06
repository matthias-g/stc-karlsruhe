class AddIcalTokenToUser < ActiveRecord::Migration[5.0]

  def change
    add_column :users, :ical_token, :string

    reversible do |change|
      change.up do
        User.all.where(cleared: false).each(&:regenerate_ical_token)
      end
    end
  end
end
