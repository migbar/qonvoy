When /^the social graph is updated for "([^\"]*)"$/ do |screen_name|
  find_stubbed_twitter_user(screen_name).update_social_graph!
end

Then /^"([^"]*)" should have nodes with follows on these RatingBird users:$/ do |screen_name, table|
  user = User.find_by_screen_name(screen_name)
	table.raw.each do |row|
		friend_sn = row.first
		friend = User.find_by_screen_name(friend_sn)
		user.follows.include?(friend)
	end
end
