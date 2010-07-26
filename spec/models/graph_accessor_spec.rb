require 'spec_helper'

describe GraphAccessor do
	class TestGraphClient; include GraphAccessor; end
	
	subject { TestGraphClient.new }
	let(:nodes_url) { mock("nodes_url") }
	let(:node_url) { mock("node_url") }
	let(:relationships_url) { mock("relationships_url") }
	
	before(:each) do
	  subject.stub(:nodes_url => nodes_url)
	end
	
  describe "#perform_request" do
		let(:parsed_response) { { :foo => "bar" } }
		let(:json_response)   { parsed_response.to_json }
		
		before(:each) do
		  RestClient.stub(:get => json_response)
		end
		
    it "sends the verb to the Rest client with the arguments" do
			RestClient.should_receive(:get).with("url","bar").and_return(json_response)
      subject.perform_request(:get, "url", "bar")
    end

		it "parses the JSON response and returns it" do
		  JSON.should_receive(:parse).with(json_response).and_return(parsed_response)
			subject.perform_request(:get, "url", "bar").should == parsed_response
		end
  end

	it "#get_nodes performs a get request to the nodes url" do
	  subject.should_receive(:perform_request).with(:get, nodes_url, :ids => [1,2,3], :type => "Restaurant")
		subject.get_nodes(:ids => [1,2,3], :type => "Restaurant")
	end
	
	it "#get_node performs a get request to the nodes url with the specified id" do
		subject.should_receive(:node_url).with("node_id").and_return(node_url)
    subject.should_receive(:perform_request).with(:get, node_url)
		subject.get_node("node_id")
  end
 
	it "#create_node calls #create_nodes with an array containing its params" do
    subject.should_receive(:create_nodes).with([:type => "restaurant", :name => "Nobu"])
		subject.create_node(:type => "restaurant", :name => "Nobu")
  end
	
	it "#create_nodes performs a post request to the nodes url with an array of parameter hashes" do
	  subject.should_receive(:perform_request).with(:post, nodes_url, [{:type => "restaurant", :name => "Nobu"}, {:type => "neighborhood", :name => "LES"}])
		subject.create_nodes([{:type => "restaurant", :name => "Nobu"}, {:type => "neighborhood", :name => "LES"}])
	end
	
	it "#update_node calls update nodes with an array containing a hash with the specified id and properties to be updated" do
	  subject.should_receive(:update_nodes).with([{:id => "node_id", :property => "some_property"}])
		subject.update_node("node_id", :property => "some_property")
	end
	
	it "#update_nodes performs a put request to the nodes_url with an array of parameter hashes" do
	  subject.should_receive(:perform_request).with(:put, nodes_url, [{:id => "42", :name => "Nobu"}, {:id => "43", :name => "LES"}])
		subject.update_nodes([{:id => "42", :name => "Nobu"}, {:id => "43", :name => "LES"}])
	end
	
	it "#delete_node calls #delete_nodes with an array containing the id" do
	  subject.should_receive(:delete_nodes).with(["42"])
		subject.delete_node("42")
	end
	
	it "#delete_nodes performs a delete request to the nodes_url with an array of node ids" do
	  subject.should_receive(:perform_request).with(:delete, nodes_url, ["42", "43"])
		subject.delete_nodes(["42", "43"])
	end
	
	it "#get_relationship calls #get_relationships with the specified to_node and rel_name" do
	  subject.should_receive(:get_relationships).with("adam", :type => "follows", :to => "bob")
		subject.get_relationship("adam", "follows", "bob")
	end
	
	# the following makes no sense:
	# 	subject.get_relationships("adam", :type => "likes", :to => "nobu")
	# because 'adam' can only have ONE relationship of type 'likes' to 'nobu'
	# instead, we could leave it as:
	# subject.get_relationships("adam", :type => "likes")
	# so that the sugary version of it can be
	# subject.get_person_likes_rels("adam")
	# QUESTION: WHAT TO DO WITH ANY OTHER POSSIBLY PRESENT PARAMS ? (use them as a filter? addl search criteria?)
	it "#get_relationships performs a get request to the relationships_url of the specified node with the specified params" do
		subject.should_receive(:relationships_url).with("adam").and_return(relationships_url)
		subject.should_receive(:perform_request).with(:get, relationships_url, :type => "likes")
	  subject.get_relationships("adam", :type => "likes")
	end
	
	it "#create_relationships performs a post request to the relationships_url of the specified node with the specified params" do
	  subject.should_receive(:relationships_url).with("from_node").and_return(relationships_url)
		create_options = {:rates => { "nobu" => {:when => Date.today}, "haru" => { :when => 1.day.ago } }}
		subject.should_receive(:perform_request).with(:post, relationships_url, create_options)
	  subject.create_relationships("from_node", create_options)
	end
	
	it "#create_relationship performs a post request to the relationships_url of the specified node with the to_node and rel_name specified" do
	  subject.should_receive(:relationships_url).with("fred").and_return(relationships_url)
		create_options = {:when => Date.today}
		subject.should_receive(:perform_request).with(:post, relationships_url, create_options.merge(:type => "rates", :to => "nobu"))
	  subject.create_relationship("fred", "rates", "nobu", create_options)
	end
	
	#update rels goes here ...

	it "#delete_relationship performs a delete request to the relationships_url of the specified node with the specified to_node and rel_name" do
	  subject.should_receive(:relationships_url).with("fred").and_return(relationships_url)
		subject.should_receive(:perform_request).with(:delete, relationships_url, {:type => "likes", :to => "haru"})
		subject.delete_relationship("fred", "likes", "haru")
	end
	
	# see graph_accessor_thoughts on bulk operations.
	# right now the sematics are that you can only supply a from_node and a rel_name(type) and those (OUTBOUND) rels will be deleted 
	it "#delete_relationship performs a delete request to the relationships_url of the specified node with the specified rel_name" do
	  subject.should_receive(:relationships_url).with("fred").and_return(relationships_url)
		subject.should_receive(:perform_request).with(:delete, relationships_url, :type => "likes")
		subject.delete_relationships("fred", "likes")
	end
end

# possible evolution into a DSL:
#
# user = User.find(..)
# user.node.followees
# 
# class User
# 	is_neo_node do |n|
# 		n.relationship :likes, :cuisine
# 		n.relationship :likes, :restaurant
# 		n.relationship :follows, :user
# 	end
# end
# 
# user.node.likes_cuisines
# user.node.follows_users
# user.node.create_or_update_follows_users()
# 
# class Restaurant
# 	is_neo_node
# end