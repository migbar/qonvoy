class RatingBird
  class << self
    def follow(screen_name)
      twitter.friendship_create(screen_name)
    end
    
    def twitter
      oauth = Twitter::OAuth.new(Settings.twitter.consumer_key, Settings.twitter.consumer_secret)
      oauth.authorize_from_access(Settings.twitter.user_key, Settings.twitter.user_secret)
      twitter = Twitter::Base.new(oauth)
    end
    
    def update(message)
      twitter.update(message)
    end
    
    # def fetch_direct_messages
    #   # for reach received dm:
    #   #   receive_direct_message
    # end
     
    def receive_direct_message(dm)
      user = User.find_by_twitter_uid(dm.sender_id)
      Status.create_and_process({
        :user               => user,
        :sender_screen_name => dm.sender_screen_name,
        :sender_id          => dm.sender_id,
        :body               => dm.text,
        :kind               => "dm",
        :status_created_at  => dm.created_at,
        :message_id         => dm.id,
        :raw                => dm.to_json
      })
    end
  end
  
end













