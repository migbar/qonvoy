module RatingBirdTwitter
  def stub_ratingbird_twitter_following
    RatingBird.class_eval do
      def self.follow(screen_name)
        TwitterQueue.friendships["ratingbird"] << screen_name
      end
    end
  end
end

World(RatingBirdTwitter)