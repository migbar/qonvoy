class Settings < Settingslogic
  source "#{Rails.root}/config/application.yml"
  namespace Rails.env

	class << self
		def node_graph_root
			File.join(graph_db_root, 'n') + '/'
		end
	end
end