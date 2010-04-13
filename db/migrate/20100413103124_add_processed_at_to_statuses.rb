class AddProcessedAtToStatuses < ActiveRecord::Migration
  def self.up
    add_column :statuses, :processed_at, :datetime
    add_index :statuses, :processed_at
    remove_column :statuses, :processed
  end

  def self.down
    add_column :statuses, :processed, :boolean
    remove_column :statuses, :processed_at
  end
end
