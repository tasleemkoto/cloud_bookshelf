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

ActiveRecord::Schema[7.1].define(version: 2024_11_30_072105) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.text "summary"
    t.string "author"
    t.string "genre"
    t.integer "year"
    t.string "format"
    t.boolean "availability", default: true
    t.string "location"
    t.string "qr_code"
    t.string "photo"
    t.integer "quantity"
    t.string "status"
    t.integer "view_count", default: 0
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "library_id", null: false
    t.index ["library_id"], name: "index_books_on_library_id"
    t.index ["qr_code"], name: "index_books_on_qr_code", unique: true
    t.index ["user_id"], name: "index_books_on_user_id"
  end

  create_table "checkout_books", force: :cascade do |t|
    t.bigint "checkout_id", null: false
    t.bigint "book_id", null: false
    t.date "start_date"
    t.date "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_checkout_books_on_book_id"
    t.index ["checkout_id"], name: "index_checkout_books_on_checkout_id"
  end

  create_table "checkouts", force: :cascade do |t|
    t.date "start_date"
    t.date "due_date"
    t.date "return_date"
    t.boolean "is_returned", default: false
    t.bigint "user_id", null: false
    t.bigint "book_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "library_id", null: false
    t.integer "status", default: 0
    t.index ["book_id"], name: "index_checkouts_on_book_id"
    t.index ["library_id"], name: "index_checkouts_on_library_id"
    t.index ["user_id"], name: "index_checkouts_on_user_id"
  end

  create_table "libraries", force: :cascade do |t|
    t.string "name", null: false
    t.string "unique_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", default: 1, null: false
    t.index ["unique_id"], name: "index_libraries_on_unique_id", unique: true
    t.index ["user_id"], name: "index_libraries_on_user_id"
  end

  create_table "library_users", force: :cascade do |t|
    t.boolean "is_admin", default: false
    t.bigint "user_id", null: false
    t.bigint "library_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["library_id"], name: "index_library_users_on_library_id"
    t.index ["user_id"], name: "index_library_users_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "content"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "library_id", null: false
    t.index ["library_id"], name: "index_notifications_on_library_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "comment"
    t.integer "rating"
    t.bigint "user_id", null: false
    t.bigint "book_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_reviews_on_book_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone_number"
    t.string "photo"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wishlists", force: :cascade do |t|
    t.string "name"
    t.string "photo"
    t.bigint "user_id", null: false
    t.bigint "book_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "library_id", null: false
    t.index ["book_id"], name: "index_wishlists_on_book_id"
    t.index ["library_id"], name: "index_wishlists_on_library_id"
    t.index ["user_id"], name: "index_wishlists_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "books", "libraries"
  add_foreign_key "books", "users"
  add_foreign_key "checkout_books", "books"
  add_foreign_key "checkout_books", "checkouts"
  add_foreign_key "checkouts", "books"
  add_foreign_key "checkouts", "libraries"
  add_foreign_key "checkouts", "users"
  add_foreign_key "libraries", "users"
  add_foreign_key "library_users", "libraries"
  add_foreign_key "library_users", "users"
  add_foreign_key "notifications", "libraries"
  add_foreign_key "notifications", "users"
  add_foreign_key "reviews", "books"
  add_foreign_key "reviews", "users"
  add_foreign_key "wishlists", "books"
  add_foreign_key "wishlists", "libraries"
  add_foreign_key "wishlists", "users"
end
