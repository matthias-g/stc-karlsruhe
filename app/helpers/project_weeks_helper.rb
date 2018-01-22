module ProjectWeeksHelper

  def options_for_day_select(project_week)
    project_weeks = [project_week].flatten
    dates = project_weeks.collect{ |week| week.date_range.to_a }.flatten
    format = :short_with_weekday
    format = :weekday_and_year if project_weeks.count > 1
    dates.map{ |date| [I18n.l(date, format: format), date.strftime("%F")]}
  end

end
