module ActionGroupsHelper

  # Gives a list of all days (date + label) within the action group
  def options_for_day_select(action_group)
    action_groups = [action_group].flatten
    dates = action_groups.collect{ |group| group.date_range.to_a }.flatten
    format = :short_with_weekday
    format = :weekday_and_year if action_groups.count > 1
    dates.map{ |date| [I18n.l(date, format: format), date.strftime("%F")]}
  end

  # Splits the action group title, separating a possible "Aktionswoche" or "Aktionstag" prefix
  def split_action_group_type_prefix(title)
    temp_title = title.dup
    return temp_title.slice!(/Aktionswoche|Aktionstag/), temp_title.strip
  end

  # Gives the (chronologically) previous and next action groups
  def get_connected_action_groups(action_group)
    groups = ActionGroup.all.order(:start_date)
    group_index = groups.index(action_group)
    previous_group = group_index.positive? ? groups[group_index - 1] : nil
    next_group = groups[group_index + 1]
    return previous_group, next_group
  end

  # Gives the correct preposition for the group title (or date) depending on usage
  def action_group_declination(action_group, usage)
    is_day = (action_group.start_date == action_group.end_date)
    case usage
    when :temporal
      t('general.declination.' + (is_day ? 'at.' : 'in.')  + action_group.declination)
    when :nominative
      t('general.declination.the.' + action_group.declination)
    when :date_range
      t('general.declination.' + (is_day ? 'at.m_sg' : 'from.m_sg'))
    end
  end

  # Smartly formats and localizes a date range
  def date_range(from_date, until_date, options = {})
    options.symbolize_keys!
    format = options[:format] || :short
    separator = options[:separator] || "-"

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
