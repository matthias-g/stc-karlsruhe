# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150309100432) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "participations", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.boolean  "as_leader",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participations", ["user_id", "project_id", "as_leader"], name: "index_participations_on_user_id_and_project_id_and_as_leader", unique: true, using: :btree

  create_table "project_days", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_week_id"
    t.date     "date"
  end

  create_table "project_days_projects", id: false, force: true do |t|
    t.integer "project_id",     null: false
    t.integer "project_day_id", null: false
  end

  add_index "project_days_projects", ["project_day_id", "project_id"], name: "index_project_days_projects_on_project_day_id_and_project_id", using: :btree
  add_index "project_days_projects", ["project_id", "project_day_id"], name: "index_project_days_projects_on_project_id_and_project_day_id", using: :btree

  create_table "project_weeks", force: true do |t|
    t.string   "title"
    t.boolean  "default"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "location"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "individual_tasks"
    t.text     "material"
    t.text     "requirements"
    t.boolean  "visible"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture"
    t.integer  "desired_team_size"
    t.integer  "status",            default: 1
    t.string   "time"
    t.text     "short_description", default: ""
    t.float    "map_latitude",      default: 49.01347014
    t.float    "map_longitude",     default: 8.40445518
    t.integer  "map_zoom",          default: 12
    t.text     "picture_source"
    t.integer  "project_week_id"
  end

  create_table "roles", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", id: false, force: true do |t|
    t.integer "user_id", null: false
    t.integer "role_id", null: false
  end

  add_index "roles_users", ["user_id", "role_id"], name: "index_roles_users_on_user_id_and_role_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
