class ActionGroupPolicy < ApplicationPolicy

  class Scope < Scope
  end

  alias_method :show?, :always

  alias_method :index?, :is_admin?
  alias_method :create?, :is_admin?
  alias_method :edit?, :is_admin?
  alias_method :update?, :is_admin?
  alias_method :destroy?, :is_admin?

  # When adding tests with implementation uncomment respective line in .travis.yml!

end
