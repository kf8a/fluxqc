class CreateCompounds < ActiveRecord::Migration
  def change
    create_table :compounds do |t|
      t.string   :name
      t.float    :ymin
      t.float    :ymax
      t.string   :unit

      t.timestamps
    end
  end
end
