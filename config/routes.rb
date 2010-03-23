ActionController::Routing::Routes.draw do |map|
  map.root :controller => "site"
  map.resource :profile, :controller => "users", :only => [:create, :edit, :update]
  map.resources :places, :only => [:edit, :update] do |place|
    place.resources :dishes, :only => [:show]
  end
  map.resources :statuses, :only => [:show, :update]
  map.resource :user_session
end
