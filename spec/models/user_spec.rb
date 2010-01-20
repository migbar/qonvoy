require 'spec_helper'

describe User do
  should_have_column :persistence_token, :single_access_token, :perishable_token, 
                     :oauth_token, :oauth_secret,
                     :name, :screen_name, :avatar_url, :twitter_uid, :location,
                     :type => :string
end
