class UserNode < ActiveResource::Base
	self.site = "http://localhost:8988/n/"	
	self.element_name = "user"	
	self.format = :json
	set_primary_key "node_id"
	
	# Hack to get around rails bug - see rails ticket:
	# https://rails.lighthouseapp.com/projects/8994/tickets/3527-undefined-method-destroyed-for-activerecordassociationsbelongstoassociation
	def destroyed?
		false
	end
end