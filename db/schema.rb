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

ActiveRecord::Schema.define(:version => 20100727103019) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "locations", :force => true do |t|
    t.string   "provider"
    t.string   "zip"
    t.decimal  "latitude",       :precision => 10, :scale => 8
    t.decimal  "longitude",      :precision => 12, :scale => 8
    t.string   "district"
    t.string   "state"
    t.string   "province"
    t.string   "country"
    t.string   "city"
    t.string   "street_address"
    t.string   "full_address"
    t.string   "country_code"
    t.integer  "accuracy"
    t.string   "precision"
    t.text     "bounds"
    t.integer  "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["place_id"], :name => "index_locations_on_place_id"

  create_table "places", :force => true do |t|
    t.string   "name"
    t.text     "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "z_food"
    t.integer  "z_decor"
    t.integer  "z_service"
    t.integer  "z_price"
    t.integer  "z_id"
    t.string   "phone"
  end

  add_index "places", ["name"], :name => "index_places_on_name"
  add_index "places", ["z_id"], :name => "index_places_on_z_id"

  create_table "ratings", :force => true do |t|
    t.integer  "dish_id"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["dish_id"], :name => "index_ratings_on_dish_id"

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
    t.integer  "dish_id"
    t.integer  "place_id"
    t.integer  "rating_id"
    t.datetime "processed_at"
  end

  add_index "statuses", ["dish_id"], :name => "index_statuses_on_dish_id"
  add_index "statuses", ["message_id"], :name => "index_statuses_on_message_id"
  add_index "statuses", ["place_id"], :name => "index_statuses_on_place_id"
  add_index "statuses", ["processed_at"], :name => "index_statuses_on_processed_at"
  add_index "statuses", ["user_id"], :name => "index_statuses_on_processed_and_user_id"
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
    t.string   "persistence_token",   :default => "", :null => false
    t.string   "single_access_token", :default => "", :null => false
    t.string   "perishable_token",    :default => "", :null => false
    t.string   "oauth_token"
    t.string   "oauth_secret"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_node_id"
  end

  add_index "users", ["oauth_token"], :name => "index_users_on_oauth_token"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"
  add_index "users", ["single_access_token"], :name => "index_users_on_single_access_token"

end
