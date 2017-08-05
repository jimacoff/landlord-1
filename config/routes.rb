Landlord::Engine.routes.draw do

  # Root - Show authenticated users their list of accounts
  authenticated :user do
    root 'accounts#index', as: :authenticated_root
  end

  # Root - Redirect unauthenticated users the sign in form
  root to: redirect('/users/sign_in'), as: :unauthenticated_root

  # Stripe - Load StripeEvent route for Stripe webhooks
  post 'stripe_event', to: 'stripe_webhook#event'

  # Users - Load Devise routes inside Landlord engine
  devise_for :users, class_name: 'Landlord::User', module: :devise, skip: :registrations, controllers: { invitations: 'devise/invitations', omniauth_callbacks: 'users/omniauth_callbacks' }

  # Users - Profile views
  resource :profile, controller: 'profile', only: [:edit, :update]

  # Accounts - Created/canceled confirmations
  get 'created', to: 'accounts/created#index', as: 'account_created'
  get 'canceled', to: 'accounts/canceled#index', as: 'account_canceled'



  # Accounts - Scoped routes (/:account_id/foo)
  resources :accounts, :path => '/' do

    # Account cancellation form
    get 'cancel', to: 'accounts#cancel', as: 'cancel'

    # Account billing form
    resource :billing, controller: 'accounts/billing', only: [:edit, :update]

    # Account receipts
    resources :receipts, controller: 'accounts/receipts', only: [:index, :show]

    # Account settings form
    resource :settings, controller: 'accounts/settings', only: [:edit, :update]

    # Account user memberships
    resources :memberships, controller: 'accounts/memberships', only: [:index, :create, :edit, :update, :destroy]

  end

end
