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

ActiveRecord::Schema.define(version: 2021_11_24_030653) do

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.string "password"
    t.integer "role_id"
    t.decimal "balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_accounts_on_role_id"
  end

  create_table "admins", force: :cascade do |t|
    t.integer "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_admins_on_account_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.integer "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "comment_id"
    t.index ["account_id"], name: "index_comments_on_account_id"
    t.index ["comment_id"], name: "index_comments_on_comment_id"
  end

  create_table "commodities", force: :cascade do |t|
    t.string "name"
    t.text "introduction"
    t.decimal "price"
    t.integer "shop_id"
    t.integer "categories_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["categories_id"], name: "index_commodities_on_categories_id"
    t.index ["shop_id"], name: "index_commodities_on_shop_id"
  end

  create_table "customers", force: :cascade do |t|
    t.integer "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_customers_on_account_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "count"
    t.decimal "price"
    t.boolean "done"
    t.integer "commodity_id"
    t.integer "seller_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commodity_id"], name: "index_orders_on_commodity_id"
    t.index ["seller_id"], name: "index_orders_on_seller_id"
  end

  create_table "records", force: :cascade do |t|
    t.integer "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "section_id"
    t.index ["order_id"], name: "index_records_on_order_id"
    t.index ["section_id"], name: "index_records_on_section_id"
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role_type"
  end

  create_table "sections", force: :cascade do |t|
    t.integer "grade"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sellers", force: :cascade do |t|
    t.integer "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_sellers_on_account_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name"
    t.text "introduction"
    t.integer "seller_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["seller_id"], name: "index_shops_on_seller_id"
  end

end
