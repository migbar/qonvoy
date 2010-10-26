Given /^the nodes for the following (\w+) exist$/ do |match, table|
  Neo4j::Transaction.run do
    table.hashes.each do |hash|
      Graph::Mapping.node_class_for(match.singularize).new(hash)
    end
  end
end