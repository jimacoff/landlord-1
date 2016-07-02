Landlord::Engine.routes.draw do
  devise_for :users, class_name: "Landlord::User", module: :devise

  # Show authenticated users their list of accounts
  authenticated :user do
    root 'accounts#index', as: :authenticated_root
  end

  # Redirect unauthenticated users the sign in form
  root :to => redirect('/users/sign_in')
  
  resources :accounts, :path => '/' do
    # Account-scoped controllers go here
  end
end
