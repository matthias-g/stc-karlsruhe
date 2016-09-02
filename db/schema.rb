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

ActiveRecord::Schema.define(version: 20160704161940) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",               null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "galleries", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gallery_pictures", force: :cascade do |t|
    t.integer  "gallery_id"
    t.string   "picture",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "uploader_id"
    t.integer  "width"
    t.integer  "height"
    t.boolean  "visible",                    default: false
    t.integer  "desktop_width"
    t.integer  "desktop_height"
    t.index ["visible"], name: "index_gallery_pictures_on_visible", using: :btree
  end

  create_table "leaderships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id", "project_id"], name: "index_leaderships_on_user_id_and_project_id", unique: true, using: :btree
  end

  create_table "news_entries", force: :cascade do |t|
    t.string   "title"
    t.string   "teaser"
    t.string   "text"
    t.string   "picture"
    t.string   "picture_source"
    t.integer  "category"
    t.boolean  "visible"
    t.string   "slug"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "gallery_id"
    t.index ["gallery_id"], name: "index_news_entries_on_gallery_id", using: :btree
    t.index ["slug"], name: "index_news_entries_on_slug", using: :btree
  end

  create_table "orga_messages", force: :cascade do |t|
    t.string   "from"
    t.string   "recipient"
    t.string   "content_type"
    t.string   "subject"
    t.text     "body"
    t.integer  "author_id"
    t.datetime "sent_at"
    t.integer  "sender_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "participations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_days", force: :cascade do |t|
    t.string   "title",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_week_id"
    t.date     "date"
  end

  create_table "project_days_projects", id: false, force: :cascade do |t|
    t.integer "project_id",     null: false
    t.integer "project_day_id", null: false
    t.index ["project_day_id", "project_id"], name: "index_project_days_projects_on_project_day_id_and_project_id", using: :btree
    t.index ["project_id", "project_day_id"], name: "index_project_days_projects_on_project_id_and_project_day_id", using: :btree
  end

  create_table "project_weeks", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.boolean  "default"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: :cascade do |t|
    t.string   "title",             limit: 255
    t.text     "description"
    t.string   "location",          limit: 255
    t.float    "latitude"
    t.float    "longitude"
    t.text     "individual_tasks"
    t.text     "material"
    t.text     "requirements"
    t.boolean  "visible"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture",           limit: 255
    t.integer  "desired_team_size"
    t.integer  "status",                        default: 1
    t.string   "time",              limit: 255
    t.text     "short_description",             default: ""
    t.float    "map_latitude",                  default: 49.01347014
    t.float    "map_longitude",                 default: 8.40445518
    t.integer  "map_zoom",                      default: 12
    t.text     "picture_source"
    t.integer  "project_week_id"
    t.string   "slug",              limit: 255
    t.integer  "parent_project_id"
    t.integer  "gallery_id"
    t.index ["gallery_id"], name: "index_projects_on_gallery_id", using: :btree
    t.index ["slug"], name: "index_projects_on_slug", unique: true, using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "role_id", null: false
    t.index ["user_id", "role_id"], name: "index_roles_users_on_user_id_and_role_id", using: :btree
  end

  create_table "surveys_answers", force: :cascade do |t|
    t.integer  "submission_id"
    t.integer  "question_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["question_id"], name: "index_surveys_answers_on_question_id", using: :btree
    t.index ["submission_id"], name: "index_surveys_answers_on_submission_id", using: :btree
  end

  create_table "surveys_questions", force: :cascade do |t|
    t.integer  "template_id"
    t.text     "text"
    t.text     "answer_options"
    t.integer  "question_type"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_subquestion", default: false
    t.text     "explanation"
    t.index ["template_id"], name: "index_surveys_questions_on_template_id", using: :btree
  end

  create_table "surveys_submissions", force: :cascade do |t|
    t.integer  "template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.index ["template_id"], name: "index_surveys_submissions_on_template_id", using: :btree
  end

  create_table "surveys_templates", force: :cascade do |t|
    t.string   "title",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug",                 limit: 255
    t.boolean  "show_in_user_profile",             default: false
    t.index ["slug"], name: "index_surveys_templates_on_slug", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",                              limit: 255
    t.string   "first_name",                            limit: 255
    t.string   "last_name",                             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                                 limit: 255, default: "",    null: false
    t.string   "encrypted_password",                    limit: 255, default: "",    null: false
    t.string   "reset_password_token",                  limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "phone",                                 limit: 255, default: ""
    t.boolean  "cleared",                                           default: false
    t.string   "authentication_token"
    t.boolean  "receive_emails_about_project_weeks",                default: true
    t.boolean  "receive_emails_about_my_project_weeks",             default: true
    t.boolean  "receive_emails_about_other_projects",               default: true
    t.boolean  "receive_other_emails_from_orga",                    default: true
    t.boolean  "receive_emails_from_other_users",                   default: true
    t.index ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["receive_emails_about_my_project_weeks"], name: "index_users_on_receive_emails_about_my_project_weeks", using: :btree
    t.index ["receive_emails_about_other_projects"], name: "index_users_on_receive_emails_about_other_projects", using: :btree
    t.index ["receive_emails_about_project_weeks"], name: "index_users_on_receive_emails_about_project_weeks", using: :btree
    t.index ["receive_emails_from_other_users"], name: "index_users_on_receive_emails_from_other_users", using: :btree
    t.index ["receive_other_emails_from_orga"], name: "index_users_on_receive_other_emails_from_orga", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

end
