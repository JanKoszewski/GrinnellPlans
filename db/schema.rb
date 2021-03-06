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

ActiveRecord::Schema.define(:version => 20130503203251) do

  create_table "loves", :force => true do |t|
    t.integer  "user_id"
    t.integer  "love_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "link_text"
  end

  add_index "loves", ["user_id"], :name => "index_loves_on_user_id"

  create_table "mentions", :force => true do |t|
    t.integer  "mentioned_id"
    t.integer  "mentioned_user_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "key"
    t.datetime "read_time"
    t.integer  "position"
  end

  create_table "plans", :force => true do |t|
    t.integer  "user_id"
    t.text     "body"
    t.string   "title"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "permalink"
    t.integer  "previous_length"
    t.integer  "change_in_length"
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "follower_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "priority"
    t.integer  "followed_user_id"
    t.datetime "read_time"
  end

  add_index "subscriptions", ["followed_user_id"], :name => "index_subscriptions_on_followed_user_id"

  create_table "users", :force => true do |t|
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
    t.string   "username"
    t.boolean  "admin",                  :default => false
    t.boolean  "approved",               :default => false, :null => false
  end

  add_index "users", ["approved"], :name => "index_users_on_approved"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
