class AddColumnToStandardCurve < ActiveRecord::Migration
  def change
    add_column :standard_curves, :column, :integer
  end
end
