class AddSampledAtToStandardCurve < ActiveRecord::Migration
  def change
    add_column :standard_curves, :acquired_at, :timestamp
  end
end
