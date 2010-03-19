ActionController::Routing::Routes.draw do |map|
  map.root :controller => "site"
  map.resource :profile, :controller => "users", :only => [:create, :edit, :update]
  map.resources :places, :only => [:show] do |place|
    place.resources :dishes, :only => [:show]
  end
  
  map.resource :user_session
end
