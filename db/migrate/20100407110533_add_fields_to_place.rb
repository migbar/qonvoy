class AddFieldsToPlace < ActiveRecord::Migration
  def self.up
    add_column :places, :z_food, :integer
    add_column :places, :z_decor, :integer
    add_column :places, :z_service, :integer
    add_column :places, :z_price, :integer
  end

  def self.down
    remove_column :places, :z_price
    remove_column :places, :z_service
    remove_column :places, :z_decor
    remove_column :places, :z_food
  end
end
