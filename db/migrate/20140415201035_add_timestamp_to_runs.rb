class AddTimestampToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :created_at, :timestamp
    add_column :runs, :updated_at, :timestamp
  end
end
