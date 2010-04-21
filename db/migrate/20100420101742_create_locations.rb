class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :provider
      t.string :zip
      t.decimal :latitude, :precision => 10, :scale => 8
      t.decimal :longitude, :precision => 12, :scale => 8
      t.string :district
      t.string :state
      t.string :province
      t.string :country
      t.string :city
      t.string :street_address
      t.string :full_address
      t.string :country_code
      t.integer :accuracy
      t.string :precision
      t.text :bounds
      
      t.references :place
      
      t.timestamps
    end
    remove_column :places, :latitude  
    remove_column :places, :longitude
    
    add_index :locations, :place_id
  end

  def self.down
    add_column :places, :longitude, :decimal,      :precision => 12, :scale => 8
    add_column :places, :latitude, :decimal,       :precision => 10, :scale => 8
    drop_table :locations
  end
end
