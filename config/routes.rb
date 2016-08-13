Landlord::Engine.routes.draw do

  # Root - Show authenticated users their list of accounts
  authenticated :user do
    root 'accounts#index', as: :authenticated_root
  end

  # Root - Redirect unauthenticated users the sign in form
  root :to => redirect('/users/sign_in'), as: :unauthenticated_root

  # Success message for new account creation
  get '/new/success', to: 'accounts#success', as: 'new_account_success'

  # Success message for account cancellation
  get 'canceled', to: 'accounts#canceled', as: 'canceled', as: 'account_canceled'

  # Load Devise routes inside Landlord engine
  devise_for :users, class_name: "Landlord::User", module: :devise, skip: :registrations, controllers: { invitations: 'devise/invitations', :omniauth_callbacks => "users/omniauth_callbacks" }

  # User profile edit/update
  resource :profile, :controller => 'profile', only: [:edit, :update]

  # Load StripeEvent route for Stripe webhooks
  post 'stripe_event', to: 'stripe_webhook#event' #mount StripeEvent::Engine, at: '/stripe_webhook'



  resources :accounts, :path => '/' do
    # Account-scoped controllers go in here

    # Account cancellation form
    get 'cancel' => 'accounts#cancel', as: 'cancel'

    # get 'settings' => 'accounts/settings#index', as: 'settings'
    # patch 'settings' => 'accounts/settings#update', as: 'settings_update'

    # get 'billing' => 'accounts/billing#edit'
    # resource :billing, :controller => 'accounts/billing', only: [:update]

    # get 'users' => 'accounts/users#index', as: 'users'
    # post 'users' => 'accounts/users#create', as: 'new_users'

    # resources :receipts, :controller => 'accounts/receipts', only: [:index, :show]
    # resource :billing_info, :controller => 'accounts/billing_info'
  end

end
