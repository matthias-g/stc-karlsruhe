class StatisticsController < ApplicationController
  before_action :authenticate_admin_or_coordinator!

  def participations
    @end_date = params[:date]&.to_date || Date.tomorrow
    @start_date = @end_date - 60
    @project_week = ProjectWeek.all.to_a.select { |project_week| (@start_date..@end_date).cover?(project_week.date_range.begin) }.first
    @project_week = ProjectWeek.default unless @project_week
  end

  def participations_on_day
    @date = params[:date].to_date
    @participations = Participation.where(created_at: @date.beginning_of_day..@date.end_of_day)
  end

  def occupancy
    @project_week = ProjectWeek.find_by_title(params[:title]) || ProjectWeek.default
    @projects = @project_week.projects.visible.sort_by { |project| sort_column(project) }
    if params[:direction] == 'desc'
      @projects.reverse!
    end
  end

  private
  def sort_column(project)
    case params[:sort]
      when 'volunteer_count'
        project.desired_team_size > 0 ? project.volunteers.count : project.aggregated_volunteers.count
      when 'free_places'
        project.desired_team_size > 0 ? project.desired_team_size - project.volunteers.count : project.aggregated_desired_team_size - project.aggregated_volunteers.count
      when 'desired_team_size'
        project.desired_team_size > 0 ? project.desired_team_size : project.aggregated_desired_team_size
      when 'occupancy'
        if project.desired_team_size > 0
          100 * project.volunteers.count / project.desired_team_size
        elsif project.aggregated_desired_team_size > 0
          100 * project.aggregated_volunteers.count / project.aggregated_desired_team_size
        else
          0
        end
      else
        project.title
    end
  end

end
