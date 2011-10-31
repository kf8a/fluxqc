class CreateFluxes < ActiveRecord::Migration
  def change
    create_table :fluxes do |t|
      t.integer  :incubation_id
      t.string   :compound
      t.float    :value

      t.timestamps
    end
  end
end
