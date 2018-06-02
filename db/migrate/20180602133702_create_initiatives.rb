class CreateInitiatives < ActiveRecord::Migration[5.2]

  class Initiative < ActiveRecord::Base
  end

  def change
    rename_table :actions, :initiatives

    add_column :initiatives, :type, :string
    Initiative.update_all("type='Action'")

    rename_column :leaderships, :action_id, :initiative_id
  end
end
