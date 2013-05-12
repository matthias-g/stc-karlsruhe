
FactoryGirl.define do
  factory :project, :class => Refinery::Projects::Project do
    sequence(:title) { |n| "refinery#{n}" }
  end
end

