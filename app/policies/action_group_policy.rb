class ActionGroupPolicy < ApplicationPolicy

  class Scope < Scope
  end

  alias_method :show?, :always

  alias_method :index?, :is_admin?
  alias_method :create?, :is_admin?
  alias_method :edit?, :is_admin?
  alias_method :update?, :is_admin?
  alias_method :destroy?, :is_admin?

  def permitted_attributes_for_show
    [:title, :default, :start_date, :end_date, :declination, :actions,
     :action_count, :active_user_count, :available_places_count]
  end

  def updatable_fields
    [:title, :default, :start_date, :end_date, :declination, :actions]
  end
end
