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

ActiveRecord::Schema.define(version: 20170806182131) do

  create_table "accounts", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "plan_id"
    t.string   "stripe_id"
    t.string   "status"
    t.string   "card_name"
    t.string   "card_brand"
    t.string   "card_last4"
    t.integer  "card_exp_month"
    t.integer  "card_exp_year"
    t.index ["plan_id"], name: "index_accounts_on_plan_id"
    t.index ["status"], name: "index_accounts_on_status"
    t.index ["stripe_id"], name: "index_accounts_on_stripe_id", unique: true
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "account_id", null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "role_id"
    t.index ["account_id", "user_id"], name: "index_memberships_on_account_id_and_user_id", unique: true
    t.index ["role_id"], name: "index_memberships_on_role_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string   "stripe_id",            null: false
    t.integer  "amount"
    t.string   "currency"
    t.string   "interval"
    t.integer  "interval_count"
    t.string   "name"
    t.string   "statement_descriptor"
    t.integer  "trial_period_days"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["stripe_id"], name: "index_plans_on_stripe_id", unique: true
  end

  create_table "receipts", force: :cascade do |t|
    t.string   "stripe_id",       null: false
    t.integer  "account_id",      null: false
    t.integer  "amount"
    t.integer  "amount_refunded"
    t.boolean  "captured"
    t.string   "card_brand"
    t.string   "card_last4"
    t.datetime "charged_at"
    t.string   "currency"
    t.string   "description"
    t.string   "failure_message"
    t.string   "failure_code"
    t.boolean  "paid"
    t.boolean  "refunded"
    t.string   "status"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["stripe_id"], name: "index_receipts_on_stripe_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "key"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_roles_on_key", unique: true
  end

  create_table "settings", force: :cascade do |t|
    t.string   "var",         null: false
    t.text     "value"
    t.string   "target_type", null: false
    t.integer  "target_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["target_type", "target_id", "var"], name: "index_settings_on_target_type_and_target_id_and_var", unique: true
    t.index ["target_type", "target_id"], name: "index_settings_on_target_type_and_target_id"
  end

  create_table "stripe_webhooks", force: :cascade do |t|
    t.string   "stripe_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stripe_id"], name: "index_stripe_webhooks_on_stripe_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.string   "invited_by_type"
    t.integer  "invited_by_id"
    t.integer  "invitations_count",      default: 0
    t.string   "provider"
    t.string   "uid"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
