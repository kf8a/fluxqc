class AddSamplesToIncubations < ActiveRecord::Migration
  def change
    add_column :samples, :incubation_id, :integer
  end
end
