class Graph::UserNode
	include Neo4j::NodeMixin
	
	def update_follows(friends)
		return true
		
		# PENDING
		
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
		return []
		
		# PENDING
		@follows ||= Follow.find(:all, :from => self)
	end
end
