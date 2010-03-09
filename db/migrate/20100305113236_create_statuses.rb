class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.references :user
      t.string :sender_screen_name
      t.integer :sender_id, :limit => 8
      t.string :body, :limit => 1000
      t.string :kind, :limit => 40
      t.datetime :status_created_at
      t.integer :message_id, :limit => 8
      t.text :raw

      t.timestamps
    end
    add_index :statuses, :user_id
    add_index :statuses, :message_id
  end

  def self.down
    drop_table :statuses
  end
end
