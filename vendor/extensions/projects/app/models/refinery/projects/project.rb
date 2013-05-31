module Refinery
  module Projects
    class Project < Refinery::Core::BaseModel
      self.table_name = 'refinery_projects'

      attr_accessible :title, :description, :start, :end, :image_id, :position

      acts_as_indexed :fields => [:title, :description]

      validates :title, :presence => true, :uniqueness => true

      belongs_to :image, :class_name => '::Refinery::Image'

      has_and_belongs_to_many :volunteers, :class_name => '::Refinery::User', :join_table => :refinery_projects_volunteers
      has_and_belongs_to_many :leaders, :class_name => '::Refiney::User', :join_table => :refinery_projects_leaders

      def add_leader(user)
        raise ArgumentException, "User should be a user object." unless user.is_a?(::Refinery::User)
        leaders << user unless has_leader?(user)
      end

      def has_leader?(user)
        return false unless user
        raise ArgumentException, "User should be a user object." unless user.is_a?(::Refinery::User)
        leaders.any?{|v| v.username == user.username}
      end

      def add_volunteer(user)
        raise ArgumentException, "User should be a user object." unless user.is_a?(::Refinery::User)
        volunteers << user unless has_volunteer?(user)
      end

      def has_volunteer?(user)
        return false unless user
        raise ArgumentException, "User should be a user object." unless user.is_a?(::Refinery::User)
        volunteers.any?{|v| v.username == user.username}
      end

      def delete_volunteer(user)
        if has_volunteer?(user)
          volunteers.delete(user)
        end
      end

    end
  end
end
