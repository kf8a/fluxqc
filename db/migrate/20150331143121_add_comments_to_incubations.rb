class AddCommentsToIncubations < ActiveRecord::Migration
  def change
    add_column :incubations, :comments, :text
  end
end
