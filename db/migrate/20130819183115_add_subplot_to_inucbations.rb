class AddSubplotToInucbations < ActiveRecord::Migration
  def change
    add_column :incubations, :sub_plot, :string
  end
end
