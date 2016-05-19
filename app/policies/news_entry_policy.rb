class NewsEntryPolicy < ApplicationPolicy

  def show?
    record.visible? || edit?
  end

  def edit?
    user && user.admin?
  end

  alias_method :new?, :edit?
  alias_method :create?, :edit?
  alias_method :update?, :edit?
  alias_method :destroy?, :edit?
  alias_method :upload_pictures?, :edit?
  alias_method :crop_picture?, :edit?

  class Scope < Scope
    def resolve
      if user && user.admin?
        scope.all
      else
        scope.visible
      end
    end
  end

end
