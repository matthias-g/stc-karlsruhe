require 'icalendar'

class IcalController < ApplicationController
  include Icalendar
  include ApplicationHelper

  after_action :verify_authorized, except: [:all_actions, :users]
  after_action :verify_policy_scoped, only: [:all_actions, :users]
  after_action :set_headers

  def actions
    action = Action.friendly.find(params[:action_id])
    authorize action, :show?
    calendar = create_calendar

    add_action_to_calendar(action, calendar)

    @filename = action.title
    ical_feed = calendar.to_ical
    render plain: ical_feed
  end

  def action_groups
    action_group = ActionGroup.find(params[:action_group_id])
    authorize action_group, :show?
    calendar = create_calendar

    policy_scope(action_group.actions).each do |action|
      add_action_to_calendar(action, calendar)
    end

    @filename = I18n.t('ical.label.action_groups', action_group: action_group.title)
    ical_feed = calendar.to_ical
    render plain: ical_feed
  end

  def users
    user = User.find(params[:user_id])
    return not_found unless user.ical_token == params[:ical_token]
    calendar = create_calendar

    policy_scope(user.actions).each do |action|
      add_action_to_calendar(action, calendar)
    end

    @filename = I18n.t('ical.label.users', name: user.first_name)
    ical_feed = calendar.to_ical
    render plain: ical_feed
  end

  def all_actions
    calendar = create_calendar

    policy_scope(Action).each do |action|
      add_action_to_calendar(action, calendar)
    end

    @filename = I18n.t('ical.label.all_actions')
    ical_feed = calendar.to_ical
    render plain: ical_feed
  end

  private

  def create_calendar
    calendar = Calendar.new
    calendar.prodid = 'STC Karlsruhe'
    calendar
  end

  def set_headers
    headers['Content-Type'] = 'text/calendar'
    if @filename
      headers['Content-Disposition'] = "attachment; filename=\"#{@filename}.ics\""
    else
      headers['Content-Disposition'] = 'attachment'
    end
  end

  def add_action_to_calendar(action, calendar)
    action.dates.each do |date|
      calendar.event do |event|
        if action.start_time
          event_start = DateTime.new(date.year, date.month, date.day, action.start_time.hour, action.start_time.min, 0)
          event.dtstart = Values::DateTime.new event_start
        else
          event.dtstart = Values::Date.new date
          event.duration = Values::Duration.new '1D'
        end
        if action.end_time
          event_end = DateTime.new(date.year, date.month, date.day, action.end_time.hour, action.end_time.min, 0)
          event.dtend = Values::DateTime.new event_end
        end
        event.summary = action.title
        event.location = action.location.gsub(/\s*\r?\n\s*/, ', ')
        event.description = format_urls_no_html(action.description)
        event.categories = action.action_group.title if action.action_group
        event.url = action_url(action)
      end
    end
  end
end