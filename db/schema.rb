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

ActiveRecord::Schema.define(version: 2019_09_30_173319) do

  create_table "games", force: :cascade do |t|
    t.integer "tournament_id"
    t.string "stage", limit: 10
    t.integer "home_team_id"
    t.integer "visitor_team_id"
    t.integer "home_team_score"
    t.integer "visitor_team_score"
    t.integer "winner_id"
    t.index ["home_team_id"], name: "index_games_on_home_team_id"
    t.index ["tournament_id"], name: "index_games_on_tournament_id"
    t.index ["visitor_team_id"], name: "index_games_on_visitor_team_id"
    t.index ["winner_id"], name: "index_games_on_winner_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", limit: 250, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tournament_teams", force: :cascade do |t|
    t.integer "tournament_id"
    t.integer "team_id"
    t.string "division", limit: 2
    t.index ["division"], name: "index_tournament_teams_on_division"
    t.index ["team_id"], name: "index_tournament_teams_on_team_id"
    t.index ["tournament_id", "team_id"], name: "index_tournament_teams_on_tournament_id_and_team_id", unique: true
    t.index ["tournament_id"], name: "index_tournament_teams_on_tournament_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "name", limit: 250, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
