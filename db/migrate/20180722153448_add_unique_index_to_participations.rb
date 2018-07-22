class AddUniqueIndexToParticipations < ActiveRecord::Migration[5.2]
  def change
    reversible do |direction|
      direction.up do
        Participation.select(:user_id, :event_id).group(:user_id, :event_id).having("count(*) > 1").each do |duplicate|
          participations = Participation.where(user_id: duplicate.user_id, event_id: duplicate.event_id)
          unless participations.count == 2
            raise "There are #{participations.count} duplicates, but 2 are expected."
          end
          participations.first.destroy
        end
      end
    end

    add_index :participations, [:user_id, :event_id], unique: true
  end
end

