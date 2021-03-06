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

ActiveRecord::Schema.define(:version => 20120708115132) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "schedules", :force => true do |t|
    t.integer  "sensor_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "start_time"
    t.integer  "end_time"
  end

  add_index "schedules", ["sensor_id", "created_at"], :name => "index_schedules_on_sensor_id_and_created_at"
  add_index "schedules", ["sensor_id"], :name => "index_schedules_on_sensor_id"

  create_table "sensor_readings", :force => true do |t|
    t.integer  "watthours",  :default => 0, :null => false
    t.integer  "sensor_id",                 :null => false
    t.datetime "created_at",                :null => false
  end

  add_index "sensor_readings", ["sensor_id", "created_at"], :name => "index_sensor_readings_on_sensor_id_and_created_at"
  add_index "sensor_readings", ["sensor_id"], :name => "index_sensor_readings_on_sensor_id"

  create_table "sensors", :force => true do |t|
    t.string   "label"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "mac_address"
    t.boolean  "enabled"
    t.boolean  "plus"
    t.integer  "user_id"
  end

  add_index "sensors", ["mac_address"], :name => "index_sensors_on_mac_address", :unique => true

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
    t.boolean  "demo",                   :default => false, :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
