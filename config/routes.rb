ActionController::Routing::Routes.draw do |map|
  map.root :controller => "site"
  map.resource :account, :controller => "users", :only => [:create]
end
