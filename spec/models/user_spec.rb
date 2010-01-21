require 'spec_helper'

describe User do
  should_have_column :persistence_token, :single_access_token, :perishable_token, 
                     :oauth_token, :oauth_secret,
                     :name, :screen_name, :avatar_url, :twitter_uid, :location,
                     :type => :string

  it "#to_s returns the screen_name for the user" do
    user = User.new
    user.screen_name = "bob"
    user.to_s.should == 'bob'
  end
  
  describe "#using_twitter?" do
    it "returns true if OAuth token is set" do
      user = Factory.build(:twitter_user)
      user.using_twitter?.should be_true
    end
  end
  
  describe "populate user data from Twitter profile" do
    describe "on save" do
      it "does not overwrite existing data" do
        user = Factory.create(:twitter_user)
        UserSession.oauth_consumer.should_not_receive(:request)
        user.save
      end
    end
    
    describe "on create" do
      before(:each) do
        @user = Factory.build(:twitter_user, :twitter_uid => nil)
        @user.stub!(:access_token).and_return("the-access-token")
        @twitter_response = mock("Twitter HTTP Response", :body => "{}")
        UserSession.stub_chain(:oauth_consumer, :request).and_return(@twitter_response)
      end
      
      it "does nothing if not using Twitter" do
        user = Factory.build(:user)
        UserSession.oauth_consumer.should_not_receive(:request)
        user.save
      end
      
      it "fetches the user profile information from Twitter if using OAuth" do
        UserSession.oauth_consumer.
          should_receive(:request).
          with(:get, '/account/verify_credentials.json', @user.send(:access_token), { :scheme => :query_string }).
          and_return(@twitter_response)
        
        @user.save
      end
      
      it "sets the user's attributes to the ones in the user's Twitter profile" do
        attribute_mapping = {
          :name => "name",
          :id => "twitter_uid",
          :screen_name => "screen_name",
          :location => "location",
          :profile_image_url => "avatar_url"
        }
        
        fetched_attributes = {
          :name => "Twitter Guy",
          :screen_name => "twitter_guy",
          :id => "123456",
          :profile_image_url => "http://twitter.com/123456/avatar.png",
          :location => "NY"
        }
        
        @twitter_response.should_receive(:is_a?).and_return(true)
        @twitter_response.stub!(:body).and_return(fetched_attributes.to_json)
        
        fetched_attributes.each do |key, value|
          @user.should_receive("#{attribute_mapping[key]}=").with(value)
        end
        
        @user.save
      end
      
      
    end
  end
end
