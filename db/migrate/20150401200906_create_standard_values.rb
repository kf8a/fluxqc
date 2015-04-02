class CreateStandardValues < ActiveRecord::Migration
  def change
    create_table :standard_values do |t|
      t.text :name
      t.integer :set
      t.float :n2o
      t.float :co2
      t.float :ch4
      t.datetime :valid_from
      t.datetime :valid_to

      t.timestamps null: false
    end
  end
end
