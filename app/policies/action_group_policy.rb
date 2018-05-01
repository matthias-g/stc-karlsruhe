class ActionGroupPolicy < ApplicationPolicy

  class Scope < Scope
  end

  alias_method :index?, :is_admin?
  alias_method :show?, :always
  alias_method :create?, :is_admin?
  alias_method :edit?, :is_admin?
  alias_method :update?, :edit?
  alias_method :destroy?, :edit?

end
