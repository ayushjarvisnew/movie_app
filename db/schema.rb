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

ActiveRecord::Schema[8.0].define(version: 2025_11_07_085923) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "showtime_id", null: false
    t.json "seat_ids", default: []
    t.string "txnid"
    t.string "status"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["showtime_id"], name: "index_bookings_on_showtime_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "movie_tags", force: :cascade do |t|
    t.bigint "movie_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id", "tag_id"], name: "index_movie_tags_on_movie_id_and_tag_id", unique: true
    t.index ["movie_id"], name: "index_movie_tags_on_movie_id"
    t.index ["tag_id"], name: "index_movie_tags_on_tag_id"
  end

  create_table "movies", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.string "poster_image"
    t.date "release_date"
    t.integer "duration"
    t.float "rating"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_movies_on_deleted_at"
  end

  create_table "movies_tags", id: false, force: :cascade do |t|
    t.bigint "movie_id", null: false
    t.bigint "tag_id", null: false
    t.index ["movie_id", "tag_id"], name: "index_movies_tags_on_movie_id_and_tag_id"
    t.index ["tag_id", "movie_id"], name: "index_movies_tags_on_tag_id_and_movie_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "showtime_id", null: false
    t.integer "seats_count", null: false
    t.decimal "total_amount"
    t.string "payment_status", default: "pending", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "txnid"
    t.index ["deleted_at"], name: "index_reservations_on_deleted_at"
    t.index ["showtime_id"], name: "index_reservations_on_showtime_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "reservations_seats", id: false, force: :cascade do |t|
    t.bigint "reservation_id", null: false
    t.bigint "seat_id", null: false
    t.index ["reservation_id", "seat_id"], name: "index_reservations_seats_on_reservation_id_and_seat_id", unique: true
    t.index ["reservation_id"], name: "index_reservations_seats_on_reservation_id"
    t.index ["seat_id"], name: "index_reservations_seats_on_seat_id"
  end

  create_table "screens", force: :cascade do |t|
    t.bigint "theatre_id", null: false
    t.string "name", null: false
    t.integer "total_seats", null: false
    t.string "screen_type"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_screens_on_deleted_at"
    t.index ["theatre_id"], name: "index_screens_on_theatre_id"
  end

  create_table "seats", force: :cascade do |t|
    t.bigint "screen_id", null: false
    t.string "row", null: false
    t.string "seat_number", null: false
    t.string "seat_type", default: "Regular", null: false
    t.decimal "price"
    t.boolean "available", default: true, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_seats_on_deleted_at"
    t.index ["screen_id"], name: "index_seats_on_screen_id"
  end

  create_table "showtime_seats", force: :cascade do |t|
    t.bigint "showtime_id", null: false
    t.bigint "seat_id", null: false
    t.boolean "available", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["seat_id"], name: "index_showtime_seats_on_seat_id"
    t.index ["showtime_id", "seat_id"], name: "index_showtime_seats_on_showtime_id_and_seat_id", unique: true
    t.index ["showtime_id"], name: "index_showtime_seats_on_showtime_id"
  end

  create_table "showtimes", force: :cascade do |t|
    t.bigint "movie_id", null: false
    t.bigint "screen_id", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.string "language", null: false
    t.integer "available_seats", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_showtimes_on_deleted_at"
    t.index ["movie_id"], name: "index_showtimes_on_movie_id"
    t.index ["screen_id"], name: "index_showtimes_on_screen_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "theatres", force: :cascade do |t|
    t.string "name", null: false
    t.string "address", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "country", null: false
    t.decimal "rating"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_theatres_on_deleted_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "is_admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "bookings", "showtimes"
  add_foreign_key "bookings", "users"
  add_foreign_key "movie_tags", "movies"
  add_foreign_key "movie_tags", "tags"
  add_foreign_key "reservations", "showtimes"
  add_foreign_key "reservations", "users"
  add_foreign_key "reservations_seats", "reservations"
  add_foreign_key "reservations_seats", "seats"
  add_foreign_key "screens", "theatres"
  add_foreign_key "seats", "screens"
  add_foreign_key "showtime_seats", "seats"
  add_foreign_key "showtime_seats", "showtimes"
  add_foreign_key "showtimes", "movies"
  add_foreign_key "showtimes", "screens"
end
