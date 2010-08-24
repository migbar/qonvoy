module Graph
	class CuisineNode
		include Neo4j::NodeMixin
		
		property :name
	
		has_n(:favored).from(UserNode)
	end
end
