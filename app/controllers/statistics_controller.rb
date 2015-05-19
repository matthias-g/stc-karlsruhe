class StatisticsController < ApplicationController
  before_action :authenticate_admin_user!

  def participations
    @participations = Participation.where(as_leader: false)
  end

  def participations_per_day
    @date = params[:date].to_date
    @participations = Participation.where(as_leader: false).where(created_at: @date.beginning_of_day..@date.end_of_day)
  end

end
