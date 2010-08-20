class Graph::UserNode
	include Neo4j::NodeMixin
	
	has_n(:follows).to(Graph::UserNode)
	has_n(:followed).from(Graph::UserNode, :follows)
	
	property :user_id
	
	def update_follows(friends)
		# 1. fetch all existing follows
		# 2. create new follows for new friends
		# 3. update old follows for old friends
		# 4. delete follows for removed friends
		
		desired_friend_ids = friends.map(&:user_node_id)
		
		Neo4j::Transaction.run do
			existing_friend_ids = follows.map(&:neo_id)
		
			(desired_friend_ids - existing_friend_ids).each do |neo_id|
				follows << Neo4j.load_node(neo_id)
			end
		
			(existing_friend_ids - desired_friend_ids).each do |neo_id|
				follows.rels[Neo4j.load_node(neo_id)].del
			end
		end
	end
	
	def add_follows(user)
		follows << Neo4j.load_node(user.user_node_id)
	end
	
	def to_hash
		{
			:user_id => user_id,
			:neo_id => neo_id
		}
	end
end
