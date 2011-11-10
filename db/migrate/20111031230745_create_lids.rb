class CreateLids < ActiveRecord::Migration
  def change
    create_table :lids do |t|

      t.timestamps
    end
  end
end
