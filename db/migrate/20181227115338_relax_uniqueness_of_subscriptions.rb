class RelaxUniquenessOfSubscriptions < ActiveRecord::Migration[5.2]
  def change
    remove_index :subscriptions, :email
    add_index :subscriptions, :email, unique: false
    add_index :subscriptions, [:email, :confirmed_at], unique: true
  end
end
