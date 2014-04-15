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

ActiveRecord::Schema.define(version: 20140415201035) do

  create_table "calibrations", force: true do |t|
    t.integer  "standard_curve_id"
    t.integer  "sample_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaign_plots", force: true do |t|
    t.integer  "plot_id"
    t.integer  "campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaigns", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "check_standards", force: true do |t|
    t.integer  "standard_curve_id"
    t.integer  "compound_id"
    t.string   "vial"
    t.float    "ppm"
    t.float    "area"
    t.boolean  "excluded",          default: true
    t.datetime "starting_time"
    t.datetime "ending_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "aquired_at"
  end

  create_table "companies", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "compounds", force: true do |t|
    t.string "name",       limit: 10
    t.float  "mol_weight"
    t.string "unit"
    t.float  "ymax"
    t.float  "ymin"
  end

  create_table "curves", force: true do |t|
    t.integer "calibration_id"
    t.integer "compound_id"
    t.float   "slope"
    t.float   "intercept"
  end

  create_table "fluxes", force: true do |t|
    t.integer  "incubation_id"
    t.float    "value"
    t.integer  "compound_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fluxes", ["incubation_id"], name: "fluxes_incubation_id", using: :btree

  create_table "group_affiliations", force: true do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.boolean "default_group", default: false
  end

  create_table "group_permissions", force: true do |t|
    t.integer "group_id"
    t.integer "permission_id"
  end

  create_table "groups", force: true do |t|
    t.string "name"
  end

  create_table "incubations", force: true do |t|
    t.string   "name",             limit: 25
    t.integer  "run_id"
    t.float    "soil_temperature"
    t.string   "treatment"
    t.string   "replicate"
    t.integer  "lid_id"
    t.string   "chamber"
    t.float    "avg_height_cm"
    t.datetime "sampled_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sub_plot"
  end

  add_index "incubations", ["run_id"], name: "incubation_run_id", using: :btree

  create_table "lids", force: true do |t|
    t.string "name",         limit: 1
    t.float  "volume"
    t.float  "height"
    t.float  "surface_area"
  end

  create_table "measurements", force: true do |t|
    t.float    "response"
    t.boolean  "excluded",         default: false
    t.integer  "flux_id"
    t.integer  "seconds"
    t.float    "ppm"
    t.string   "comment"
    t.integer  "vial"
    t.integer  "run_id"
    t.integer  "compound_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "area"
    t.string   "type"
    t.datetime "starting_time"
    t.datetime "ending_time"
    t.integer  "sample_id"
    t.integer  "column"
    t.datetime "acquired_at"
    t.integer  "original_seconds"
  end

  add_index "measurements", ["compound_id"], name: "index_measurements_on_compound_id", using: :btree
  add_index "measurements", ["flux_id"], name: "sample_flux_id", using: :btree
  add_index "measurements", ["run_id"], name: "sample_run_id", using: :btree
  add_index "measurements", ["sample_id"], name: "index_measurements_on_sample_id", using: :btree

  create_table "permissions", force: true do |t|
    t.string "name"
  end

  create_table "plots", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "runs", force: true do |t|
    t.date     "run_on"
    t.date     "sampled_on"
    t.string   "name",           limit: 50
    t.text     "comment"
    t.boolean  "approved",                  default: false
    t.integer  "group_id"
    t.string   "study",          limit: 25
    t.boolean  "released",                  default: false
    t.string   "workflow_state"
    t.string   "setup_file"
    t.string   "data_file"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "samples", force: true do |t|
    t.string   "vial"
    t.integer  "run_id"
    t.datetime "sampled_at"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "uuid"
    t.integer  "incubation_id"
  end

  add_index "samples", ["incubation_id"], name: "index_samples_on_incubation_id", using: :btree
  add_index "samples", ["run_id", "vial"], name: "samples_run_id_vial_key", unique: true, using: :btree

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "setups", force: true do |t|
    t.integer  "template_id"
    t.date     "sample_date"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "standard_curve_organizers", force: true do |t|
    t.integer  "run_id"
    t.text     "curves"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "standard_curves", force: true do |t|
    t.integer  "run_id"
    t.integer  "compound_id"
    t.float    "slope"
    t.float    "intercept"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "column"
    t.string   "coeff"
    t.datetime "sampled_at"
  end

  create_table "standards", force: true do |t|
    t.integer  "standard_curve_id"
    t.integer  "compound_id"
    t.string   "vial"
    t.float    "ppm"
    t.float    "area"
    t.boolean  "excluded"
    t.datetime "starting_time"
    t.datetime "ending_time"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "column"
    t.datetime "acquired_at"
  end

  create_table "standards_old", id: false, force: true do |t|
    t.integer "id",       default: "nextval('standards_old_id_seq'::regclass)", null: false
    t.float   "ppm"
    t.float   "response"
    t.boolean "exclude",  default: false
    t.text    "comment"
    t.integer "curve_id"
  end

  create_table "templates", force: true do |t|
    t.string   "name"
    t.string   "study"
    t.text     "plots"
    t.integer  "samples_per_plot"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "persistence_token"
    t.string   "password_salt"
    t.datetime "last_request_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "reset_password_token"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.datetime "remember_created_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "sign_in_count"
    t.datetime "reset_password_sent_at"
    t.integer  "company_id"
  end

end
