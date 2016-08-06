Landlord::Engine.routes.draw do

  namespace :accounts do
    get 'receipts/index'
  end

  namespace :accounts do
    get 'receipts/show'
  end

  # Root - Show authenticated users their list of accounts
  authenticated :user do
    root 'accounts#index', as: :authenticated_root
  end

  # Root - Redirect unauthenticated users the sign in form
  root :to => redirect('/users/sign_in')

  # Success message for new account creation
  get '/new/success', to: 'accounts#success', as: 'new_account_success'

  # Load Devise routes inside Landlord engine
  devise_for :users, class_name: "Landlord::User", module: :devise, controllers: { invitations: 'devise/invitations' }

  # Load StripeEvent route for Stripe webhooks
  post 'stripe_event', to: 'stripe_webhook#event' #mount StripeEvent::Engine, at: '/stripe_webhook'

  resources :accounts, :path => '/' do
    # Account-scoped controllers go in here

    get 'settings' => 'accounts/settings#index', as: 'settings'
    patch 'settings' => 'accounts/settings#update', as: 'settings_update'

    get 'billing' => 'accounts/billing#edit'
    resource :billing, :controller => 'accounts/billing', only: [:update]

    get 'users' => 'accounts/users#index', as: 'users'
    post 'users' => 'accounts/users#create', as: 'new_users'
  end

end
