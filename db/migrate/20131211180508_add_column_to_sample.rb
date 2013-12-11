class AddColumnToSample < ActiveRecord::Migration
  def change
    add_column :samples, :column, :integer
  end
end
