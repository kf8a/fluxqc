class CreateSetups < ActiveRecord::Migration
  def change
    create_table :setups do |t|
      t.integer :template_id
      t.date :sample_date
      t.string :name

      t.timestamps
    end
  end
end
