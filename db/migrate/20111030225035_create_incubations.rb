class CreateIncubations < ActiveRecord::Migration
  def change
    create_table :incubations do |t|
      t.datetime :sampled_at
      t.string   :chamber

      t.timestamps
    end
  end
end
