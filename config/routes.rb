ActionController::Routing::Routes.draw do |map|
  map.root :controller => "site"
  map.resource :profile, :controller => "users", :only => [:create, :edit, :update]
  map.resources :places, :controller => "places", :only => [:edit, :update]
  map.resource :user_session
end
