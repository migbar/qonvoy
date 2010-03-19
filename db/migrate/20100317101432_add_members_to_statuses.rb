class AddMembersToStatuses < ActiveRecord::Migration
  def self.up
    add_column :statuses, :dish_id, :integer
    add_column :statuses, :place_id, :integer
    add_column :statuses, :rating_id, :integer
    
    add_index :statuses, :dish_id
    add_index :statuses, :place_id
  end

  def self.down
    remove_column :statuses, :rating_id
    remove_column :statuses, :place_id
    remove_column :statuses, :dish_id
  end
end
