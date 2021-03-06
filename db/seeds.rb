# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Role.create!(title: :admin)
Role.create!(title: :coordinator)
Role.create!(title: :photographer)
Role.create!(title: :notifications)
ActionGroup.create!(default: true, title: Time.now.year.to_s, start_date: 2.days.ago, end_date: 3.days.from_now)