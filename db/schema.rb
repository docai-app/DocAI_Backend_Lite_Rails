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

ActiveRecord::Schema[7.0].define(version: 2024_06_03_073021) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "user_feeds", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "title", default: ""
    t.string "description", default: ""
    t.string "cover_image", default: ""
    t.string "file_type", null: false
    t.string "file_url", default: ""
    t.integer "file_size", default: 0
    t.uuid "user_marketplace_item_id"
    t.jsonb "meta"
    t.text "file_content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["file_type"], name: "index_user_feeds_on_file_type"
    t.index ["user_id"], name: "index_user_feeds_on_user_id"
    t.index ["user_marketplace_item_id"], name: "index_user_feeds_on_user_marketplace_item_id"
  end

  create_table "user_files", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "file_type", null: false
    t.string "file_url"
    t.integer "file_size", default: 0, null: false
    t.string "title", default: ""
    t.uuid "user_marketplace_item_id"
    t.jsonb "meta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["file_type"], name: "index_user_files_on_file_type"
    t.index ["user_id"], name: "index_user_files_on_user_id"
    t.index ["user_marketplace_item_id"], name: "index_user_files_on_user_marketplace_item_id"
  end

  create_table "user_marketplace_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "marketplace_item_id", null: false
    t.string "custom_name"
    t.text "custom_description"
    t.uuid "purchase_id", null: false
    t.jsonb "meta", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["marketplace_item_id"], name: "index_user_marketplace_items_on_marketplace_item_id"
    t.index ["purchase_id"], name: "index_user_marketplace_items_on_purchase_id"
    t.index ["user_id"], name: "index_user_marketplace_items_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "nickname"
    t.string "phone"
    t.string "whatsapp"
    t.date "date_of_birth"
    t.integer "sex"
    t.string "timezone", default: "Asia/Hong_Kong", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
