Factory.define(:user) do |f|
  f.location "NY"
end

Factory.define(:twitter_user, :parent => :user) do |f|
  f.sequence(:screen_name) {|i| "twitter_guy_#{i}"}
  f.name { |u| "#{u.screen_name} Name" }
  f.sequence(:twitter_uid) {|i| i}
  f.avatar_url {|twitter_user| "http://a3.twimg.com/profile_images/#{twitter_user.twitter_uid}/images-2_normal.jpeg"}
  f.oauth_token {|twitter_user| "#{twitter_user.name}_token"}
  f.oauth_secret {|twitter_user| "#{twitter_user.name}_secret"}
end

Factory.define(:status) do |f|
  f.sequence(:sender_screen_name) { |i| "twitter_guy_#{i}" }
end

Factory.define(:processed_status, :parent => :status) do |f|
  f.processed_at 1.hour.ago
end

Factory.define(:dm_status, :parent => :status) do |f|
  f.kind "dm"
end

Factory.define(:place) do |f|
  f.sequence(:name) { |i| "Place ##{i}" }
  f.latitude 41.132945
  f.longitude -23.12934
end

Factory.define(:dish) do |f|
  f.sequence(:name) { |i| "Dish #{i}"}
end

Factory.define(:rating) do |f|
  f.value rand() * 100
end