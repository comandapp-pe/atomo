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

ActiveRecord::Schema.define(version: 2021_07_10_003425) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_sessions", force: :cascade do |t|
    t.bigint "admin_user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_user_id"], name: "index_admin_sessions_on_admin_user_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "tag", null: false
    t.string "password", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "checkout_links", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "format", null: false
    t.integer "length", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_checkout_links_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "product_id", null: false
    t.string "format", null: false
    t.integer "length", null: false
    t.string "customer_email"
    t.string "customer_first_name"
    t.string "customer_last_name"
    t.integer "checkout_code"
    t.string "payment_method"
    t.string "currency"
    t.datetime "sold_at"
    t.decimal "total"
    t.decimal "checkout_commission"
    t.index ["product_id"], name: "index_orders_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "preview_html"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "checkout_code", null: false
    t.string "thumbnail_url_with_play_button"
    t.string "vimeo_url"
    t.boolean "published"
    t.string "thumbnail_url"
    t.bigint "category_id"
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  add_foreign_key "admin_sessions", "admin_users"
  add_foreign_key "checkout_links", "products"
  add_foreign_key "orders", "products"
  add_foreign_key "products", "categories"
end
