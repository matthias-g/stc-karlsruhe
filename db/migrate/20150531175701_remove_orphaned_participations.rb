class RemoveOrphanedParticipations < ActiveRecord::Migration
  def up
    Participation.destroy_all(user_id: nil)
    Participation.destroy_all(project_id: nil)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
