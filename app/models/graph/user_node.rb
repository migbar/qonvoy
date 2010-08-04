class Graph::UserNode < ActiveResource::Base
	self.site = "http://localhost:8988/n/"
	self.element_name = "user"	
	self.format = :json
	set_primary_key "node_id"

	# Hack to get around rails bug - see rails ticket:
	# https://rails.lighthouseapp.com/projects/8994/tickets/3527-undefined-method-destroyed-for-activerecordassociationsbelongstoassociation
	def destroyed?
		false
	end
	
	def update_follows(friends)
		# 1. fetch all existing follows
		# 2. create new follows for new friends
		# 3. update old follows for old friends
		# 4. delete follows for removed friends
		
		desired_friend_ids = friends.map(&:user_node_id)
		existig_friend_ids = follows.map(&:to_id)
		
		desired_friend_ids.each do |friend_id|
			Follow.create(:from_id => self.id, :to_id => friend_id) unless existig_friend_ids.include(friend_id)
		end
		
		follows.each do |follow|
			follow.destroy unless desired_friend_ids.include(follow.to_id)
		end
	end
	
	def follows
		@follows ||= Follow.find(:all, :from => self)
	end
end
