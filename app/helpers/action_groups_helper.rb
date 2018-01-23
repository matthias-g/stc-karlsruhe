module ActionGroupsHelper

  def options_for_day_select(action_group)
    action_groups = [action_group].flatten
    dates = action_groups.collect{ |group| group.date_range.to_a }.flatten
    format = :short_with_weekday
    format = :weekday_and_year if action_groups.count > 1
    dates.map{ |date| [I18n.l(date, format: format), date.strftime("%F")]}
  end

end
