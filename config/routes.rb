ActionController::Routing::Routes.draw do |map|
  map.root :controller => "main"
  
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  
  map.resources :user_sessions
  map.resources :user
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
