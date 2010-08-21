class Admin::GraphNodesController < ApplicationController
	layout "admin"
	around_filter :neo_tx
	
	def index
		@stats = {}
    @stats[:nodes] = Neo4j.number_of_nodes_in_use
		@stats[:path]  = Neo4j::Config[:storage_path]
		@stats[:version] = Neo4j::VERSION
		@stats[:lucene_path] = Lucene::Config[:storage_path] || "not avail."
		@stats[:lucene_store_on_file] = Lucene::Config[:store_on_file]
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