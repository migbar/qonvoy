class AddMoreFieldsToPlace < ActiveRecord::Migration
  def self.up
    add_column :places, :z_id, :integer
    add_column :places, :phone, :string
    add_index :places, :z_id
  end

  def self.down
    remove_column :places, :phone
    remove_column :places, :z_id
  end
end
