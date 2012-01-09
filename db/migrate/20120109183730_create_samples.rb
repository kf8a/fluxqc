class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.integer :vial
      t.timestamp :sampled_date

      t.timestamps
    end

    add_column :measurements, :sample_id, :integer
  end
end
