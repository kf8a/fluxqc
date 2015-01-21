class CreateDataFiles < ActiveRecord::Migration
  def change
    create_table :data_files do |t|
      t.integer :run_id
      t.timestamps null: false
    end
  end
end
