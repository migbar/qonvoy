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
        receiver = message[/@(\w+)/, 1]
        TwitterQueue.add(receiver, message, "ratingbird")
      end
    end
  end
  
  def stub_user_twitter_update
    User.class_eval do
      def update_status(status)
        TwitterQueue.update_status(screen_name, status)
      end
    end
  end

	def stub_twitter_followees(screen_name, twitter_users)
		# Stub out the Twitter response using webmock
	end
end

World(RatingBirdTwitter)