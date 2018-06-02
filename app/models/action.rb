class Action < Initiative

  belongs_to :action_group
  has_many :subactions, class_name: 'Action', foreign_key: :parent_action_id
  belongs_to :parent_action, class_name: 'Action', foreign_key: :parent_action_id, optional: true

  validate :parent_action_cannot_be_same_action, :parent_action_cannot_be_a_subaction

  scope :toplevel, -> { where(initiatives: { parent_action_id: nil }) }

  def volunteers_in_subactions
    User.joins(events_as_volunteer: :initiative).where(initiatives: {parent_action_id: id, visible: true})
  end

  def leaders_in_subactions
    User.joins(:initiatives_as_leader).where(initiatives: {parent_action_id: id, visible: true})
  end

  def date
    # TODO other cases
    events.count == 1 ? events.first.date : nil
  end

  def start_time
    # TODO other cases
    events.count == 1 ? events.first.start_time : nil
  end

  def all_events
    Event.joins(:initiative).where('initiative_id = ? OR (initiatives.parent_action_id = ? AND initiatives.visible)', id, id)
  end

  def subaction?
    parent_action != nil
  end

  def full_title
    subaction? ? parent_action.title + ' – ' + title : title
  end

  def clone
    action_copy = dup
    action_copy.title = I18n.t('general.label.copyOf', title: title)
    action_copy.action_group = ActionGroup.all.order(start_date: :desc).first
    action_copy.parent_action = nil
    action_copy.gallery = Gallery.create!
    action_copy.save!
    action_copy.picture = picture.dup
    action_copy.picture.store!
    action_copy
  end


  private

  def parent_action_cannot_be_same_action
    if parent_action == self
      errors.add(:parent_action, "can't be same action")
    end
  end

  def parent_action_cannot_be_a_subaction
    if parent_action&.parent_action
      errors.add(:parent_action, "can't be a subaction itself")
    end
  end

end
