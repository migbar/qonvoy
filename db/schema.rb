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

ActiveRecord::Schema.define(:version => 20100315103527) do

  create_table "dishes", :force => true do |t|
    t.integer  "place_id"
    t.string   "name"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dishes", ["name"], :name => "index_dishes_on_name"
  add_index "dishes", ["place_id", "name"], :name => "index_dishes_on_place_id_and_name"
  add_index "dishes", ["place_id"], :name => "index_dishes_on_place_id"

  create_table "places", :force => true do |t|
    t.string   "name"
    t.text     "address"
    t.decimal  "latitude",   :precision => 10, :scale => 8
    t.decimal  "longitude",  :precision => 12, :scale => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "places", ["name"], :name => "index_places_on_name"

  create_table "statuses", :force => true do |t|
    t.integer  "user_id"
    t.string   "sender_screen_name"
    t.integer  "sender_id",          :limit => 8
    t.string   "body",               :limit => 1000
    t.string   "kind",               :limit => 40
    t.datetime "status_created_at"
    t.integer  "message_id",         :limit => 8
    t.text     "raw"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "statuses", ["message_id"], :name => "index_statuses_on_message_id"
  add_index "statuses", ["user_id"], :name => "index_statuses_on_user_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "twitter_uid"
    t.string   "avatar_url"
    t.string   "screen_name"
    t.string   "location"
    t.string   "persistence_token",   :null => false
    t.string   "single_access_token", :null => false
    t.string   "perishable_token",    :null => false
    t.string   "oauth_token"
    t.string   "oauth_secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["oauth_token"], :name => "index_users_on_oauth_token"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"
  add_index "users", ["single_access_token"], :name => "index_users_on_single_access_token"

end
