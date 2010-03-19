class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.references :dish

      t.integer :value

      t.timestamps
    end
    add_index :ratings, :dish_id
  end

  def self.down
    drop_table :ratings
  end
end
