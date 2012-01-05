class CreateIncubations < ActiveRecord::Migration
  def change
    create_table :incubations do |t|
      t.datetime :sampled_at
      t.string   :chamber
      t.string   :treatment
      t.string   :replicate
      t.float    :soil_temperature
      t.float    :avg_height_cm

      t.integer  :lid_id
      t.integer  :run_id

      t.timestamps
    end
  end
end
