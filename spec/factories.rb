Factory.define(:user) do |f|
  f.location "NY"
end

Factory.define(:twitter_user, :parent => :user) do |f|
  f.sequence(:name) {|i| "twitter_guy_#{i}"}
  f.sequence(:twitter_uid) {|i| i}
  f.avatar_url {|twitter_user| "http://a3.twimg.com/profile_images/#{twitter_user.twitter_uid}/images-2_normal.jpeg"}
  f.oauth_token {|twitter_user| "#{twitter_user.name}_token"}
  f.oauth_secret {|twitter_user| "#{twitter_user.name}_secret"}
end