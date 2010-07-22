module GraphAccessor
	
	def self.included(cls)
		cls.extend ClassMethods
	end
	
	module ClassMethods
		def node_accessor(node_type)
			define_method(:"get_#{node_type}_node") do |id|
				get_node(id)
	    end
	    define_method(:"create_#{node_type}_node") do |id, name|
				create_node(id, name, node_type)
	    end
	    define_method(:"update_#{node_type}_node") do |id, params|
				update_node(id, params)
	    end
	    define_method(:"delete_#{node_type}_node") do |id|
				delete_node(id)
	    end
	  end

		def rel_accessor(from, rel, to)
			define_method(:"get_#{from}_#{rel}_#{to}_rel") do |from_node, to_node |
				get_relationship(from_node, to_node, rel)
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
	
  def get_node(id)
    JSON.parse RestClient.get( nodes_url, :id => id)
  end

  def create_node(id, name, type)
    JSON.parse RestClient.post( nodes_url, :id => id, :name => name, :type => type)
  end

  def update_node(id, params)
    JSON.parse RestClient.put( nodes_url, params.merge(:id => id))
  end

  def delete_node(id)
    JSON.parse RestClient.delete( nodes_url, :id => id)
  end

	def get_relationship(from_node, to_node, rel_name)
		JSON.parse RestClient.get( relationships_url(from_node), :to => to_node.node_id, :type => rel_name)
	end
	
	def create_relationship(from_node, to_node, rel_name, options={})
		JSON.parse RestClient.post( relationships_url(from_node), options.merge(:to => to_node.node_id, :type => rel_name, :when => Time.now.to_s))
	end
	
	def update_relationship(from_node, to_node, rel_name, options={})
		JSON.parse RestClient.put( relationships_url(from_node), options.merge(:to => to_node.node_id, :type => rel_name, :when => Time.now.to_s))
	end
	
	def delete_relationship(from_node, to_node, rel_name)
		JSON.parse RestClient.delete( relationships_url(from_node), :to => to_node.node_id, :type => rel_name)		
	end
	
	private
		def relationships_url(from_node)
			sprintf(Settings.graph.relationships_url, from_node.node_id)
		end
		
		def nodes_url
			Settings.graph.nodes_url
		end
	
end