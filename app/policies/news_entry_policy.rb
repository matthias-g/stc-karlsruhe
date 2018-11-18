class NewsEntryPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      user&.in_orga_team? ? scope.all : scope.visible
    end
  end


  alias_method :edit?, :is_admin_or_coordinator?
  alias_method :new?, :edit?
  alias_method :create?, :edit?
  alias_method :update?, :edit?
  alias_method :destroy?, :edit?
  alias_method :upload_pictures?, :edit?
  alias_method :crop_picture?, :edit?

end
