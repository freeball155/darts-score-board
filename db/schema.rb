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

ActiveRecord::Schema.define(version: 2018_11_21_141546) do

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

  create_table "stats", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", limit: 1073741823
    t.datetime "created_at"
    t.text "object_changes", limit: 1073741823
    t.integer "play_id"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
