require 'spec_helper'

describe RatingBird do
  it "#follow uses the Twitter connection to follow the specified user" do
    twitter = mock(Twitter::Base)
    RatingBird.should_receive(:twitter).and_return(twitter)
    twitter.should_receive(:friendship_create).with("twitter_dude")
    RatingBird.follow("twitter_dude")
  end
  
  describe "#twitter" do
    before(:each) do
      @oauth = mock(Twitter::OAuth, :authorize_from_access => true)
      Twitter::OAuth.stub(:new).and_return(@oauth)
      @endpoint = mock(Twitter::Base)
      Twitter::Base.stub(:new).and_return(@endpoint)
    end
    
    it "builds a Twitter OAuth token for the application" do
      Twitter::OAuth.should_receive(:new).with(Settings.twitter.consumer_key, Settings.twitter.consumer_secret).and_return(@oauth)
      RatingBird.twitter
    end
    
    it "authorizes the RatingBird client" do
      @oauth.should_receive(:authorize_from_access).with(Settings.twitter.user_key, Settings.twitter.user_secret)
      RatingBird.twitter
    end
    
    it "builds and returns the Twitter endpoint for RatingBird" do
      Twitter::Base.should_receive(:new).with(@oauth).and_return(@endpoint)
      RatingBird.twitter.should == @endpoint
    end
  end
  
  describe "#receive_direct_message" do
    before(:each) do
      @dm = load_direct_message("ihoka_to_ratingbird")
      @user = mock_model(User)
      User.stub(:find_by_twitter_uid).and_return(@user)
      Status.stub(:create_and_process)
    end
    it "finds the sending user by their screen_name" do
      User.should_receive(:find_by_twitter_uid).with(@dm.sender_id).and_return(@user)
      RatingBird.receive_direct_message(@dm)
    end
    
    it "persists the direct message to the database" do
      Status.should_receive(:create_and_process).with(
        :user               => @user,
        :sender_screen_name => @dm.sender_screen_name,
        :sender_id          => @dm.sender_id,
        :body               => @dm.text,
        :kind               => "dm",
        :status_created_at  => @dm.created_at,
        :message_id         => @dm.id,
        :raw                => @dm.to_json
      )
      RatingBird.receive_direct_message(@dm)
    end
    
    def load_direct_message(name)
      YAML.load(File.read(File.dirname(__FILE__) + "/../fixtures/direct_messages/#{name}.yml"))
    end
  end
end
