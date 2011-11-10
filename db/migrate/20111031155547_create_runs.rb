class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.string    :name
      t.string    :workflow_state

      t.timestamps
    end
  end
end
