Landlord::Engine.routes.draw do
  devise_for :users, class_name: "Landlord::User", module: :devise
  root 'accounts#new'
  resources :accounts, :path => '/' do
    get 'dashboard' => 'dashboard#index'
  end
end
