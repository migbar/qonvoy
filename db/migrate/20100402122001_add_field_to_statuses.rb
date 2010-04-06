class AddFieldToStatuses < ActiveRecord::Migration
  def self.up
    add_column :statuses, :processed, :boolean
    
    add_index :statuses, :processed
    add_index :statuses, [:processed, :user_id]
  end
  
  def self.down
    remove_column :statuses, :processed
  end
end
