module Refinery::Projects::Admin::ProjectsHelper
  def usernames
    Refinery::User.all.collect{|u| u.username }
  end

  def project_days
    Refinery::Projects::Day.all.collect{|d| d.title}
  end

  def project_locations
    Refinery::Projects::Location.all.collect{|l| l.title}
  end

  def project_sectors
    Refinery::Projects::Sector.all.collect{|s| s.title}
  end

  def project_types
    Refinery::Projects::Type.all.collect{|t| t.title}
  end

  def project_volunteer_types
    Refinery::Projects::VolunteerType.all.collect{|vt| vt.title}
  end
end