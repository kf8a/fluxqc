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

ActiveRecord::Schema.define(version: 20150128184548) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "calibrations", force: :cascade do |t|
    t.integer  "standard_curve_id"
    t.integer  "sample_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calibrations_old", force: :cascade do |t|
    t.integer "run_id"
    t.string  "name",   limit: 25
  end

  create_table "campaign_plots", force: :cascade do |t|
    t.integer  "plot_id"
    t.integer  "campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaigns", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "check_standards", force: :cascade do |t|
    t.integer  "standard_curve_id"
    t.integer  "compound_id"
    t.string   "vial",              limit: 255
    t.float    "ppm"
    t.float    "area"
    t.boolean  "excluded",                      default: true
    t.datetime "starting_time"
    t.datetime "ending_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "aquired_at"
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "compounds", force: :cascade do |t|
    t.string "name",       limit: 10
    t.float  "mol_weight"
    t.string "unit",       limit: 255
    t.float  "ymax"
    t.float  "ymin"
  end

  create_table "curves", force: :cascade do |t|
    t.integer "calibration_id"
    t.integer "compound_id"
    t.float   "slope"
    t.float   "intercept"
  end

  create_table "data_attachments", force: :cascade do |t|
    t.integer  "run_id"
    t.string   "data_file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "data_files", force: :cascade do |t|
    t.integer  "run_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fluxes", force: :cascade do |t|
    t.integer  "incubation_id"
    t.float    "value"
    t.integer  "compound_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fluxes", ["incubation_id"], name: "fluxes_incubation_id", using: :btree

  create_table "group_affiliations", force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.boolean "default_group", default: false
  end

  create_table "group_permissions", force: :cascade do |t|
    t.integer "group_id"
    t.integer "permission_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "incubations", force: :cascade do |t|
    t.string   "name",             limit: 25
    t.integer  "run_id"
    t.float    "soil_temperature"
    t.string   "treatment",        limit: 255
    t.string   "replicate",        limit: 255
    t.integer  "lid_id"
    t.string   "chamber",          limit: 255
    t.float    "avg_height_cm"
    t.datetime "sampled_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sub_plot",         limit: 255
  end

  add_index "incubations", ["run_id"], name: "incubation_run_id", using: :btree

  create_table "lids", force: :cascade do |t|
    t.string "name",         limit: 1
    t.float  "volume"
    t.float  "height"
    t.float  "surface_area"
  end

  create_table "measurements", force: :cascade do |t|
    t.float    "response"
    t.boolean  "excluded",                     default: false
    t.integer  "flux_id"
    t.integer  "seconds"
    t.float    "ppm"
    t.string   "comment",          limit: 255
    t.integer  "vial"
    t.integer  "run_id"
    t.integer  "compound_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "area"
    t.string   "type",             limit: 255
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

  create_table "permissions", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "plots", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "runs", force: :cascade do |t|
    t.date     "run_on"
    t.date     "sampled_on"
    t.string   "name",           limit: 50
    t.text     "comment"
    t.boolean  "approved",       default: false
    t.integer  "group_id"
    t.string   "study",          limit: 25
    t.boolean  "released",       default: false
    t.string   "workflow_state", limit: 255
    t.string   "setup_file",     limit: 255
    t.string   "data_file",      limit: 255
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data_files",     array: true
  end

  create_table "samples", force: :cascade do |t|
    t.string   "vial",          limit: 255
    t.integer  "run_id"
    t.datetime "sampled_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "uuid",          limit: 255
    t.integer  "incubation_id"
  end

  add_index "samples", ["incubation_id"], name: "index_samples_on_incubation_id", using: :btree
  add_index "samples", ["run_id", "vial"], name: "samples_run_id_vial_key", unique: true, using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255, null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "setups", force: :cascade do |t|
    t.integer  "template_id"
    t.date     "sample_date"
    t.string   "name",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "standard_curve_organizers", force: :cascade do |t|
    t.integer  "run_id"
    t.text     "curves"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "standard_curves", force: :cascade do |t|
    t.integer  "run_id"
    t.integer  "compound_id"
    t.float    "slope"
    t.float    "intercept"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "column"
    t.string   "coeff",       limit: 255
    t.datetime "acquired_at"
  end

  add_index "standard_curves", ["acquired_at"], name: "standard_curves_acquired_at_idx", using: :btree

  create_table "standards", force: :cascade do |t|
    t.integer  "standard_curve_id"
    t.integer  "compound_id"
    t.string   "vial",              limit: 255
    t.float    "ppm"
    t.float    "area"
    t.boolean  "excluded"
    t.datetime "starting_time"
    t.datetime "ending_time"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "column"
    t.datetime "acquired_at"
  end

  create_table "standards_old", id: false, force: :cascade do |t|
    t.integer "id",       default: "nextval('standards_old_id_seq'::regclass)", null: false
    t.float   "ppm"
    t.float   "response"
    t.boolean "exclude",  default: false
    t.text    "comment"
    t.integer "curve_id"
  end

  create_table "templates", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.string   "study",            limit: 255
    t.text     "plots"
    t.integer  "samples_per_plot"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "persistence_token",      limit: 255
    t.string   "password_salt",          limit: 255
    t.datetime "last_request_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   limit: 255
    t.string   "email",                  limit: 255
    t.string   "encrypted_password",     limit: 255
    t.string   "reset_password_token",   limit: 255
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
