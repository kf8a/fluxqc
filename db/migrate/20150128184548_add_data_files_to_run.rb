class AddDataFilesToRun < ActiveRecord::Migration
  def change
    add_column :runs, :data_files, :string, array: true
  end
end
