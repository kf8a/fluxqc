class AddColumnToSample < ActiveRecord::Migration
  def change
    add_column :measurements, :column, :integer
    add_column :standards, :column, :integer
  end
end
