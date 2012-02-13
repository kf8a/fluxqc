class CreatePlots < ActiveRecord::Migration
  def change
    create_table :plots do |t|
      t.string :name

      t.timestamps
    end
  end
end
