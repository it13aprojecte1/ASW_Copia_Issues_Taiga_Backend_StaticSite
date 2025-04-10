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

ActiveRecord::Schema[8.0].define(version: 2025_04_10_155339) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.integer "user_id", null: false
    t.integer "issue_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_comments_on_issue_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "issue_types", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.integer "position"
  end

  create_table "issue_watchers", force: :cascade do |t|
    t.integer "issue_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_issue_watchers_on_issue_id"
    t.index ["user_id"], name: "index_issue_watchers_on_user_id"
  end

  create_table "issues", force: :cascade do |t|
    t.string "subject"
    t.string "content"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status_id"
    t.integer "issue_type_id"
    t.integer "severity_id"
    t.integer "priority_id"
    t.integer "assignee_id"
    t.date "deadline"
    t.index ["assignee_id"], name: "index_issues_on_assignee_id"
    t.index ["issue_type_id"], name: "index_issues_on_issue_type_id"
    t.index ["priority_id"], name: "index_issues_on_priority_id"
    t.index ["severity_id"], name: "index_issues_on_severity_id"
    t.index ["status_id"], name: "index_issues_on_status_id"
    t.index ["user_id"], name: "index_issues_on_user_id"
  end

  create_table "priorities", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.integer "position"
  end

  create_table "severities", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.integer "position"
  end

  create_table "statuses", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.boolean "is_closed"
    t.integer "position"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.text "bio"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "issues"
  add_foreign_key "comments", "users"
  add_foreign_key "issue_watchers", "issues"
  add_foreign_key "issue_watchers", "users"
  add_foreign_key "issues", "issue_types"
  add_foreign_key "issues", "priorities"
  add_foreign_key "issues", "severities"
  add_foreign_key "issues", "statuses"
  add_foreign_key "issues", "users"
  add_foreign_key "issues", "users", column: "assignee_id"
end
