# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100813225036) do

  create_table "bookmarks", :force => true do |t|
    t.integer  "user_id"
    t.string   "username"
    t.string   "title"
    t.string   "description"
    t.string   "link"
    t.string   "tags"
    t.datetime "date_posted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delicious_accounts", :force => true do |t|
    t.integer  "user_id"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "digg_accounts", :force => true do |t|
    t.integer  "user_id"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "facebook_accounts", :force => true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", :force => true do |t|
    t.integer  "user_id"
    t.string   "site_id"
    t.string   "name"
    t.string   "name_id"
    t.string   "message"
    t.string   "link"
    t.string   "avatar"
    t.datetime "date_posted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stories", :force => true do |t|
    t.integer  "user_id"
    t.string   "username"
    t.string   "avatar"
    t.string   "title"
    t.string   "description"
    t.string   "link_digg"
    t.string   "link_external"
    t.datetime "date_posted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tweets", :force => true do |t|
    t.integer  "user_id"
    t.string   "username"
    t.string   "content"
    t.datetime "date_posted"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id"
    t.string   "avatar"
  end

  create_table "twitter_accounts", :force => true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
