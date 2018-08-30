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

ActiveRecord::Schema.define(version: 2018_08_23_074953) do

  create_table "checkouts", force: :cascade do |t|
    t.integer "points"
    t.text "combination"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.integer "num_players"
    t.text "players"
    t.text "state"
    t.text "game_type"
    t.text "score"
    t.integer "finish_type"
    t.integer "points"
    t.integer "num_legs"
    t.integer "num_sets"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "play_id"
    t.integer "player_won"
  end

  create_table "games_stats", force: :cascade do |t|
    t.integer "game_id"
    t.integer "player_id"
    t.integer "total_points"
    t.integer "total_darts"
    t.integer "max_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_games_stats_on_game_id"
    t.index ["player_id"], name: "index_games_stats_on_player_id"
  end

  create_table "player_stats", force: :cascade do |t|
    t.integer "player_id"
    t.text "stat_code"
    t.integer "stat_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plays", force: :cascade do |t|
    t.integer "game_id"
    t.integer "num_set"
    t.integer "num_leg"
    t.integer "turn"
    t.integer "player"
    t.string "dart1"
    t.string "dart2"
    t.string "dart3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
