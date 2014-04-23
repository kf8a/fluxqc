class RenameSampledAtToAquiredAt < ActiveRecord::Migration
  def change
    rename_column :standard_curves, :sampled_at, :acquired_at
  end
end
