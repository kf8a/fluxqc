class CreateLids < ActiveRecord::Migration
  def change
    create_table :lids do |t|
      t.float   :surface_area

      t.timestamps
    end
  end
end
