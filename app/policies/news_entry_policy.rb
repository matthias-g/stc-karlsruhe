class NewsEntryPolicy < ApplicationPolicy

  def show?
    record.visible? || edit?
  end

  def edit?
    is_admin? || is_coordinator?
  end

  alias new? edit?
  alias create? edit?
  alias update? edit?
  alias destroy? edit?
  alias upload_pictures? edit?
  alias crop_picture? edit?

  class Scope < Scope
    def resolve
      if user&.admin? || user&.coordinator?
        scope.all
      else
        scope.visible
      end
    end
  end

end
