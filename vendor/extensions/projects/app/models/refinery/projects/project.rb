module Refinery
  module Projects
    class Project < Refinery::Core::BaseModel
      self.table_name = 'refinery_projects'

      attr_accessible :title, :description, :start, :end, :image_id, :position, :leaders
      attr_accessible :types, :sectors, :volunteer_types, :locations, :days

      acts_as_indexed :fields => [:title, :description]

      validates :title, :presence => true, :uniqueness => true

      belongs_to :image, :class_name => '::Refinery::Image'

      has_and_belongs_to_many :volunteers, :class_name => '::Refinery::User', :join_table => :refinery_projects_volunteers
      has_and_belongs_to_many :leaders, :class_name => '::Refinery::User', :join_table => :refinery_projects_leaders

      has_and_belongs_to_many :types, :class_name => 'Refinery::Projects::Type', :join_table => :refinery_projects_projects_types
      has_and_belongs_to_many :sectors, :class_name => 'Refinery::Projects::Sector', :join_table => :refinery_projects_projects_sectors
      has_and_belongs_to_many :volunteer_types, :class_name => 'Refinery::Projects::VolunteerType', :join_table => :refinery_projects_projects_volunteer_types
      has_and_belongs_to_many :locations, :class_name => 'Refinery::Projects::Location', :join_table => :refinery_projects_projects_locations
      has_and_belongs_to_many :days, :class_name => 'Refinery::Projects::Day', :join_table => :refinery_projects_projects_days



      # TODO
      # ausgewählte items in edit selected
      # nicht mehr ausgewählte beim Speichern löschen



      # TODO are those setter methods really necessary? (it's a bit dirty...)
      def leaders=(leadernames)
        leadernames.each { |leadername|
          unless has_leader?(leadername)
            new_leader = ::Refinery::User.find_by_username(leadername)
            leaders << new_leader if new_leader
          end
        }
      end

      def types=(titles)
        titles.each { |title|
          unless has_type?(title)
            new_type = Refinery::Projects::Type.find_by_title(title)
            types << new_type if new_type
          end
        }
      end

      def sectors=(titles)
        titles.each { |title|
          unless has_sector?(title)
            new_sector = Refinery::Projects::Sector.find_by_title(title)
            sectors << new_sector if new_sector
          end
        }
      end

      def volunteer_types=(titles)
        titles.each { |title|
          unless has_volunteer_type?(title)
            new_volunteer_type = Refinery::Projects::VolunteerType.find_by_title(title)
            volunteer_types << new_volunteer_type if new_volunteer_type
          end
        }
      end

      def locations=(titles)
        titles.each { |title|
          unless has_location?(title)
            new_location = Refinery::Projects::Location.find_by_title(title)
            locations << new_location if new_location
          end
        }
      end

      def days=(titles)
        titles.each { |title|
          unless has_day?(title)
            new_day = Refinery::Projects::Day.find_by_title(title)
            days << new_day if new_day
          end
        }
      end

      def has_type?(type)
        return false unless type
        if type.is_a?(Refinery::Projects::Type)
          title = type.title
        else
          title = type
        end
        types.any?{|t| t.title == title}
      end

      def has_sector?(sector)
        return false unless sector
        if sector.is_a?(Refinery::Projects::Sector)
          title = sector.title
        else
          title = sector
        end
        sectors.any?{|s| s.title == title}
      end

      def has_volunteer_type?(volunteer_type)
        return false unless volunteer_type
        if volunteer_type.is_a?(Refinery::Projects::VolunteerType)
          title = volunteer_type.title
        else
          title = volunteer_type
        end
        volunteer_types.any?{|vt| vt.title == title}
      end

      def has_location?(location)
        return false unless location
        if location.is_a?(Refinery::Projects::Location)
          title = location.title
        else
          title = location
        end
        locations.any?{|l| l.title == title}
      end

      def has_day?(day)
        return false unless day
        if day.is_a?(Refinery::Projects::Day)
          title = day.title
        else
          title = day
        end
        days.any?{|d| d.title == title}
      end

      def add_leader(user)
        raise ArgumentException, "User should be a user object." unless user.is_a?(::Refinery::User)
        leaders << user unless has_leader?(user)
      end

      def has_leader?(user)
        return false unless user
        if user.is_a?(::Refinery::User)
          username = user.username
        else
          username = user
        end
        leaders.any?{|v| v.username == username}
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
