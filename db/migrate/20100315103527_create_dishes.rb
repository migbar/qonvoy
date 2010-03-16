class CreateDishes < ActiveRecord::Migration
  def self.up
    create_table :dishes do |t|
      t.references :place
      t.string :name
      t.integer :rating

      t.timestamps
    end
    
    add_index :dishes, :name
    add_index :dishes, :place_id
    add_index :dishes, [:place_id, :name]
  end

  def self.down
    drop_table :dishes
  end
end
