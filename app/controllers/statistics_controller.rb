class StatisticsController < ApplicationController
  before_action :authenticate_admin_user!

  def participations
    @participations = Participation.where(as_leader: false)
  end

  def participations_on_day
    @date = params[:date].to_date
    @participations = Participation.where(as_leader: false).where(created_at: @date.beginning_of_day..@date.end_of_day)
  end

  def occupancy
    @projects = ProjectWeek.default.projects.visible.sort_by { |project| sort_column(project) }
    if params[:direction] == 'desc'
      @projects.reverse!
    end
  end

  private
  def sort_column(project)
    case params[:sort]
      when 'volunteer_count'
        project.volunteers.count
      when 'free_places'
        project.desired_team_size - project.volunteers.count
      when 'desired_team_size'
        project.desired_team_size
      when 'occupancy'
        project.desired_team_size > 0 ? 100 * project.volunteers.count / project.desired_team_size : 0
      else
        project.title
    end
  end

end
