ActionController::Routing::Routes.draw do |map|
  map.root :controller => "site"
  map.resource :profile, :controller => "users", :only => [:create, :edit, :update]
  map.resources :places, :only => [:show, :edit, :update] do |place|
    place.resources :dishes, :only => [:show]
  end
  map.resources :statuses, :only => [:edit, :update], :member => { :preview => :put }
  map.resource :user_session

	map.namespace :admin do |admin|
		admin.resources :graph_nodes
	end
end
