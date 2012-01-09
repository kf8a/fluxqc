class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.string :vial
      t.integer :run_id
      t.timestamp :sampled_at

      t.timestamps
    end

    add_column :measurements, :sample_id, :integer
  end
  def up 
    remove_column :measuremnts, :vial
  end

  def down
    add_column :measurements, :vial,:string
  end
end
