require_dependency "landlord/application_controller"

module Landlord
  class AccountsController < ApplicationController
    prepend_before_action :set_account_id
    before_action :authenticate_user!, only: [:index]
    before_action :require_active_account, only: [:show]

    # List the logged-in user's accounts
    def index
      @accounts = current_user.accounts.not_canceled
      if @accounts.size == 1
        redirect_to account_path @accounts.first
      end
    end

    def new
      @account = Account.new
      @account.memberships.build.build_user
      @plans = Plan.all
    end

    def create
      @account = Account.new(account_params)

      respond_to do |format|
        if @account.save
          AccountMailer.welcome(@account).deliver_later

          if current_user && @account.owner == current_user
            format.html { redirect_to @account }
            format.json { render :show, status: :created, location: @account }
          else
            format.html { redirect_to new_account_success_path }
            format.json { render :show, status: :created, location: @account }
          end
        else
          @plans = Plan.all
          format.html { render :new }
          format.json { render json: @account.errors, status: :unprocessable_entity }
        end
      end
    end

    def success
    end

    def show
    end

    private

      def set_account_id
        params[:account_id] = params[:id]
      end

      def account_params
        params.require(:account).permit(:name, :plan_id, memberships_attributes: [ user_attributes: [ :first_name, :last_name, :email, :password ] ])
      end

  end
end
