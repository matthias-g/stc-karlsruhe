module ActionsHelper

  # gives a list of all possible parent actions
  def possible_parent_actions(action)
    actions = action.action_group ? action.action_group.actions : Action.where(action_group: nil)
    actions = policy_scope(actions.where(parent_action_id: nil)) - [action]
    actions.pluck(:title, :id)
  end

  def show_invisible_pictures_notification?(gallery)
    return false unless current_user
    gallery.gallery_pictures.invisible.where(uploader_id: current_user.id).any? ||
        (current_user&.in_orga_team? && gallery.gallery_pictures.invisible.any?)
  end

  def has_gallery_pictures?(gallery)
    gallery && policy_scope(gallery.gallery_pictures).any?
  end

end
