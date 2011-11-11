class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.date      :sampled_on
      t.date      :run_on
      t.string    :study
      t.text      :comment
      t.string    :name
      t.string    :workflow_state
      t.boolean   :released

      t.timestamps
    end
  end
end
