class Settings < Settingslogic
  source "#{Rails.root}/config/application.yml"
  namespace Rails.env

	class << self
		def node_graph_root
			graph_db_root.gsub(":rails_root", Rails.root).gsub(":rails_env", Rails.env)
		end
	end
end