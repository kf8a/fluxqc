class AddFilePositionToMeasurements < ActiveRecord::Migration
  def change
    add_column :measurements, :acquired_at , :datetime
    add_column :standards, :acquired_at , :datetime
  end
end
