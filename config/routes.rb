Landlord::Engine.routes.draw do

  # Load Devise routes inside Landlord engine
  devise_for :users, class_name: "Landlord::User", module: :devise

  # Root - Show authenticated users their list of accounts
  authenticated :user do
    root 'accounts#index', as: :authenticated_root
  end

  # Root - Redirect unauthenticated users the sign in form
  root :to => redirect('/users/sign_in')

  # Success message for new account creation
  get '/new/success', to: 'accounts#success', as: 'new_account_success'
  
  resources :accounts, :path => '/' do
    # Account-scoped controllers go here
    get 'settings' => 'accounts/settings#index', as: 'settings'
  end

end
