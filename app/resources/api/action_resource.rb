class Api::ActionResource < Api::InitiativeResource
  has_one :action_group
  has_one :parent_action, class_name: 'Action'
end
