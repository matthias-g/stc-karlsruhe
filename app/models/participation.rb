class Participation < ApplicationRecord
  belongs_to :user
  belongs_to :event, counter_cache: :team_size

  validates_presence_of :user, :event
end
