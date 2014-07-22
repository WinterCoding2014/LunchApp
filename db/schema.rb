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

ActiveRecord::Schema.define(version: 20140722055219) do

  create_table "chosen_venues", force: true do |t|
    t.integer  "lunch_week_id"
    t.integer  "venue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lunch_attendees", force: true do |t|
    t.integer  "lunch_week_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lunch_weeks", force: true do |t|
    t.date     "friday_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lunchweeks", force: true do |t|
    t.date     "fridayDate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.integer  "user_id",       limit: 255
    t.integer  "lunch_week_id", limit: 255
    t.text     "content",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", force: true do |t|
    t.integer  "user_id"
    t.integer  "venue_id"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_utility_logs", force: true do |t|
    t.integer  "user_id"
    t.integer  "lunch_week_id"
    t.integer  "difference"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "venues", force: true do |t|
    t.string   "name"
    t.text     "address"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "menu_link"
  end

end
