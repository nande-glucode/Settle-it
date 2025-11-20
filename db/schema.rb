# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_10_29_101502) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "debate_participants", force: :cascade do |t|
    t.bigint "debate_id", null: false
    t.bigint "user_id", null: false
    t.boolean "acknowledged", default: false, null: false
    t.datetime "invited_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["debate_id", "user_id"], name: "index_debate_participants_on_debate_id_and_user_id", unique: true
    t.index ["debate_id"], name: "index_debate_participants_on_debate_id"
    t.index ["user_id"], name: "index_debate_participants_on_user_id"
  end

  create_table "debates", force: :cascade do |t|
    t.string "title", null: false
    t.integer "mode", default: 0, null: false
    t.bigint "creator_id", null: false
    t.bigint "group_id"
    t.integer "status", default: 0, null: false
    t.datetime "voting_ends_at"
    t.integer "winner_option_id"
    t.bigint "parent_debate_id"
    t.boolean "creator_votes", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_debates_on_creator_id"
    t.index ["group_id", "status"], name: "index_debates_on_group_id_and_status"
    t.index ["group_id"], name: "index_debates_on_group_id"
    t.index ["parent_debate_id"], name: "index_debates_on_parent_debate_id"
    t.index ["status"], name: "index_debates_on_status"
    t.index ["winner_option_id"], name: "index_debates_on_winner_option_id"
  end

  create_table "dictator_tokens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "earned_at", null: false
    t.datetime "used_at"
    t.integer "used_in_debate_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["used_in_debate_id"], name: "index_dictator_tokens_on_used_in_debate_id"
    t.index ["user_id", "used_at"], name: "index_dictator_tokens_on_user_id_and_used_at"
    t.index ["user_id"], name: "index_dictator_tokens_on_user_id"
  end

  create_table "group_memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_memberships_on_group_id"
    t.index ["user_id", "group_id"], name: "index_group_memberships_on_user_id_and_group_id", unique: true
    t.index ["user_id"], name: "index_group_memberships_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "creator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_groups_on_creator_id"
  end

  create_table "options", force: :cascade do |t|
    t.bigint "debate_id", null: false
    t.string "text", null: false
    t.integer "vote_count", default: 0, null: false
    t.boolean "vetoed", default: false, null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["debate_id", "position"], name: "index_options_on_debate_id_and_position"
    t.index ["debate_id"], name: "index_options_on_debate_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "username", null: false
    t.string "password_digest", null: false
    t.integer "vetos_remaining", default: 3, null: false
    t.datetime "vetos_reset_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "vetos", force: :cascade do |t|
    t.bigint "debate_id", null: false
    t.bigint "option_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["debate_id", "option_id", "user_id"], name: "index_vetos_on_debate_option_user", unique: true
    t.index ["debate_id"], name: "index_vetos_on_debate_id"
    t.index ["option_id"], name: "index_vetos_on_option_id"
    t.index ["user_id"], name: "index_vetos_on_user_id"
  end

  create_table "votes", force: :cascade do |t|
    t.bigint "debate_id", null: false
    t.bigint "option_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["debate_id", "user_id"], name: "index_votes_on_debate_id_and_user_id", unique: true
    t.index ["debate_id"], name: "index_votes_on_debate_id"
    t.index ["option_id"], name: "index_votes_on_option_id"
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  create_table "win_streaks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "current_streak", default: 0, null: false
    t.integer "last_win_debate_id"
    t.integer "last_decision_debate_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_win_streaks_on_user_id"
  end

  add_foreign_key "debate_participants", "debates"
  add_foreign_key "debate_participants", "users"
  add_foreign_key "debates", "debates", column: "parent_debate_id"
  add_foreign_key "debates", "groups"
  add_foreign_key "debates", "users", column: "creator_id"
  add_foreign_key "dictator_tokens", "users"
  add_foreign_key "group_memberships", "groups"
  add_foreign_key "group_memberships", "users"
  add_foreign_key "groups", "users", column: "creator_id"
  add_foreign_key "options", "debates"
  add_foreign_key "vetos", "debates"
  add_foreign_key "vetos", "options"
  add_foreign_key "vetos", "users"
  add_foreign_key "votes", "debates"
  add_foreign_key "votes", "options"
  add_foreign_key "votes", "users"
  add_foreign_key "win_streaks", "users"
end
