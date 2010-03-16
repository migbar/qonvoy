module RatingBirdTwitter
  def stub_ratingbird_twitter_following
    RatingBird.class_eval do
      def self.follow(screen_name)
        TwitterQueue.friendships["ratingbird"] << screen_name
      end
    end
  end
  
  def stub_ratingbird_twitter_update
    RatingBird.class_eval do
      def self.update(message)
        puts "message: #{message}"
        receiver = message[/@(\w+)/, 1]
        TwitterQueue.add(receiver, message, "ratingbird")
      end
    end
  end
end

World(RatingBirdTwitter)