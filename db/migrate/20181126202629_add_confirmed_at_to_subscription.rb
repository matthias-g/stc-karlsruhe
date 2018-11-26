class AddConfirmedAtToSubscription < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :confirmed_at, :datetime
  end
end
