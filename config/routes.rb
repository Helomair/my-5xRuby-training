Rails.application.routes.draw do
  controller :sessions do
  	get 'login' => :login
  	post 'login' => :verify
  	delete 'logout' => :destroy
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :tasks
  root "tasks#index"


end
