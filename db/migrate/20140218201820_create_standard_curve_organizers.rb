class CreateStandardCurveOrganizers < ActiveRecord::Migration
  def change
    create_table :standard_curve_organizers do |t|
      t.integer :run_id
      t.text :curves

      t.timestamps
    end
  end
end
