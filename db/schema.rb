# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160705142445) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

# Could not dump table "adopted_laws" because of following StandardError
#   Unknown type 'executive_action_type' for column 'executive_action'

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "gitlab_client_identities", force: :cascade do |t|
    t.integer  "user_id",        null: false
    t.string   "host",           null: false
    t.integer  "gitlab_user_id", null: false
    t.string   "access_token",   null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "gitlab_client_identities", ["user_id", "host", "access_token"], name: "gitlab_client_identity_access_token", unique: true, using: :btree
  add_index "gitlab_client_identities", ["user_id", "host", "gitlab_user_id"], name: "gitlab_client_identity_user_id", unique: true, using: :btree
  add_index "gitlab_client_identities", ["user_id"], name: "index_gitlab_client_identities_on_user_id", using: :btree

  create_table "gitlab_client_identity_requests", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "host",       null: false
    t.string   "app_id",     null: false
    t.string   "app_secret", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "gitlab_client_identity_requests", ["user_id", "host", "app_id"], name: "gitlab_client_identity_request_app_id", unique: true, using: :btree
  add_index "gitlab_client_identity_requests", ["user_id"], name: "index_gitlab_client_identity_requests_on_user_id", using: :btree

  create_table "jurisdiction_memberships", force: :cascade do |t|
    t.integer  "jurisdiction_id", null: false
    t.integer  "user_id",         null: false
    t.boolean  "adopt"
    t.boolean  "propose"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "jurisdiction_memberships", ["jurisdiction_id", "user_id"], name: "index_jurisdiction_memberships_on_jurisdiction_id_and_user_id", unique: true, using: :btree
  add_index "jurisdiction_memberships", ["jurisdiction_id"], name: "index_jurisdiction_memberships_on_jurisdiction_id", using: :btree
  add_index "jurisdiction_memberships", ["user_id"], name: "index_jurisdiction_memberships_on_user_id", using: :btree

# Could not dump table "jurisdictions" because of following StandardError
#   Unknown type 'government_type' for column 'government_type'

  create_table "proposed_laws", force: :cascade do |t|
    t.integer  "jurisdiction_id",                      null: false
    t.integer  "user_id",                              null: false
    t.string   "title"
    t.boolean  "repo_created",         default: false, null: false
    t.boolean  "working_repo_created", default: false, null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "proposed_laws", ["jurisdiction_id"], name: "index_proposed_laws_on_jurisdiction_id", using: :btree
  add_index "proposed_laws", ["title"], name: "index_proposed_laws_on_title", using: :btree
  add_index "proposed_laws", ["user_id"], name: "index_proposed_laws_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "first_name",                               null: false
    t.string   "last_name",                                null: false
    t.string   "name",                                     null: false
    t.string   "nickname"
    t.string   "image"
    t.string   "email"
    t.json     "tokens"
    t.boolean  "admin"
    t.boolean  "staff"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["last_name", "first_name"], name: "index_users_on_last_name_and_first_name", using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

  add_foreign_key "adopted_laws", "jurisdictions"
  add_foreign_key "adopted_laws", "proposed_laws"
  add_foreign_key "gitlab_client_identities", "users"
  add_foreign_key "gitlab_client_identity_requests", "users"
  add_foreign_key "jurisdiction_memberships", "jurisdictions"
  add_foreign_key "jurisdiction_memberships", "users"
  add_foreign_key "proposed_laws", "jurisdictions"
  add_foreign_key "proposed_laws", "users"
end
