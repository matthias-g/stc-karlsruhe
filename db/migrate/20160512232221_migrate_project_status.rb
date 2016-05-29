class MigrateProjectStatus < ActiveRecord::Migration

  class Project < ActiveRecord::Base
    enum status: { open: 1, soon_full: 2, full: 3, closed: 4 }
    def adjust_status
      if self.status == 'closed'
        return
      end
      free = aggregated_desired_team_size - aggregated_volunteers.count
      if free > 2
        self.status = :open
      elsif free > 0
        self.status = :soon_full
      else
        self.status = :full
      end
    end
  end


  def up
    execute "UPDATE TABLE projects SET status_id = 1 WHERE status_id IN [1,2,3];"
    execute "UPDATE TABLE projects SET status_id = 2 WHERE status_id = 4;"
    execute "UPDATE TABLE projects SET status_id = 3 WHERE NOT visible;"
    remove_column :projects, :visible
  end

  def down
    add_column :projects, :visible, :boolean, default: false
    execute "UPDATE TABLE projects SET status_id = 1 WHERE status_id = 1;"
    execute "UPDATE TABLE projects SET status_id = 4 WHERE status_id = 2;"
    execute "UPDATE TABLE projects SET visible = 0, status_id = 1 WHERE status_id = 3;"
    Project.find_each do |p|
      p.adjust_status
      p.save!
    end
  end

end
