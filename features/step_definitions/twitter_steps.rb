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
      oauth_controller.redirect_to "/account?oauth_token=foo&oauth_verifier=bar"
    end

    def authenticate_with_oauth
      self.twitter_uid  = "12355434"
      self.screen_name  = user_twitter_name
      self.oauth_token  = "foo"
      self.oauth_secret = "bar"
    end
  end
end

Given /^a Twitter user "([^\"]*)" registered with Qonvoy$/ do |name|
  Given %Q{a twitter user "#{name}" exists with oauth_token: "foo", oauth_secret: "secret", screen_name: "#{name}", name: "#{name}", avatar_url: "http://a3.twimg.com/profile_images/63673063/images-2_normal.jpeg"}
  
  UserSession.class_eval do
    def redirect_to_oauth
      oauth_controller.session[:oauth_callback_method] = "POST"
      oauth_controller.session[:oauth_request_class] = self.class.name
      oauth_controller.redirect_to "/user_session?oauth_token=foo&oauth_verifier=bar"
    end

    def authenticate_with_oauth
      self.attempted_record = User.find_by_oauth_token("foo")
    end
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
      oauth_controller.redirect_to "/account?denied=foo"
    end
 end
end

Given /^I am a logged in as the Twitter user "([^\"]*)"$/ do |name|
   Given %Q{a Twitter user "#{name}" registered with Qonvoy}
   Given %Q{I am on the home page}
   Given %Q{I press "Let me log in using Twitter"}
end
