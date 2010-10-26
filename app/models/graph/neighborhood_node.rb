module Graph
  class NeighborhoodNode
    include Neo4j::NodeMixin
  
    property :name
    has_n(:likes_geo).from(UserNode)
	
  end
end