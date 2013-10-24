class Project < ActiveRecord::Base
  attr_accessible :description, :individual_tasks, :name, :requirements
end
