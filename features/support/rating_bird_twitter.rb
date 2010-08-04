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
		twitter_user = User.find_by_screen_name(screen_name)
		stubbed_twitter_users[screen_name] = twitter_user
		
		list_of_friends_return_by_twitter = twitter_users.map { |sn|
			uid = User.find_by_screen_name(sn).try(:twitter_uid) || mock_model(User).id
			Hashie::Mash.new(:id => uid, :screen_name => sn)
		}
		
		twitter_user.stub_chain(:twitter_api, :friends).and_return(list_of_friends_return_by_twitter)
	end
	
	def find_stubbed_twitter_user(screen_name)
		stubbed_twitter_users[screen_name]
	end
	
	def stubbed_twitter_users
		@stubbed_twitter_users ||= {}
	end
end

World(RatingBirdTwitter)