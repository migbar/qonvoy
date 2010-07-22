When /^the social graph is updated for "([^"]*)"$/ do |screen_name|
  User.find_by_screen_name(screen_name).update_twitter_graph!
end