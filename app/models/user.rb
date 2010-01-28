class User < ActiveRecord::Base
  acts_as_authentic
  
  acts_as_taggable_on :interests
  
  validates_presence_of :screen_name
  
  def to_s
    screen_name
  end
  
  def using_twitter?
    !oauth_token.blank?
  end

  def populate_oauth_user
    if using_twitter?
      @response = UserSession.oauth_consumer.request(:get, '/account/verify_credentials.json',
      access_token, { :scheme => :query_string })
      if @response.is_a?(Net::HTTPSuccess)
        user_info = JSON.parse(@response.body)
        
        self.name        = user_info['name']
        self.twitter_uid = user_info['id']
        self.avatar_url  = user_info['profile_image_url']
        self.screen_name = user_info['screen_name']
        self.location    = user_info['location']
      end
    end
  end

  private
    def authenticate_with_oauth
      super # oauth_token is set
      populate_oauth_user if twitter_uid.blank?
    end
end
