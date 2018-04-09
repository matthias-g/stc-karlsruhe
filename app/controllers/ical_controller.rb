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
    action.events.each do |event|
      calendar.event do |cal_event|
        date = event.date
        if event.start_time
          event_start = DateTime.new(date.year, date.month, date.day, event.start_time.hour, event.start_time.min, 0)
          cal_event.dtstart = Values::DateTime.new event_start
        else
          cal_event.dtstart = Values::Date.new date
          cal_event.duration = Values::Duration.new '1D'
        end
        if event.end_time
          event_end = DateTime.new(date.year, date.month, date.day, event.end_time.hour, event.end_time.min, 0)
          cal_event.dtend = Values::DateTime.new event_end
        end
        cal_event.summary = action.title
        cal_event.location = action.location.gsub(/\s*\r?\n\s*/, ', ')
        cal_event.description = format_urls_no_html(action.description)
        cal_event.categories = action.action_group.title if action.action_group
        cal_event.url = action_url(action)
      end
    end
  end
end