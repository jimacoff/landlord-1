module Landlord
  class ApplicationController < ActionController::Base
    layout 'layouts/application'

    def current_account
      @current_account
    end

    helper_method :current_account

    def current_membership
      @current_membership
    end

    helper_method :current_membership

    def require_account
      get_current_account_and_membership
      if !@current_account
        redirect_to accounts_path # User does not belong to the requested account
      end
    end

    helper_method :require_account

    def require_active_account
      get_current_account_and_membership
      if !@current_account
        redirect_to accounts_path # User does not belong to the requested account
      else
        if @current_account.status == 'past_due' || @current_account.status == 'unpaid'
          if @current_membership.is_owner
            redirect_to account_billing_path(@current_account), alert: "Your account is past due. Please enter payment details to reactivate."
          else
            redirect_to account_past_due_path(@current_account), alert: "This account is past due. Please contact your account owner (#{@current_account.owner.first_name} #{@current_account.owner.last_name})."
          end
        end
      end
    end

    helper_method :require_active_account

    private

      def get_current_account_and_membership
        if !@current_account
          authenticate_user!
          account_id = params[:account_id]
          if current_user && account_id
            @current_account = current_user.accounts.not_canceled.find_by(id: account_id)
          end
          if @current_account
            @current_membership = Membership.find_by(user: current_user, account: @current_account)
          end
        end
      end

  end
end
