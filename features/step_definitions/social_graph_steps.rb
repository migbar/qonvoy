When /^the social graph is updated for "([^\"]*)"$/ do |screen_name|
  # User.find_by_screen_name(screen_name).update_social_graph!
  find_stubbed_twitter_user(screen_name).update_social_graph!
end
