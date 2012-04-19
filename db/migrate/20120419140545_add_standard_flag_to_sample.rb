class AddStandardFlagToSample < ActiveRecord::Migration
  def change
    add_column :samples, :is_standard, :boolean, :default=>false
  end
end
