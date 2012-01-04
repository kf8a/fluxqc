class CreateFluxes < ActiveRecord::Migration
  def change
    create_table :fluxes do |t|
      t.integer  :incubation_id
      t.float    :value
      t.integer  :compound_id

      t.timestamps
    end
  end
end
