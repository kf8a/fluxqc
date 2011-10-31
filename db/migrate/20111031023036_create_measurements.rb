class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.integer   :flux_id
      t.float     :seconds
      t.float     :ppm
      t.float     :area
      t.datetime  :starting_time
      t.datetime  :ending_time

      t.timestamps
    end
  end
end
