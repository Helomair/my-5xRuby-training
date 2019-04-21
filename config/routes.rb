Rails.application.routes.draw do
	match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all
  match "/401", :to => "errors#no_permission", :via => :all
	controller :sessions do
  		get 'login' => :new
    	post 'login' => :create
    	delete 'logout' => :destroy
  	end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  	resources :tasks
  	resources :admins
  	root "tasks#index"
end
