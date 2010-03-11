class CreatePlaces < ActiveRecord::Migration
  def self.up
    create_table :places do |t|
      t.string :name
      t.text :address
      t.decimal :latitude, :precision => 10, :scale => 8
      t.decimal :longitude, :precision => 12, :scale => 8

      t.timestamps
    end
    add_index :places, :name
  end

  def self.down
    drop_table :places
  end
end
