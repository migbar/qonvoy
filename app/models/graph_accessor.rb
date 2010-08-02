module GraphAccessor
	
	def self.included(cls)
		cls.extend ClassMethods
	end
	
	module ClassMethods
		def node_accessor(node_type)
			
			# INDEX
			# required: (none)
			# optional: params (additional criteria to match on)
			# Example:
			# graph_api.get_restaurant_nodes
			# - or - 
			# graph.api.get_restaurant_nodes(:accepts_credit_cards => "true")
			#
			define_method(:"get_#{node_type}_nodes") do |*args|
				params = args.extract_options!
				get_nodes(params.merge(:type => node_type.to_s))
	    end
	
			# CREATE
			# required: name
			# optional: params
			# Example:
			# graph_api.create_restaurant_node("Nobu", :ar_id => 123)
			# should result in :
			# create_node(:type => "restaurant", :name => "Nobu", :ar_id => 123)
	    define_method(:"create_#{node_type}_node") do |*args|
				params = args.extract_options!
				node_name = *args # enforces node_name to be present
				create_node(params.merge(:type => node_type.to_s, :name => node_name))
	    end
	
			# UPDATE
			# required: node_id (the neo4j node id to fetch)
			# Example:
			# graph_api.update_restaurant_node(123, :accepts_credit_cards => "true")
	    define_method(:"update_#{node_type}_node") do |node_id, params|
				update_node(node_id, params)
	    end
	
			# DESTROY
			# required: node_id (the neo4j node id to fetch)
			# Example:
			# graph_api.delete_person_node(456)
	    define_method(:"delete_#{node_type}_node") do |node_id|
				delete_node(node_id)
	    end
	  end

		def rel_accessor(from, rel, to)
			define_method(:"get_#{from}_#{rel}_#{to}_rel") do |from_node, to_node |
				get_relationships(from_node, :type => rel)
			end
			define_method(:"create_#{from}_#{rel}_#{to}_rel") do |from_node, to_node, params |
				create_relationship(from_node, to_node, rel, params)
			end
			define_method(:"update_#{from}_#{rel}_#{to}_rel") do |from_node, to_node, params |
				update_relationship(from_node, to_node, rel, params)
			end
			define_method(:"delete_#{from}_#{rel}_#{to}_rel") do |from_node, to_node |
				delete_relationship(from_node, to_node, rel)
			end
		end
	end
	
	def get_nodes(params)
    perform_request(:get, nodes_url, params)
  end

  def get_node(node_id)
    perform_request(:get, node_url(node_id))
  end

  def create_node(params)
    create_nodes([params])
  end

	def create_nodes(params)
    perform_request(:post, nodes_url, params)
  end

  def update_node(node_id, params)
    update_nodes([params.merge(:id => node_id)])
  end

  def update_nodes(params)
    perform_request(:put, nodes_url, params)
  end

  def delete_node(node_id)
    delete_nodes([node_id])
  end
	
	def delete_nodes(params)
		perform_request(:delete, nodes_url, params)
	end

	def get_relationship(from, rel, to)
		get_relationships(from, :type => rel, :to => to)
	end
	
	def get_relationships(from_node, params)
		perform_request(:get, relationships_url(from_node), params)
	end
	
	# create_person_follows_person_rel(me, fred, :when => Date.today)
	# create_person_follows_people_rels(me, fred => { :when => Date.today }, tom => { :when => 1.day.ago })
	# create_relationship(me, fred, follows, :when => Date.today)
	# create_relationships(me, :rates => {nobu => {:when => Date.today}}, {haru => {}},3], :likes => [5,6,7])
	#
	def create_relationships(from_node, params)
		perform_request(:post, relationships_url(from_node), params)
	end
	
	def create_relationship(from_node, rel_name, to_node, params={})
		perform_request(:post, relationships_url(from_node), params.merge(:type => rel_name, :to => to_node))
	end
	
	def update_relationship(from_node, rel_name, to_node, params)
		perform_request(:put, relationships_url(from_node), params.merge(:to => to_node, :type => rel_name))
	end
	
	def delete_relationship(from_node, rel_name, to_node)
		delete_relationships(from_node, [{:to => to_node, :type => rel_name}])
	end
	
	def delete_relationships(from_node, params)
		perform_request(:delete, relationships_url(from_node), params)		
	end

	
	def perform_request(verb, url, *args)
		JSON.parse RestClient.send(verb, url, *args)
	end

	private
		def relationships_url(from_node)
			sprintf(Settings.graph.relationships_url, from_node)
		end
		
		def nodes_url
			Settings.graph.nodes_url
		end
		
		def node_url(node_id)
			sprintf(Settings.graph.node_url, node_id)
		end
	
end