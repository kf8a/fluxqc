class CreateStandards < ActiveRecord::Migration
  def change
    create_table  :standards do |t|
      t.integer   :run_id
      t.integer   :compound_id
      t.float     :slope
      t.float     :intercept 

      t.timestamps
    end

    add_column :measurements, :standard_id, :integer
  end
end
