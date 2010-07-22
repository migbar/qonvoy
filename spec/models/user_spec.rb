# == Schema Information
#
# Table name: users
#
#  id                  :integer(4)      not null, primary key
#  name                :string(255)
#  twitter_uid         :string(255)
#  avatar_url          :string(255)
#  screen_name         :string(255)
#  location            :string(255)
#  persistence_token   :string(255)     default(""), not null, indexed
#  single_access_token :string(255)     default(""), not null, indexed
#  perishable_token    :string(255)     default(""), not null, indexed
#  oauth_token         :string(255)     indexed
#  oauth_secret        :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

require 'spec_helper'

describe User do
  include ActionController::UrlWriter
  
  should_have_column :persistence_token, :single_access_token, :perishable_token, 
                     :oauth_token, :oauth_secret,
                     :name, :screen_name, :avatar_url, :twitter_uid, :location,
                     :type => :string
  
  should_validate_presence_of :screen_name
  
  describe "associations" do
    should_have_many :statuses
    User.interest_groups.each do |group|
      should_have_many :"#{group.pluralize}", :through => :"#{group}_taggings"
    end
  end
  
  it "#to_s returns the screen_name for the user" do
    user = User.new
    user.screen_name = "bob"
    user.to_s.should == 'bob'
  end
  
  it "is valid as a twitter user" do
    user = Factory.create(:twitter_user)
    user.should_not be_new_record
  end
  
  describe "#using_twitter?" do
    it "returns true if OAuth token is set" do
      user = Factory.build(:twitter_user)
      user.using_twitter?.should be_true
    end
  end
  
  describe "#populate_oauth_user" do
    before(:each) do
      @user = Factory.build(:twitter_user, :twitter_uid => nil)
      @user.stub!(:access_token).and_return("the-access-token")
      @twitter_response = mock("Twitter HTTP Response", :body => "{}")
      UserSession.stub_chain(:oauth_consumer, :request).and_return(@twitter_response)
    end
    
    it "does nothing if not using Twitter" do
      user = Factory.build(:user)
      UserSession.oauth_consumer.should_not_receive(:request)
      user.populate_oauth_user
    end
    
    it "fetches the user profile information from Twitter if using OAuth" do
      UserSession.oauth_consumer.
        should_receive(:request).
        with(:get, '/account/verify_credentials.json', @user.send(:access_token), { :scheme => :query_string }).
        and_return(@twitter_response)
      
      @user.populate_oauth_user
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
      
      @user.populate_oauth_user
    end
  end
  
  it "#authenticate_with_oauth calls super and #populate_oauth_user when registering" do
    pending "DEBT: speccing requires authlogic_oauth mocking"
  end
  
  it "#follow_me" do
    user = Factory.build(:twitter_user)
    RatingBird.should_receive(:follow).with(user.screen_name)
    user.follow_me
  end
  
  describe "#update_status_with_rating" do
    before(:each) do
      @user = Factory.build(:twitter_user)
      @place = Factory.create(:place)
      @dish = Factory.create(:dish, :place => @place) 
      @status = Factory.build(:status, :body => "Blah blah", :place => @place, :dish => @dish)
    end
    
    it "updates the user's Twitter status with the origina message decorated with #ratingbird and a link to the dish page" do
      @user.should_receive(:update_status).with("#{@status.body} #ratingbird #{place_dish_url(@place, @dish, :host => Settings.host)}")
      @user.update_status_with_rating(@status)
    end
  end
  
  it "#update_status enqueues perform_twitter_update" do 
    @user = Factory.build(:twitter_user)
    @user.should_receive(:send_later).with(:perform_twitter_update, "the status")
    @user.update_status("the status")
  end
  
	describe "#twitter_api" do
    subject { Factory.build(:twitter_user) }
		let(:twitter_client) { mock("RatingBird") }
		
	  it "builds and memoizes the creation of the RatingBird client with the user's oauth_token and oauth_secret " do
	    RatingBird.should_receive(:client).with(subject.oauth_token, subject.oauth_secret).once.and_return(twitter_client)
			subject.twitter_api.should == twitter_client
			subject.twitter_api.should == twitter_client
	  end
	end
	
	describe "#graph_client" do
    subject { Factory.build(:twitter_user) }
		let(:graph_client) { mock("GraphClient") }
		
	  it "instantiates and memoizes the graph client" do
	    GraphClient.should_receive(:new).once.and_return(graph_client)
			subject.graph_api.should == graph_client
			subject.graph_api.should == graph_client
	  end
	end
	
  describe "#perform_twitter_update" do
		let(:twitter_client) {mock("RatingBird", :update => nil)}
		
    before(:each) do
      @user = Factory.build(:twitter_user)
    	@user.stub(:twitter_api => twitter_client)
		end
    
    it "authorizes the user with the RatingBird Twitter client using the token and secret" do
			@user.should_receive(:twitter_api).and_return(twitter_client)
      @user.perform_twitter_update("the status")
    end
    
    it "updates the status using the client" do
      twitter_client.should_receive(:update).with("the status")
      @user.perform_twitter_update("the status")
    end
  end
  
  User.interest_groups.each do |group|
    
    describe "##{group}" do
      it "returns a comma joined sorted list of #{group.pluralize}" do
        @user = Factory.build(:twitter_user, :"#{group}_list" => ["foo", "bar", "baz"])
        @user.send(group).should == "bar, baz, foo"
      end
    end
    
    describe "##{group}=" do
      subject { Factory.create(:twitter_user) }
      it "creates #{group.pluralize} associated with the user from a comma separated list" do
        subject.send(:"#{group}=", "foo, bar, baz")
        subject.save
        subject.send(group.pluralize).map(&:name).should include(*%w[foo bar baz])
        
      end
    end
    
  end

	describe "#update_social_graph!" do
		subject {Factory.build(:twitter_user)}
		let(:twitter_api){mock("twitter_api")}
		let(:friends) { YAML.load(File.read(File.dirname(__FILE__) + "/../fixtures/friends/hyewyetest1.yml")) }
		let(:ratingbird_users) { (1..3).map { mock_model(User) } }
		let(:graph_api) {mock("GraphClient")}
		
		before(:each) do
		  subject.stub(:twitter_api => twitter_api)
		  subject.stub(:graph_api => graph_api)
			twitter_api.stub(:friends => friends)
			User.stub(:find_by_twitter_uid => ratingbird_users)
			graph_api.stub(:add_or_update_followees)
		end
	  
		it "fetches the twitter friends" do
	    twitter_api.should_receive(:friends).and_return(friends)
			subject.update_social_graph!
	  end
	
		it "looks for the Twitter friends which have RatingBird accounts" do
		  User.should_receive(:find_by_twitter_uid).with(friends.map(&:id)).and_return(ratingbird_users)
			subject.update_social_graph!
		end
		
		it "updates the RatingBird graph with the Twitter friends that are also in RatingBird" do
			graph_api.should_receive(:add_or_update_followees).with(subject, ratingbird_users).and_return(true)
			subject.update_social_graph! 
		end
	end

end
