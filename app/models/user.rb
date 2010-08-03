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
#  user_node_id        :integer(4)
#

class User < ActiveRecord::Base
  include ActionController::UrlWriter

	belongs_to :user_node
  
  acts_as_authentic

	after_create :ensure_user_node
  
  INTEREST_GROUPS = %w[cuisine feature neighborhood dish_type]
  
  class << self
    def interest_groups
      INTEREST_GROUPS
    end
  end
  
  interest_groups.each do |group|
    acts_as_taggable_on group.pluralize
    
    define_method(:"#{group}=") do |csv|
      send(:"#{group}_list=", csv.split(',').map(&:strip))
    end

    define_method(:"#{group}") do
      send(:"#{group}_list").sort.join(', ')
    end
  end
  
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
    twitter_api.update(subject)
  end
	
	def update_social_graph!
		rating_bird_users = User.find_by_twitter_uid(twitter_api.friends.map(&:id))
		graph_api.add_or_update_followees(self, rating_bird_users)
	end
	
	def graph_api
		@graph_api ||= GraphClient.new
	end
	
	def twitter_api
		@twitter_api ||= RatingBird.client(oauth_token, oauth_secret)
	end

	def node_creation_attributes
		{ :ar_id => id }
	end

  private

		def ensure_user_node
			# make sure that the cuisine, neighborhood, feature, dish_type nodes
			# that this user is associated with are there
			# result = UserNode.create(node_creation_attributes) 
			# self.user_node_id = result.id
			self.user_node = create_user_node(node_creation_attributes)
			# Hack Alert !
			# We don't want to trigger the OAuth validation on the nested save.
			# So we save the old controller, nil it out so that the OAuth code wont run,
			# then put it back after our save has completed.
			controller = session_class.controller 
			session_class.controller = nil
			save!
			session_class.controller = controller
		end

    def authenticate_with_oauth
      super # oauth_token is set
      populate_oauth_user if twitter_uid.blank?
    end
end
