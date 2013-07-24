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

ActiveRecord::Schema.define(version: 20130724191544) do

  create_table "games", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "winning_score"
    t.integer  "losing_score"
    t.string   "blue_offense"
    t.string   "blue_defense"
    t.string   "red_offense"
    t.string   "red_defense"
    t.float    "blue_elo"
    t.float    "red_elo"
    t.string   "winner"
    t.integer  "player_id"
    t.float    "elo_swing"
    t.string   "password"
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
    t.float    "elo_rating"
    t.string   "name"
    t.integer  "points_for"
    t.integer  "points_against"
    t.integer  "position"
  end

  create_table "tt_games", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "player_one"
    t.string   "player_two"
    t.integer  "winning_score"
    t.integer  "losing_score"
    t.string   "winner"
    t.float    "elo_swing"
  end

  create_table "tt_players", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "wins"
    t.integer  "losses"
    t.float    "elo_rating"
    t.string   "name"
    t.integer  "games_for"
    t.integer  "games_against"
    t.integer  "position"
  end

end
