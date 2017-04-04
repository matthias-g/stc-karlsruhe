require 'icalendar'

class IcalController < ApplicationController
  include Icalendar
  include ApplicationHelper

  after_action :verify_authorized, except: :all_projects
  after_action :verify_policy_scoped, only: :all_projects
  after_action :set_headers

  def projects
    project = Project.friendly.find(params[:project_id])
    authorize project, :show?
    calendar = Calendar.new

    add_project_to_calendar(project, calendar)

    @filename = project.title
    ical_feed = calendar.to_ical
    render text: ical_feed
  end

  def project_weeks
    project_week = ProjectWeek.find(params[:project_week_id])
    authorize project_week, :show?
    calendar = Calendar.new

    policy_scope(project_week.projects).each do |project|
      add_project_to_calendar(project, calendar)
    end

    @filename = I18n.t('ical.label.project_weeks', project_week: project_week.title)
    ical_feed = calendar.to_ical
    render text: ical_feed
  end

  def users
    user = User.find(params[:user_id])
    authorize user, :show?
    calendar = Calendar.new

    policy_scope(user.projects).each do |project|
      add_project_to_calendar(project, calendar)
    end

    @filename = I18n.t('ical.label.users', name: user.first_name)
    ical_feed = calendar.to_ical
    render text: ical_feed
  end

  def all_projects
    calendar = Calendar.new

    policy_scope(Project).each do |project|
      add_project_to_calendar(project, calendar)
    end

    @filename = I18n.t('ical.label.all_projects')
    ical_feed = calendar.to_ical
    render text: ical_feed
  end

  private

  def set_headers
    headers['Content-Type'] = 'text/calendar'
    if @filename
      headers['Content-Disposition'] = "attachment; filename=\"#{@filename}.ics\""
    else
      headers['Content-Disposition'] = 'attachment'
    end
  end

  def add_project_to_calendar(project, calendar)
    project.days.each do |project_day|
      calendar.event do |event|

        date = project_day.date
        if project.start_time
          event_start = DateTime.new(date.year, date.month, date.day, project.start_time.hour, project.start_time.min, 0)
          event.dtstart =  Values::DateTime.new event_start
        end
        if project.end_time
          event_end = DateTime.new(date.year, date.month, date.day, project.end_time.hour, project.end_time.min, 0)
          event.dtend =  Values::DateTime.new event_end
        end
        event.summary = project.title
        event.location = project.location.gsub(/\s*\r?\n\s*/, ', ')
        event.description = format_urls_no_html(project.description)
        event.categories = project.project_week.title
        event.url = project_url(project)
      end
    end
  end
end