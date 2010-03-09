require File.dirname(__FILE__) + "/../config/environment"
require "#{File.dirname(__FILE__)}/config_store"
require 'pp'
 
config = ConfigStore.new("#{ENV['HOME']}/.twitter")
oauth = Twitter::OAuth.new(Settings.twitter.consumer_key, Settings.twitter.consumer_secret)
 
if config['atoken'] && config['asecret']
  oauth.authorize_from_access(config['atoken'], config['asecret'])
  twitter = Twitter::Base.new(oauth)
  pp twitter.friends_timeline
  
elsif config['rtoken'] && config['rsecret']  
  oauth.authorize_from_request(config['rtoken'], config['rsecret'], '1369040')
  twitter = Twitter::Base.new(oauth)
  pp twitter.friends_timeline
  
  config.update({
    'atoken'  => oauth.access_token.token,
    'asecret' => oauth.access_token.secret,
  }).delete('rtoken', 'rsecret')
else
  config.update({
    'rtoken'  => oauth.request_token.token,
    'rsecret' => oauth.request_token.secret,
  })
  
  # authorize in browser
  %x(open #{oauth.request_token.authorize_url})
end