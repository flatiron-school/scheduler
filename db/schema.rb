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

ActiveRecord::Schema.define(version: 20160309221940) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.time     "time"
    t.string   "description"
    t.boolean  "reserve_room", default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "cohorts", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "cohorts", ["name"], name: "index_cohorts_on_name", using: :btree

  create_table "labs", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "slug"
    t.string   "week"
    t.string   "day"
    t.boolean  "deploy",     default: true
    t.integer  "cohort_id"
  end

end
