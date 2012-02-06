class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.integer   :flux_id
      t.integer   :compound_id
      t.integer   :sample_id
      t.string    :vial
      t.float     :seconds
      t.float     :ppm
      t.float     :area
      t.string    :type
      t.boolean   :excluded
      t.datetime  :starting_time
      t.datetime  :ending_time

      t.timestamps
    end
  end
end
