class Event < ApplicationRecord

  belongs_to :initiative, class_name: 'Action'

  # has_many :participations, dependent: :destroy
  # has_many :volunteers, class_name: 'User', through: :participations, source: :user,
  #          after_add: :on_volunteer_added, after_remove: :on_volunteer_removed
end
