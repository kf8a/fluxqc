class CreateLids < ActiveRecord::Migration
  def change
    create_table :lids do |t|
      t.float   :surface_area
      t.string  :name
      t.float   :volume
      t.float   :height 

      t.timestamps
    end
  end
end
