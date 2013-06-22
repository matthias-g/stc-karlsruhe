module Refinery::Projects::ProjectsHelper

  def missing_volunteer_count
    if @project.max_volunteer_count
      missing_volunteers = @project.max_volunteer_count - @project.volunteers.count
      if missing_volunteers > 0
        "<div class='prj-places lightbox' style='background: #8cc394'> Noch #{missing_volunteers} Pl&auml;tze </div>"
      else
        "<div class='prj-places lightbox' style='background: #ee7c9a'> Vollbesetzt </div>"
      end
    else
      "<div class='prj-places lightbox' style='background: #8cc394'> Unbegrenzt freie Pl&auml;tze </div>"
    end
  end

  def linkname(user)
    if user.username.match(/\s/)
      user.id
    else
      user.username
    end
  end
end