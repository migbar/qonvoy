Given /^a Twitter user "([^\"]*)" that is not registered with Qonvoy$/ do |twitter_name|

  UserSession.class_eval do
    def redirect_to_oauth
      oauth_controller.session[:oauth_callback_method] = "POST"
      oauth_controller.session[:oauth_request_class] = self.class.name
      oauth_controller.redirect_to "/user_session?oauth_token=foo&oauth_verifier=bar"
    end

    def authenticate_with_oauth
      self.errors.add_to_base("Could not find user in our database")
    end
  end
  
  User.class_eval do
    define_method("user_twitter_name") do
      twitter_name
    end
    
    def redirect_to_oauth
      oauth_controller.session[:oauth_callback_method] = "POST"
      oauth_controller.session[:oauth_request_class] = self.class.name
      oauth_controller.redirect_to "/profile?oauth_token=foo&oauth_verifier=bar"
    end

    def authenticate_with_oauth
      self.twitter_uid  = "12355434"
      self.screen_name  = user_twitter_name
      self.oauth_token  = "foo"
      self.oauth_secret = "bar"
    end
  end
  
  stub_ratingbird_twitter_following
end
 
Given /^a Twitter user "([^\"]*)" registered with Qonvoy$/ do |name|
  Given %Q{a twitter user "#{name}" exists with screen_name: "#{name}", name: "#{name}", avatar_url: "http://a3.twimg.com/profile_images/63673063/images-2_normal.jpeg"}
  
  UserSession.class_eval do
		define_method("user_twitter_name") do
      name
    end
		
    def redirect_to_oauth
      oauth_controller.session[:oauth_callback_method] = "POST"
      oauth_controller.session[:oauth_request_class] = self.class.name
      oauth_controller.redirect_to "/user_session?oauth_token=foo&oauth_verifier=bar"
    end

    def authenticate_with_oauth
      self.attempted_record = User.find_by_oauth_token("#{user_twitter_name}_token")
    end
  end
  
  stub_ratingbird_twitter_update
  stub_user_twitter_update
end

Given /^the following Twitter users are registered with RatingBird$/ do |table|
  table.raw.each do |row|
  	twitter_screen_name = row[0]
			Given %Q{a Twitter user "#{twitter_screen_name}" registered with Qonvoy}
  end
end

Given /^a Twitter user that denies access to Qonvoy$/ do
  UserSession.class_eval do
    def redirect_to_oauth
      oauth_controller.session[:oauth_callback_method] = "POST"
      oauth_controller.session[:oauth_request_class] = self.class.name
      oauth_controller.redirect_to "/user_session?denied=foo"
    end
  end
  
  User.class_eval do
    def redirect_to_oauth
      oauth_controller.session[:oauth_callback_method] = "POST"
      oauth_controller.session[:oauth_request_class] = self.class.name
      oauth_controller.redirect_to "/profile?denied=foo"
    end
 end
end

Given /^I am a logged in as the Twitter user "([^\"]*)"$/ do |name|
   Given %Q{a Twitter user "#{name}" registered with Qonvoy}
   Given %Q{I am on the home page}
   Given %Q{I press "Let me log in using Twitter"}
   @twitter_guy = name
   set_current_user(name)
end

Given /^I register as "([^\"]*)" using Twitter$/ do |name|
  Given %Q{a Twitter user "#{name}" that is not registered with Qonvoy}
   When %Q{I am on the home page}
   When %Q{I press "Register using Twitter"}
end

Then /^my Twitter status should be "([^\"]*)"$/ do |text|  
  @my_status = TwitterQueue.status_for(@twitter_guy)
  @my_status.should match(/#{text}/)
end

When /^I click the first link in my status$/ do
  link = URI.extract(@my_status).first
  visit link
end

Then /^Qonvoy should be following "([^\"]*)"$/ do |screen_name|
  TwitterQueue.friendships["ratingbird"].should include(screen_name)
end

When /^I direct message Ratingbird with "([^\"]*)"$/ do |message|
  TwitterQueue.add_dm(User.find_by_screen_name(@twitter_guy), "ratingbird", message)
end

Then /^I should have a reply from "([^\"]*)" with "([^\"]*)"$/ do |sender, reply|
  TwitterQueue.for_user(@twitter_guy).any? do |status|
    status[:sender_screen_name] == sender &&
      status[:text] =~ /#{Regexp.escape(reply)}/ && @the_reply = status
  end.should be_true
end

When /^I click the first link in the reply$/ do
  link = URI.extract(@the_reply[:text]).first
  visit link
end

Given /^"([^\"]*)" is following the following Twitter users:$/ do |twitter_name, users_table|
  stub_twitter_followees(twitter_name, users_table.raw.flatten)
end