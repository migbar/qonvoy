class RenameUserNodeIdToNodeId < ActiveRecord::Migration
  def self.up
		rename_column :users, :user_node_id, :node_id
  end

  def self.down
		rename_column :users, :node_id, :user_node_id
  end
end
