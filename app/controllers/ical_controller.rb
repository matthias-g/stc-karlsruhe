require 'icalendar'

class IcalController < ApplicationController
  include Icalendar
  include ApplicationHelper

  after_action :verify_authorized, except: [:all_projects, :users]
  after_action :verify_policy_scoped, only: [:all_projects, :users]
  after_action :set_headers

  def projects
    project = Project.friendly.find(params[:project_id])
    authorize project, :show?
    calendar = create_calendar

    add_project_to_calendar(project, calendar)

    @filename = project.title
    ical_feed = calendar.to_ical
    render plain: ical_feed
  end

  def project_weeks
    project_week = ProjectWeek.find(params[:project_week_id])
    authorize project_week, :show?
    calendar = create_calendar

    policy_scope(project_week.projects).each do |project|
      add_project_to_calendar(project, calendar)
    end

    @filename = I18n.t('ical.label.project_weeks', project_week: project_week.title)
    ical_feed = calendar.to_ical
    render plain: ical_feed
  end

  def users
    user = User.find(params[:user_id])
    return not_found unless user.ical_token == params[:ical_token]
    calendar = create_calendar

    policy_scope(user.projects).each do |project|
      add_project_to_calendar(project, calendar)
    end

    @filename = I18n.t('ical.label.users', name: user.first_name)
    ical_feed = calendar.to_ical
    render plain: ical_feed
  end

  def all_projects
    calendar = create_calendar

    policy_scope(Project).each do |project|
      add_project_to_calendar(project, calendar)
    end

    @filename = I18n.t('ical.label.all_projects')
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

  def add_project_to_calendar(project, calendar)
    project.dates.each do |date|
      calendar.event do |event|
        if project.start_time
          event_start = DateTime.new(date.year, date.month, date.day, project.start_time.hour, project.start_time.min, 0)
          event.dtstart = Values::DateTime.new event_start
        else
          event.dtstart = Values::Date.new date
          event.duration = Values::Duration.new '1D'
        end
        if project.end_time
          event_end = DateTime.new(date.year, date.month, date.day, project.end_time.hour, project.end_time.min, 0)
          event.dtend = Values::DateTime.new event_end
        end
        event.summary = project.title
        event.location = project.location.gsub(/\s*\r?\n\s*/, ', ')
        event.description = format_urls_no_html(project.description)
        event.categories = project.project_week.title if project.project_week
        event.url = project_url(project)
      end
    end
  end
end