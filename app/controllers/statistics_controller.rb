class StatisticsController < ApplicationController
  before_action :authenticate_admin_or_coordinator!

  def participations
    @end_date = params[:date]&.to_date || Date.tomorrow
    @start_date = @end_date - 60
    @action_group = ActionGroup.all.to_a.select { |action_group| (@start_date..@end_date).cover?(action_group.date_range.begin) }.first
    @action_group = ActionGroup.default unless @action_group
  end

  def participations_on_day
    @date = params[:date].to_date
    @participations = Participation.where(created_at: @date.beginning_of_day..@date.end_of_day)
  end

  def occupancy
    @action_group = ActionGroup.find_by_title(params[:title]) || ActionGroup.default
    @actions = @action_group.actions.visible.sort_by { |action| sort_column(action) }
    if params[:direction] == 'desc'
      @actions.reverse!
    end
  end

  private
  def sort_column(action)
    case params[:sort]
      when 'volunteer_count'
        action.desired_team_size > 0 ? action.volunteers.count : action.aggregated_volunteers.count
      when 'free_places'
        action.desired_team_size > 0 ? action.desired_team_size - action.volunteers.count : action.aggregated_desired_team_size - action.aggregated_volunteers.count
      when 'desired_team_size'
        action.desired_team_size > 0 ? action.desired_team_size : action.aggregated_desired_team_size
      when 'occupancy'
        if action.desired_team_size > 0
          100 * action.volunteers.count / action.desired_team_size
        elsif action.aggregated_desired_team_size > 0
          100 * action.aggregated_volunteers.count / action.aggregated_desired_team_size
        else
          0
        end
      else
        action.title
    end
  end

end
