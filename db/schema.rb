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

ActiveRecord::Schema.define(version: 20160323133649) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string   "description"
    t.boolean  "reserve_room", default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.time     "start_time"
    t.time     "end_time"
  end

  create_table "blog_assignments", force: :cascade do |t|
    t.integer "schedule_id"
    t.integer "student_id"
    t.date    "due_date"
  end

  create_table "calendar_events", force: :cascade do |t|
    t.integer  "schedule_id"
    t.string   "name"
    t.string   "location"
    t.datetime "reserved_at"
    t.string   "reserved_by"
    t.string   "link"
  end

  create_table "cohorts", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "calendar_id"
    t.string   "roster_csv_file_name"
    t.string   "roster_csv_content_type"
    t.integer  "roster_csv_file_size"
    t.datetime "roster_csv_updated_at"
  end

  add_index "cohorts", ["name"], name: "index_cohorts_on_name", using: :btree

  create_table "labs", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "objectives", force: :cascade do |t|
    t.integer  "schedule_id"
    t.string   "content"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "objectives", ["schedule_id"], name: "index_objectives_on_schedule_id", using: :btree

  create_table "schedule_activities", force: :cascade do |t|
    t.integer "schedule_id"
    t.integer "activity_id"
  end

  create_table "schedule_labs", force: :cascade do |t|
    t.integer "schedule_id"
    t.integer "lab_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.datetime "date"
    t.text     "notes"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "slug"
    t.string   "week"
    t.string   "day"
    t.boolean  "deploy",      default: false
    t.integer  "cohort_id"
    t.string   "sha"
    t.datetime "deployed_on"
  end

  create_table "students", force: :cascade do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.string  "github_username"
    t.string  "email"
    t.string  "blog_url"
    t.integer "cohort_id"
  end

  create_table "user_cohorts", force: :cascade do |t|
    t.integer "user_id"
    t.integer "cohort_id"
    t.boolean "active",    default: true
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "refresh_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "objectives", "schedules"
end
