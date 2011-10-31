class CreateIncubations < ActiveRecord::Migration
  def change
    create_table :incubations do |t|
      t.datetime :sampled_at
      t.string   :chamber
      t.string   :plot
      t.float    :soil_temperature
      t.float    :average_height_cm

      t.integer  :lid_id
      t.integer  :run_id

      t.timestamps
    end
  end
end
