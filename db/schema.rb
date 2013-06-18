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

ActiveRecord::Schema.define(version: 20130618033754) do

  create_table "games", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "winning_score"
    t.integer  "losing_score"
    t.string   "blue_offense"
    t.string   "blue_defense"
    t.string   "red_offense"
    t.string   "red_defense"
    t.float    "blue_ELO"
    t.float    "red_ELO"
    t.string   "winner"
    t.integer  "player_id"
    t.float    "ELO_swing"
  end

  create_table "players", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "wins"
    t.integer  "losses"
    t.integer  "wins_on_offense"
    t.integer  "losses_on_offense"
    t.integer  "wins_on_defense"
    t.integer  "losses_on_defense"
    t.float    "ELO_rating"
    t.string   "name"
    t.integer  "points_for"
    t.integer  "points_against"
    t.integer  "position"
  end

end
