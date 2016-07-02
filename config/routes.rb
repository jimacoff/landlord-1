Landlord::Engine.routes.draw do
  root 'accounts#new'
  resources :accounts, :path => '/' do
    get 'dashboard' => 'dashboard#index'
  end
end
