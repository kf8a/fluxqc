class CreateCalibrations < ActiveRecord::Migration
  def change
    create_table :calibrations do |t|
      t.integer :standard_curve_id
      t.integer :measurement_id
      t.timestamps
    end
  end
end
