class ProjectPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      if user&.in_orga_team?
        scope.all
      elsif user
        scope.left_outer_joins(:leaderships).where('initiatives.visible OR leaderships.user_id = ?', user.id).distinct
      else
        scope.where(visible: true).distinct
      end
    end
  end


  def show?
    record.visible? || edit?
  end

  def edit?
    is_admin_or_coordinator? || is_leader?
  end

  def contact_volunteers?
    record.visible? && edit?
  end

  def contact_leaders?
    record.visible? && is_volunteer?
  end

  def upload_pictures?
    is_volunteer? || is_leader? || is_admin_or_coordinator? || user&.photographer?
  end


  alias_method :index?, :is_admin_or_coordinator?
  alias_method :create?, :is_admin_or_coordinator?

  alias_method :update?, :edit?
  alias_method :destroy?, :edit?
  alias_method :crop_picture?, :edit?
  alias_method :crop_picture_modal?, :edit?

  alias_method :manage_team?, :edit?
  alias_method :delete_leader?, :manage_team?

  alias_method :change_visibility?, :is_admin_or_coordinator?
  alias_method :make_visible?, :change_visibility?
  alias_method :make_invisible?, :change_visibility?


  def permitted_attributes_for_show
    [:title, :description, :location, :latitude, :longitude, :individual_tasks, :material, :requirements,
     :visible, :short_description, :map_latitude, :map_longitude, :map_zoom,
     :picture, :picture_source, :events, :leaders, :volunteers, :tags]
  end

  def updatable_fields
    all_fields = [:title, :description, :location, :latitude, :longitude, :individual_tasks, :material, :requirements,
                  :visible, :short_description, :map_latitude, :map_longitude, :map_zoom,
                  :picture, :picture_source, :events, :leaders, :volunteers, :tags]
    return all_fields - [:visible] unless is_admin_or_coordinator?
    all_fields
  end


  private

  def is_leader?
    record.leader?(user)
  end

  def is_volunteer?
    record.volunteer?(user)
  end

end
