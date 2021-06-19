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

ActiveRecord::Schema.define(version: 2021_06_19_030438) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assets", force: :cascade do |t|
    t.string "asset_type"
    t.integer "amount"
    t.float "growth_rate"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "asset_allocation"
    t.index ["user_id"], name: "index_assets_on_user_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "expense_type"
    t.integer "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "year"
    t.integer "year_int"
    t.integer "inflated_amt"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "properties", force: :cascade do |t|
    t.string "address"
    t.string "floor"
    t.string "unit"
    t.string "flat_type"
    t.integer "area"
    t.integer "lease_remaining"
    t.bigint "user_id", null: false
    t.float "property_growth_rate"
    t.integer "property_value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "start_ownership_year"
    t.integer "original_loan_amount"
    t.float "loan_interest_annual"
    t.integer "loan_tenure_years"
    t.index ["user_id"], name: "index_properties_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.date "dob"
    t.integer "monthly_savings"
    t.integer "monthly_income"
    t.integer "monthly_expenses"
    t.integer "target_retirement_age"
    t.integer "default_inflation_rate"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "assets", "users"
  add_foreign_key "expenses", "users"
  add_foreign_key "properties", "users"
end
