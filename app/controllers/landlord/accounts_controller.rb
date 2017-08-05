require_dependency 'landlord/application_controller'

module Landlord
  class AccountsController < ApplicationController
    prepend_before_action :set_account_id, only: [:show, :destroy]
    before_action :authenticate_user!, only: [:index]
    before_action :require_active_account, only: [:show]
    before_action :require_account_owner, only: [:destroy]

    # List the signed-in user's accounts
    # GET /
    def index
      @accounts = current_user.accounts.not_canceled
      redirect_to account_path(@accounts.first) unless @accounts.size == 1
    end

    # Show the new account signup form
    # GET /new
    def new
      @account = Account.new
      @account.memberships.build.build_user
      @plans = Plan.all
    end

    # Create a new account
    # POST /
    def create
      @account = Account.new(account_params)

      if @account.save
        AccountMailer.welcome(@account).deliver_later

        if current_user && @account.owner == current_user
          # User is already signed in and owns the account
          redirect_to @account, notice: 'Welcome to your new account!'
        else
          # User is not signed in or specified another user as the account owner
          redirect_to account_created_path
        end
      else
        @plans = Plan.all
        render :new
      end
    end

    # Show a single account's dashboard page
    # GET /1
    def show
    end

    # Destroy account
    # DELETE /1
    def destroy
      @current_account.cancel

      AccountMailer.canceled(@current_account).deliver_later

      redirect_to account_canceled_path, notice: 'Account was successfully canceled.'
    end

    private

      # The application controller needs the :id resource to be named :account_id
      def set_account_id
        params[:account_id] = params[:id]
      end

      def account_params
        user_attributes = [:first_name, :last_name, :email, :password]
        memberships_attributes = [user_attributes: [:first_name, :last_name, :email, :password]]
        params.require(:account).permit(:name, :plan_id, memberships_attributes: memberships_attributes)
      end

  end
end
