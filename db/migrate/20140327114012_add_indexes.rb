class AddIndexes < ActiveRecord::Migration
  def change
    add_index :measurements, :sample_id
    add_index :measurements, :compound_id
    add_index :samples, :incubation_id
  end
end
