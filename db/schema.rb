# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_31_185517) do

  enable_extension "plpgsql"

  create_table "criteria", force: :cascade do |t|
    t.string "criteria_type", null: false
    t.integer "start", null: false
    t.integer "end"
    t.bigint "discount_id", null: false
    t.index ["discount_id"], name: "index_criteria_on_discount_id"
  end

  create_table "customers", force: :cascade do |t|
  end

  create_table "discounts", force: :cascade do |t|
    t.boolean "is_flat", null: false
    t.string "discount_type"
    t.integer "type_value", null: false
    t.bigint "rate_id", null: false
    t.index ["rate_id"], name: "index_discounts_on_rate_id"
  end

  create_table "rates", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.index ["customer_id"], name: "index_rates_on_customer_id"
  end

  create_table "surcharges", force: :cascade do |t|
    t.string "item_property", null: false
    t.string "surcharge_type", null: false
    t.integer "type_value", null: false
    t.bigint "rate_id", null: false
    t.index ["rate_id"], name: "index_surcharges_on_rate_id"
  end

  add_foreign_key "criteria", "discounts"
  add_foreign_key "discounts", "rates"
  add_foreign_key "rates", "customers"
  add_foreign_key "surcharges", "rates"
end
