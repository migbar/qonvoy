class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :name       
      t.string    :twitter_uid
      t.string    :avatar_url 
      t.string    :screen_name
      t.string    :location   
      t.string    :persistence_token,   :null => false
      t.string    :single_access_token, :null => false
      t.string    :perishable_token,    :null => false
      t.string    :oauth_token
      t.string    :oauth_secret
      t.timestamps
    end
    
    add_index :users, :persistence_token
    add_index :users, :single_access_token
    add_index :users, :perishable_token
    add_index :users, :oauth_token
  end

  def self.down
    drop_table :users
  end
end
