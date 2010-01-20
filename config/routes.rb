ActionController::Routing::Routes.draw do |map|
  map.root :controller => "site"
  map.registration "/register", :controller => "users", :action => "new"
end
