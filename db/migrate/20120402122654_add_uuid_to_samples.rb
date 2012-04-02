class AddUuidToSamples < ActiveRecord::Migration
  def change
    add_column :samples, :uuid, :string

  end
end
