class GraphClient
	include GraphAccessor
	
	node_accessor :restaurant
	# node_accessor :restaurant, :locally_tracked => true # builds the ar_id (or data_mapper_id) into the CRUD for tracking .. ?
	node_accessor :neighborhood
	node_accessor :person
	node_accessor :cuisine
	node_accessor :feature
	node_accessor :tweet
	
	rel_accessor :person, 			:follows, 		:person 			# from Twitter
	# rel_accessor :person, 			:follows, 		:person, 			:when => lambda{ Date.today }  # from Twitter
	rel_accessor :person, 			:likes, 			:cuisine      # derived from the rating
	rel_accessor :person, 			:favors, 			:cuisine      # from profile interests
	rel_accessor :person, 			:dislikes, 		:cuisine      # from profile interests? (or derived?)
	rel_accessor :person, 			:rates, 			:restaurant   # from rating
	rel_accessor :restaurant, 	:serves, 			:cuisine      # from Zagat
	rel_accessor :restaurant, 	:offers, 			:feature      # from Zagat
	rel_accessor :cuisine, 			:tastes_like, :cuisine      # from Domain knowledgeable Admin or derived from user
	rel_accessor :restaurant, 	:resembles, 	:restaurant   # duplicate rel types ok?
	rel_accessor :person, 			:frequents, 	:neighborhood # derived from user activity
	rel_accessor :person, 			:likes_geo, 	:neighborhood # from profile interests
	rel_accessor :neighborhood, :contains, 		:restaurant   # from Zagat, address
	rel_accessor :restaurant, 	:exists_in,		:neighborhood # from Zagat, address (reverse of above - needed?)
	

	def add_or_update_followees(follower, followees)
		# 1 - get current followees
		# get_relationships(me.node_id, :type => "follows")
		# get_person_follows_person_rel(me.node_id)
		followees.each do |followee|
			create_person_follows_person_rel(follower, followee)
		end
	end
end

