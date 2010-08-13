ActionController::Routing::Routes.draw do |map|
  map.root :controller => "main"
  
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  
  map.resources :user_sessions
  map.resources :users, :has_many => [:tweets, :statuses, :stories, :bookmarks], :shallow => true
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect ':username', :controller => "users", :action => "show"
end
