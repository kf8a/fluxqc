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

ActiveRecord::Schema.define(:version => 20111031023036) do

  create_table "fluxes", :force => true do |t|
    t.integer  "incubation_id"
    t.string   "compound"
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "incubations", :force => true do |t|
    t.datetime "sampled_at"
    t.string   "chamber"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measurements", :force => true do |t|
    t.integer  "flux_id"
    t.float    "ppm"
    t.float    "area"
    t.datetime "starting_time"
    t.datetime "ending_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
