class AddAquiredToCheckStandards < ActiveRecord::Migration
  def change
    add_column :check_standards, :aquired_at, :date
  end
end
