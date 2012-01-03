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

ActiveRecord::Schema.define(:version => 20111115132342) do

  create_table "compounds", :force => true do |t|
    t.string   "name"
    t.float    "ymin"
    t.float    "ymax"
    t.string   "unit"
    t.float    "mol_weight"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "fluxes", :force => true do |t|
    t.integer  "incubation_id"
    t.string   "compound"
    t.float    "value"
    t.integer  "compound_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "incubations", :force => true do |t|
    t.datetime "sampled_at"
    t.string   "chamber"
    t.string   "treatment"
    t.string   "replicate"
    t.float    "soil_temperature"
    t.float    "average_height_cm"
    t.integer  "lid_id"
    t.integer  "run_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "lids", :force => true do |t|
    t.float    "surface_area"
    t.string   "name"
    t.float    "volume"
    t.float    "height"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "measurements", :force => true do |t|
    t.integer  "flux_id"
    t.string   "vial"
    t.float    "seconds"
    t.float    "ppm"
    t.float    "area"
    t.boolean  "excluded"
    t.datetime "starting_time"
    t.datetime "ending_time"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "runs", :force => true do |t|
    t.date     "sampled_on"
    t.date     "run_on"
    t.string   "study"
    t.text     "comment"
    t.string   "name"
    t.string   "workflow_state"
    t.boolean  "released"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "setup_file"
    t.string   "data_file"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
