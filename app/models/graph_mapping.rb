class GraphMapping
# {
# 	  :follows     => { :person       => :person       }, # from Twitter
# 	  :likes       => { :person       => :cuisine      }, # derived from the rating of the dish
# 	  :favors      => { :person       => :cuisine      }, # from profile interests
# 	  :dislikes    => { :person       => :cuisine      }, # from profile interests or derived?
# 	  :rates       => { :person       => :restaurant   }, # from rating
# 	  :serves      => { :restaurant   => :cuisine      }, # from Zagat
# 	  :offers      => { :restaurant   => :feature      }, # from Zagat
# 	  :tastes_like => { :cuisine      => :cuisine      }, # from Domain knowledgeable Admin or derived from user
# 	  :resembles   => { :restaurant   => :restaurant   }, # duplicate rel types ok?
# 		:frequents   => { :person       => :neighborhood }, # from user activity
# 		:likes_geo   => { :person       => :neighborhood }, # from profile interests
# 		:contains    => { :neighborhood => :restaurant   }, # from Zagat, address
# 		:lives_in    => { :restaurant   => :neighborhood } # from Zagat, address (reverse of above - needed?)
# 	}
	
	
	MAPPING = {
		:person => {
			:likes => :cuisine,
			:follows => :person,
			:favors => :cuisine,
			:dislikes => :cuisine,
			:rates => :restaurant,
			:frequents => :neighborhood,
			:likes_geo => :neighborhood
		},
		:restaurant => {
			:serves => :cuisine,
			:offers => :feature,
			:resembles => :restaurant,
			:lives_in =>  :neighborhood
		}
		:cuisine => {
			:tastes_like => :cuisine
		}
		:neighborhood => {
			:contains => :restaurant
		}
	}
end