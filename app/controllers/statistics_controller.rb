class StatisticsController < ApplicationController
  before_action :authenticate_admin_or_coordinator!
  before_action :set_action_group

  def participations
    @participations = participations_for(@action_group).group_by_day('participations.created_at').count
  end

  def participations_on_day
    @date = params[:date].to_date
    @participations = participations_for(@action_group).where(
        participations: {created_at: @date.beginning_of_day..@date.end_of_day})
  end

  def occupancy
    @actions = @action_group.actions.visible.sort_by { |action| sort_column(action) }
    if params[:direction] == 'desc'
      @actions.reverse!
    end
  end

  private

  def sort_column(action)
    case params[:sort]
      when 'volunteer_count'
        action.desired_team_size > 0 ? action.volunteers.count : action.total_team_size
      when 'free_places'
        action.desired_team_size > 0 ? action.desired_team_size - action.volunteers.count : action.total_desired_team_size - action.total_team_size
      when 'desired_team_size'
        action.desired_team_size > 0 ? action.desired_team_size : action.total_desired_team_size
      when 'occupancy'
        if action.desired_team_size > 0
          100 * action.volunteers.count / action.desired_team_size
        elsif action.total_desired_team_size > 0
          100 * action.total_team_size / action.total_desired_team_size
        else
          0
        end
      else
        action.title
    end
  end

  def participations_for(action_group)
    Participation.left_joins(event: :initiative).where(actions: {action_group_id: action_group})
  end

  def set_action_group
    @action_group = params[:action_group] ? ActionGroup.friendly.find(params[:action_group]) : ActionGroup.default
  end

end
