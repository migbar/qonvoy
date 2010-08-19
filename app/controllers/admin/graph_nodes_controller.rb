class Admin::GraphNodesController < ApplicationController
	around_filter :neo_tx
	
	def index
		@nodes = []
		Neo4j.all_nodes {|n| puts "node is #{n} - coll is #{@nodes}"; @nodes << n.to_hash}
	end

private
  def neo_tx
    Neo4j::Transaction.new
    yield
    Neo4j::Transaction.finish
  end



end