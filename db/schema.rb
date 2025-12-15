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

ActiveRecord::Schema[8.1].define(version: 2025_12_12_201730) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "status_types", ["approved", "pending", "rejected"]

  create_table "events", force: :cascade do |t|
    t.bigint "approved_by_id"
    t.float "cost", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "end_time"
    t.decimal "latitude", precision: 10, scale: 6
    t.text "location"
    t.decimal "longitude", precision: 10, scale: 6
    t.boolean "pre_registration_required", default: false, null: false
    t.datetime "start_time", null: false
    t.enum "status", default: "pending", null: false, enum_type: "status_types"
    t.string "tags", default: [], array: true
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["approved_by_id"], name: "index_events_on_approved_by_id"
  end

  create_table "passwordless_sessions", force: :cascade do |t|
    t.integer "authenticatable_id"
    t.string "authenticatable_type"
    t.datetime "claimed_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "expires_at", precision: nil, null: false
    t.string "identifier", null: false
    t.datetime "timeout_at", precision: nil, null: false
    t.string "token_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["authenticatable_type", "authenticatable_id"], name: "authenticatable"
    t.index ["identifier"], name: "index_passwordless_sessions_on_identifier", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "name", default: "", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "events", "users", column: "approved_by_id"
end
