module ActionGroupsHelper

  def options_for_day_select(action_group)
    action_groups = [action_group].flatten
    dates = action_groups.collect{ |group| group.date_range.to_a }.flatten
    format = :short_with_weekday
    format = :weekday_and_year if action_groups.count > 1
    dates.map{ |date| [I18n.l(date, format: format), date.strftime("%F")]}
  end

  def date_range(from_date, until_date, options = {})
    options.symbolize_keys!
    format = options[:format] || :short
    separator = options[:separator] || "—"

    if format.to_sym == :short
      month_names = I18n.t("date.abbr_month_names")
    else
      month_names = I18n.t("date.month_names")
    end

    from_day = from_date.day
    from_month = month_names[from_date.month]
    from_year = from_date.year
    until_day = until_date.day

    dates = { from_day: from_day }

    if from_date.day == until_date.day && from_date.month == until_date.month && from_date.year == until_date.year
      date_format = "same_day"
      dates.merge!(day: from_day, month: from_month, year: from_year)
    elsif from_date.month == until_date.month && from_date.year == until_date.year
      date_format = "same_month"
      dates.merge!(until_day: until_day, month: from_month, year: from_year)
    else
      until_month = month_names[until_date.month]

      dates.merge!(from_month: from_month, until_month: until_month, until_day: until_day)

      if from_date.year == until_date.year
        date_format = "different_months_same_year"
        dates.merge!(year: from_year)
      else
        until_year = until_date.year

        date_format = "different_years"
        dates.merge!(from_year: from_year, until_year: until_year)
      end
    end

    I18n.t("date_range.#{format}.#{date_format}", dates.merge(sep: separator))
  end

end
