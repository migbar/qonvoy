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
#  persistence_token   :string(255)     not null, indexed
#  single_access_token :string(255)     not null, indexed
#  perishable_token    :string(255)     not null, indexed
#  oauth_token         :string(255)     indexed
#  oauth_secret        :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

class User < ActiveRecord::Base
  include ActionController::UrlWriter
  
  acts_as_authentic
  
  acts_as_taggable_on :cuisines
  acts_as_taggable_on :neighborhoods
  has_many :statuses
  
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
  
  def follow_me
    RatingBird.follow(screen_name)
  end
  
  def update_status_with_rating(status)
    update_status("#{status.body} #ratingbird #{place_dish_url(status.place, status.dish, :host => Settings.host)}")
  end
  
  def update_status(subject)
    send_later(:perform_twitter_update, subject)
  end
  
  def perform_twitter_update(subject)
    RatingBird.client(oauth_token, oauth_secret).update(subject)
  end
  
  def cuisine=(csv)
    self.cuisine_list = csv.split(',').map(&:strip)
  end
  
  def cuisine
    cuisine_list.sort.join(', ')
  end

  private
    def authenticate_with_oauth
      super # oauth_token is set
      populate_oauth_user if twitter_uid.blank?
    end
end
