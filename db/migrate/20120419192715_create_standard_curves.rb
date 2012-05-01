class CreateStandardCurves < ActiveRecord::Migration
  def change
    create_table  :standard_curves do |t|
      t.integer   :run_id
      t.integer   :compound_id
      t.float     :slope
      t.float     :intercept 

      t.timestamps
    end
  end
end
