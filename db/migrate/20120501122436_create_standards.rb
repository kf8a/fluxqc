class CreateStandards < ActiveRecord::Migration
  def change
    create_table :standards do |t|
      t.integer   :standard_curve_id
      t.integer   :compound_id
      t.string    :vial
      t.float     :ppm
      t.float     :area
      t.boolean   :excluded
      t.datetime  :starting_time
      t.datetime  :ending_time

      t.timestamps
    end
  end
end
