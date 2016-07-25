Landlord::Engine.routes.draw do

  # Load Devise routes inside Landlord engine
  devise_for :users, class_name: "Landlord::User", module: :devise, controllers: { invitations: 'devise/invitations' }

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
    patch 'settings' => 'accounts/settings#update', as: 'settings_update'

    get 'users' => 'accounts/users#index', as: 'users'
    post 'users' => 'accounts/users#create', as: 'new_users'
  end

end
