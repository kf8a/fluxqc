class AddFilesToRun < ActiveRecord::Migration
  def change
    add_column :runs, :setup_file, :string
    add_column :runs, :data_file, :string
  end
end
