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

ActiveRecord::Schema.define(version: 20150413174715) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "jurisdictions", force: :cascade do |t|
    t.string   "name",                                 null: false
    t.string   "file_name",                            null: false
    t.boolean  "repo_created",         default: false, null: false
    t.boolean  "working_repo_created", default: false, null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "jurisdictions", ["file_name"], name: "index_jurisdictions_on_file_name", unique: true, using: :btree
  add_index "jurisdictions", ["name"], name: "index_jurisdictions_on_name", unique: true, using: :btree

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
    t.string   "email",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "proposed_laws", "jurisdictions"
  add_foreign_key "proposed_laws", "users"
end
