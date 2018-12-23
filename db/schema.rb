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

ActiveRecord::Schema.define(version: 2018_11_26_202629) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_groups", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.boolean "default"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date "start_date"
    t.date "end_date"
    t.string "slug"
    t.integer "declination", default: 0
    t.integer "action_count", default: 0
    t.integer "active_user_count", default: 0
    t.integer "available_places_count", default: 0
    t.index ["slug"], name: "index_action_groups_on_slug", unique: true
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "events", force: :cascade do |t|
    t.date "date"
    t.string "time"
    t.integer "initiative_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "desired_team_size"
    t.integer "team_size", default: 0, null: false
    t.datetime "start_time"
    t.datetime "end_time"
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", limit: 255, null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope", limit: 255
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "galleries", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "owner_type"
    t.bigint "owner_id"
    t.index ["owner_type", "owner_id"], name: "index_galleries_on_owner_type_and_owner_id"
  end

  create_table "gallery_pictures", id: :serial, force: :cascade do |t|
    t.integer "gallery_id"
    t.string "picture", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "uploader_id"
    t.integer "width"
    t.integer "height"
    t.boolean "visible", default: false
    t.integer "desktop_width"
    t.integer "desktop_height"
    t.index ["visible"], name: "index_gallery_pictures_on_visible"
  end

  create_table "initiatives", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.text "description"
    t.string "location", limit: 255
    t.float "latitude"
    t.float "longitude"
    t.text "individual_tasks"
    t.text "material"
    t.text "requirements"
    t.boolean "visible"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "picture", limit: 255
    t.text "short_description", default: ""
    t.float "map_latitude", default: 49.01347014
    t.float "map_longitude", default: 8.40445518
    t.integer "map_zoom", default: 12
    t.text "picture_source"
    t.integer "action_group_id"
    t.string "slug", limit: 255
    t.integer "parent_action_id"
    t.string "type"
    t.string "icon"
    t.integer "subaction_count", default: 0
    t.index ["slug"], name: "index_initiatives_on_slug", unique: true
  end

  create_table "initiatives_tags", id: false, force: :cascade do |t|
    t.bigint "initiative_id", null: false
    t.bigint "tag_id", null: false
    t.index ["initiative_id"], name: "index_initiatives_tags_on_initiative_id"
    t.index ["tag_id"], name: "index_initiatives_tags_on_tag_id"
  end

  create_table "leaderships", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "initiative_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id", "initiative_id"], name: "index_leaderships_on_user_id_and_initiative_id", unique: true
  end

  create_table "news_entries", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "teaser"
    t.string "text"
    t.string "picture"
    t.string "picture_source"
    t.integer "category"
    t.boolean "visible"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_news_entries_on_slug"
  end

  create_table "orga_messages", id: :serial, force: :cascade do |t|
    t.string "from"
    t.string "recipient"
    t.string "content_type"
    t.string "subject"
    t.text "body"
    t.integer "author_id"
    t.datetime "sent_at"
    t.integer "sender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sent_to", default: ""
    t.integer "action_group_id"
  end

  create_table "participations", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id", "event_id"], name: "index_participations_on_user_id_and_event_id", unique: true
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "role_id", null: false
    t.index ["user_id", "role_id"], name: "index_roles_users_on_user_id_and_role_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.boolean "receive_emails_about_action_groups", default: true
    t.boolean "receive_emails_about_other_projects", default: true
    t.boolean "receive_other_emails_from_orga", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "confirmed_at"
    t.index ["email"], name: "index_subscriptions_on_email"
    t.index ["receive_emails_about_action_groups"], name: "index_subscriptions_on_receive_emails_about_action_groups"
    t.index ["receive_emails_about_other_projects"], name: "index_subscriptions_on_receive_emails_about_other_projects"
    t.index ["receive_other_emails_from_orga"], name: "index_subscriptions_on_receive_other_emails_from_orga"
  end

  create_table "surveys_answers", id: :serial, force: :cascade do |t|
    t.integer "submission_id"
    t.integer "question_id"
    t.text "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["question_id"], name: "index_surveys_answers_on_question_id"
    t.index ["submission_id"], name: "index_surveys_answers_on_submission_id"
  end

  create_table "surveys_questions", id: :serial, force: :cascade do |t|
    t.integer "template_id"
    t.text "text"
    t.text "answer_options"
    t.integer "question_type"
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "is_subquestion", default: false
    t.text "explanation"
    t.index ["template_id"], name: "index_surveys_questions_on_template_id"
  end

  create_table "surveys_submissions", id: :serial, force: :cascade do |t|
    t.integer "template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id"
    t.index ["template_id"], name: "index_surveys_submissions_on_template_id"
  end

  create_table "surveys_templates", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "slug", limit: 255
    t.boolean "show_in_user_profile", default: false
    t.index ["slug"], name: "index_surveys_templates_on_slug", unique: true
  end

  create_table "tags", force: :cascade do |t|
    t.string "title"
    t.string "icon"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "username", limit: 255
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "phone", limit: 255, default: ""
    t.boolean "cleared", default: false
    t.string "authentication_token"
    t.boolean "receive_emails_about_my_action_groups", default: true
    t.boolean "receive_emails_from_other_users", default: true
    t.string "ical_token"
    t.boolean "receive_notifications_for_new_participation", default: true
    t.boolean "receive_notifications_about_volunteers", default: true
    t.index ["authentication_token"], name: "index_users_on_authentication_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["receive_emails_about_my_action_groups"], name: "index_users_on_receive_emails_about_my_action_groups"
    t.index ["receive_emails_from_other_users"], name: "index_users_on_receive_emails_from_other_users"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
