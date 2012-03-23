class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :name
      t.string :study
      t.text :plots
      t.integer :samples_per_plot

      t.timestamps
    end
  end
end
