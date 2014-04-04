class AddSampledAtToStandardCurve < ActiveRecord::Migration
  def change
    add_column :standard_curves, :sampled_at, :timestamp
  end
end
