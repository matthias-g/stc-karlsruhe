class Action < Initiative

  belongs_to :action_group
  has_many :subactions, class_name: 'Action', foreign_key: :parent_action_id
  belongs_to :parent_action, class_name: 'Action', foreign_key: :parent_action_id, optional: true

  validate :parent_action_cannot_be_same_action, :parent_action_cannot_be_a_subaction
  after_initialize :set_default_values

  scope :toplevel, -> { where(initiatives: { parent_action_id: nil }) }


  def volunteers_in_subactions
    User.joins(events_as_volunteer: :initiative).where(initiatives: {parent_action_id: id, visible: true})
  end

  def leaders_in_subactions
    User.joins(:initiatives_as_leader).where(initiatives: {parent_action_id: id, visible: true})
  end

  def all_events
    Event.joins(:initiative).where('initiative_id = ? OR (initiatives.parent_action_id = ? AND initiatives.visible)', id, id)
  end

  def all_dates
    all_events.pluck(:date).compact.uniq.sort
  end


  def full_title
    subaction? ? parent_action.title + ' – ' + title : title
  end

  def status
    if finished?
      :finished
    elsif total_available_places.zero?
      :full
    else
      total_available_places < 3 ? :soon_full : :empty
    end
  end

  def date
    # TODO other cases
    events.count == 1 ? events.first.date : nil
  end

  def start_time
    # TODO other cases
    events.count == 1 ? events.first.start_time : nil
  end


  def finished?
    all_events.upcoming.empty?
  end

  def subaction?
    parent_action != nil
  end


  def available_places
    events.sum(&:available_places)
  end

  def desired_team_size
    events.sum(:desired_team_size)
  end

  def team_size
    events.sum(:team_size)
  end

  def total_available_places
    all_events.sum(&:available_places)
  end

  def total_team_size
    all_events.sum(:team_size)
  end

  def total_desired_team_size
    all_events.sum(:desired_team_size)
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

  def make_visible!
    super
    subactions.each(&:make_visible!) if subactions
  end

  def make_invisible!
    super
    subactions.each(&:make_invisible!) if subactions
  end

  protected

  def slug_candidates
    candidates = super
    candidates << [full_title, self.action_group.title] if self.action_group
    candidates
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

  def set_default_values
    self.action_group ||= ActionGroup.default if action_group.nil?
  end

end
