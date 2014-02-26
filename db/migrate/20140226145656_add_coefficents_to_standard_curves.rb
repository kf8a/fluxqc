class AddCoefficentsToStandardCurves < ActiveRecord::Migration
  def change
    add_column :standard_curves, :coeff, :string
  end
end
