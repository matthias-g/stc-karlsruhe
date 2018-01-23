class RemoveProjectDays < ActiveRecord::Migration[5.1]
  def up
    add_column :project_weeks, :start_date, :date
    add_column :project_weeks, :end_date, :date
    ProjectWeek.all.each do |week|
      week.start_date = week.date_range.begin
      week.end_date = week.date_range.end
      week.save!
    end

    add_column :actions, :date, :date
    Project.all.find_all{ |p| p.days.count > 1 && p.subprojects.count == 0 }.each do |project|
      create_subprojects_for_multi_day_project(project)
    end
    Project.all.each do |project|
      if project.days.count > 1
        if project.subprojects.count > 0
          project.days = []
          project.save!
        else
          print "Error! Project with id #{project.id} has more than one project day!\n"
        end
      elsif project.days.count == 1
        project.date = project.days.first.date
        project.save!
      else
        if project.subprojects.count == 0
          print "Error! Project with id #{project.id} has no project day\n"
        end
      end
    end

    drop_join_table :projects, :project_days
    drop_table :project_days
  end

  private

  def create_subprojects_for_multi_day_project(project)
    project.days.each do |day|
      subproject = Project.create!(title: "#{project.title} - #{day.title.partition(",").first}",
                                  description: project.description,
                                  location: project.location,
                                  latitude: project.latitude,
                                  longitude: project.longitude,
                                  individual_tasks: project.individual_tasks,
                                  material: project.material,
                                  requirements: project.requirements,
                                  visible: project.visible,
                                  picture: project.picture,
                                  desired_team_size: project.desired_team_size,
                                  status: project.status,
                                  time: project.time,
                                  short_description: project.short_description,
                                  map_latitude: project.map_latitude,
                                  map_longitude: project.map_longitude,
                                  map_zoom: project.map_zoom,
                                  picture_source: project.picture_source,
                                  project_week: project.project_week,
                                  parent_project: project)
      subproject.days << day
      project.volunteers.each do |volunteer|
        subproject.add_volunteer(volunteer)
      end
      project.leaders.each do |leader|
        subproject.add_leader(leader)
      end
    end
    project.volunteers.destroy_all
    project.desired_team_size = 0
    project.days = []
    project.save!
  end

end
