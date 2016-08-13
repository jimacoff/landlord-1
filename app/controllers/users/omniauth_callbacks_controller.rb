module Landlord
  class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      auth_data = request.env["omniauth.auth"]
      auth_params = request.env['omniauth.params']

      from = auth_params['from']
      if !from
        from = 'sign_in'
      end

      if from == 'sign_in'
        # Callback is from sign in; lookup user and redirect
        user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)
        if user
          if !user.confirmed?
            user.confirm
          end
          sign_in_and_redirect user, :event => :authentication
        else
          redirect_to new_user_session_path, notice: 'No login exists for this Google Account'
        end
      elsif from == 'sign_up'
        # Callback is from signup; create user, account, membership, and Google token
        user = User.init_from_google_oauth2(auth_data)
        if user
          company_name = auth_params['account']['name']
          plan_id = auth_params['account']['plan_id']

          account = Account.new(name: company_name, plan_id: plan_id)
          account.memberships.new(user: user)

          if account.save
            Landlord::AccountMailer.welcome(account).deliver_later

            sign_in user
            redirect_to account_path(account), notice: 'Welcome to your new account!'
          else
            flash[:notice] = 'Error creating account'
            redirect_to new_account_path
          end
        else
          flash[:notice] = 'Could not authenticate Google Account'
          redirect_to new_account_path
        end
      end
    end
  end
end