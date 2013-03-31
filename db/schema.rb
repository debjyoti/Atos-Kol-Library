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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130331101029) do

  create_table "book_issue_histories", :force => true do |t|
    t.integer  "book_id"
    t.integer  "user_id"
    t.date     "requested_on"
    t.date     "issued_on"
    t.date     "returned_on"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "books", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.date     "issued_on"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "author"
    t.integer  "category_id"
    t.boolean  "pending_approval"
    t.date     "expires_on"
    t.integer  "blocked_by_id"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "duration"
  end

  create_table "spendings", :force => true do |t|
    t.integer  "user_id"
    t.decimal  "amount"
    t.date     "when"
    t.string   "desc"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "das_id",                 :default => "",    :null => false
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "name"
    t.decimal  "fine",                   :default => 0.0
    t.boolean  "is_admin",               :default => false
    t.boolean  "approved",               :default => false, :null => false
    t.string   "manager"
    t.string   "phone_number"
    t.string   "seat_number"
    t.integer  "max_book_count",         :default => 1
    t.integer  "admin_id"
    t.decimal  "money",                  :default => 0.0
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
