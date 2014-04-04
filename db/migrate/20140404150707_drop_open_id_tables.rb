class DropOpenIdTables < ActiveRecord::Migration
  def change
    drop_table :open_id_authentication_associations
    drop_table :open_id_authentication_nonces
    remove_column :users, :openid_identifier
  end
end
